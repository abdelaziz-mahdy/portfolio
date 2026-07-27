"""Generate the portfolio's static GitHub dataset.

The Flutter web app used to call api.github.com directly from the browser.
Unauthenticated browser calls are capped at 60 requests/hour per visitor IP,
so the portfolio rate-limited itself for anyone who reloaded a few times.

This script runs in CI with a token (5000 requests/hour) and writes the result
to assets/user_info.json, which the app then reads as static data.

Only PUBLIC data is ever written. Private repositories and pull requests
against private repositories are excluded at the query level and again by a
defensive filter before anything is serialised.
"""

import json
import os
from datetime import datetime, timezone

import requests

GITHUB_TOKEN = os.getenv('GITHUB_TOKEN')
HEADERS = {"Authorization": f"Bearer {GITHUB_TOKEN}"}

GRAPHQL_URL = 'https://api.github.com/graphql'

# The Flutter app bundles this directory and fetches the same paths from the
# CDN, so the dataset has to land here rather than in the repo root.
ASSET_DIR = 'assets'


class GraphQLError(Exception):
    """Raised when the GraphQL endpoint reports errors in a 200 response."""


def run_query(query):
    """Send a GraphQL query and return its `data` payload.

    GitHub answers GraphQL errors with HTTP 200 and an `errors` array, so the
    status code alone is not enough to tell success from failure.
    """
    response = requests.post(GRAPHQL_URL, json={'query': query}, headers=HEADERS)

    if response.status_code != 200:
        raise GraphQLError(
            f"Query failed with HTTP {response.status_code}: {response.text}"
        )

    payload = response.json()
    if payload.get('errors'):
        raise GraphQLError(f"Query returned errors: {payload['errors']}")

    return payload.get('data') or {}


def _repository_fields(with_deployments):
    """Fields selected for every repository node.

    `deployments` tells us whether GitHub Pages is live even when the repo has
    no homepage set. Tokens without deployment read access make the whole query
    fail, so callers can request the query without it and fall back.
    """
    deployments = """
                deployments(first: 1, environments: ["github-pages"]) {
                  totalCount
                }
    """ if with_deployments else ""

    return f"""
              name
              nameWithOwner
              url
              description
              isPrivate
              isArchived
              stargazerCount
              forkCount
              updatedAt
              homepageUrl
              owner {{ login }}
              primaryLanguage {{ name }}
              repositoryTopics(first: 6) {{
                nodes {{ topic {{ name }} }}
              }}
              {deployments}
    """


def _paginate(query_builder, extract):
    """Walk a GraphQL connection until `hasNextPage` is false."""
    nodes = []
    after_cursor = None

    while True:
        data = run_query(query_builder(after_cursor))
        connection = extract(data)
        if connection is None:
            break

        nodes.extend(connection['nodes'])

        page_info = connection['pageInfo']
        if not page_info['hasNextPage']:
            break
        after_cursor = page_info['endCursor']

    return nodes


def fetch_user_repositories(username, with_deployments=True):
    """All public, non-fork repositories owned by `username`."""

    def build(after_cursor):
        after_part = f', after: "{after_cursor}"' if after_cursor else ''
        return f"""
        {{
          user(login: "{username}") {{
            repositories(
              first: 100,
              isFork: false,
              privacy: PUBLIC,
              ownerAffiliations: [OWNER],
              orderBy: {{field: UPDATED_AT, direction: DESC}}
              {after_part}
            ) {{
              pageInfo {{ hasNextPage endCursor }}
              nodes {{ {_repository_fields(with_deployments)} }}
            }}
          }}
        }}
        """

    return _paginate(
        build,
        lambda data: (data.get('user') or {}).get('repositories'),
    )


def fetch_organizations(username):
    """Public organization memberships for `username`.

    Only publicly visible memberships are returned, which is exactly what a
    public portfolio should show.
    """

    def build(after_cursor):
        after_part = f', after: "{after_cursor}"' if after_cursor else ''
        return f"""
        {{
          user(login: "{username}") {{
            organizations(first: 100{after_part}) {{
              pageInfo {{ hasNextPage endCursor }}
              nodes {{ login }}
            }}
          }}
        }}
        """

    nodes = _paginate(
        build,
        lambda data: (data.get('user') or {}).get('organizations'),
    )
    return [node['login'] for node in nodes]


def fetch_organization_repositories(org_login, with_deployments=True):
    """All public, non-fork repositories owned by `org_login`."""

    def build(after_cursor):
        after_part = f', after: "{after_cursor}"' if after_cursor else ''
        return f"""
        {{
          organization(login: "{org_login}") {{
            repositories(
              first: 100,
              isFork: false,
              privacy: PUBLIC,
              orderBy: {{field: UPDATED_AT, direction: DESC}}
              {after_part}
            ) {{
              pageInfo {{ hasNextPage endCursor }}
              nodes {{ {_repository_fields(with_deployments)} }}
            }}
          }}
        }}
        """

    return _paginate(
        build,
        lambda data: (data.get('organization') or {}).get('repositories'),
    )


def fetch_all_repositories(username):
    """Owned + public-org repositories, deduplicated by nameWithOwner.

    Retries once without the `deployments` selection so a token that cannot
    read deployments still produces a dataset.
    """
    for with_deployments in (True, False):
        try:
            repos = fetch_user_repositories(username, with_deployments)
            for org_login in fetch_organizations(username):
                repos.extend(
                    fetch_organization_repositories(org_login, with_deployments)
                )
            return _deduplicate(repos, key=lambda repo: repo['nameWithOwner'])
        except GraphQLError as error:
            if not with_deployments:
                raise
            print(f"Retrying without deployments after: {error}")

    return []


def fetch_all_pull_requests(username):
    """All pull requests authored by `username`."""

    def build(after_cursor):
        after_part = f', after: "{after_cursor}"' if after_cursor else ''
        return f"""
        {{
          user(login: "{username}") {{
            pullRequests(
              first: 100,
              orderBy: {{field: CREATED_AT, direction: DESC}}
              {after_part}
            ) {{
              pageInfo {{ hasNextPage endCursor }}
              nodes {{
                title
                url
                state
                createdAt
                mergedAt
                baseRepository {{
                  nameWithOwner
                  url
                  description
                  isPrivate
                  stargazerCount
                  owner {{ login }}
                }}
              }}
            }}
          }}
        }}
        """

    return _paginate(
        build,
        lambda data: (data.get('user') or {}).get('pullRequests'),
    )


def _deduplicate(items, key):
    seen = set()
    unique = []
    for item in items:
        item_key = key(item)
        if item_key in seen:
            continue
        seen.add(item_key)
        unique.append(item)
    return unique


def _demo_url(repo):
    """Where a live demo lives, or None.

    An explicit homepage wins. Otherwise a github-pages deployment implies the
    conventional Pages URL.
    """
    if repo.get('homepageUrl'):
        return repo['homepageUrl']

    deployments = repo.get('deployments') or {}
    if deployments.get('totalCount', 0) > 0:
        return f"https://{repo['owner']['login']}.github.io/{repo['name']}/"

    return None


def build_repository_entry(repo, username):
    return {
        'name': repo['name'],
        'full_name': repo['nameWithOwner'],
        'owner': repo['owner']['login'],
        'link': repo['url'],
        'description': repo['description'],
        'stars': repo['stargazerCount'],
        'forks': repo['forkCount'],
        'language': (repo.get('primaryLanguage') or {}).get('name'),
        'topics': [
            node['topic']['name']
            for node in (repo.get('repositoryTopics') or {}).get('nodes', [])
        ],
        'updated_at': repo['updatedAt'],
        'archived': repo.get('isArchived', False),
        'is_organization': repo['owner']['login'].lower() != username.lower(),
        'demo_url': _demo_url(repo),
    }


def get_user_info(username):
    """Assemble the full public dataset for `username`."""
    profile_data = run_query(f"""
    {{
      user(login: "{username}") {{
        login
        name
        avatarUrl
        url
        bio
      }}
    }}
    """)

    user_data = profile_data.get('user')
    if not user_data:
        raise GraphQLError(f"Failed to retrieve data for user '{username}'")

    user_info = {
        'generated_at': datetime.now(timezone.utc).isoformat(
            timespec='seconds'
        ),
        'username': user_data['login'],
        'name': user_data.get('name') or user_data['login'],
        'bio': user_data.get('bio'),
        'image_url': user_data['avatarUrl'],
        'profile_url': user_data['url'],
        'repos': [],
        'pull_requests': {},
    }

    for repo in fetch_all_repositories(username):
        # Belt and braces: the query already asks for PUBLIC only.
        if repo.get('isPrivate'):
            continue
        user_info['repos'].append(build_repository_entry(repo, username))

    for pr in fetch_all_pull_requests(username):
        base_repo = pr.get('baseRepository')
        if not base_repo:
            continue
        # Never leak the existence of a private repo through a PR entry.
        if base_repo.get('isPrivate'):
            continue
        # Only contributions to other people's repos belong in this section.
        if base_repo['owner']['login'].lower() == username.lower():
            continue

        repo_key = base_repo['nameWithOwner']
        contribution = user_info['pull_requests'].setdefault(repo_key, {
            'repo_stars': base_repo['stargazerCount'],
            'repo_link': base_repo['url'],
            'repo_description': base_repo['description'],
            'prs': [],
        })

        # GraphQL reports OPEN/CLOSED/MERGED; the app matches on lowercase.
        # A merged PR is reported as MERGED, but guard on mergedAt too so a
        # closed-then-merged edge case still colours correctly.
        state = 'merged' if pr.get('mergedAt') else pr['state'].lower()

        contribution['prs'].append({
            'title': pr['title'],
            'link': pr['url'],
            'state': state,
            'created_at': pr['createdAt'],
            'merged_at': pr.get('mergedAt'),
        })

    return user_info


def write_contributed_repos(user_info):
    """Write the human-readable contribution index."""
    owned = _deduplicate(
        [
            {'name': repo['full_name'], 'link': repo['link']}
            for repo in user_info['repos']
        ],
        key=lambda repo: repo['name'],
    )
    external = _deduplicate(
        [
            {'name': name, 'link': info['repo_link']}
            for name, info in user_info['pull_requests'].items()
        ],
        key=lambda repo: repo['name'],
    )

    with open('contributed_repos.json', 'w') as file:
        json.dump({'owned': owned, 'external': external}, file, indent=4)

    with open('CONTRIBUTED_REPOS.md', 'w') as file:
        file.write("# Contributed Repositories\n\n")
        file.write("## Owned\n\n")
        for repo in owned:
            file.write(f"- [{repo['name']}]({repo['link']})\n")
        file.write("\n## External\n\n")
        for repo in external:
            file.write(f"- [{repo['name']}]({repo['link']})\n")


if __name__ == '__main__':
    # GITHUB_REPOSITORY looks like "octocat/Hello-World"; the owner is the
    # portfolio's subject unless PORTFOLIO_USERNAME overrides it.
    username = os.getenv('PORTFOLIO_USERNAME')
    if not username:
        username = os.environ['GITHUB_REPOSITORY'].split('/')[0]

    user_info = get_user_info(username)

    # Written into assets/ because the Flutter app bundles that directory and
    # fetches the same path from raw.githubusercontent.com; writing it to the
    # repo root would leave the app loading a stale bundled copy.
    os.makedirs(ASSET_DIR, exist_ok=True)
    with open(os.path.join(ASSET_DIR, 'user_info.json'), 'w') as file:
        json.dump(user_info, file, indent=4)

    write_contributed_repos(user_info)

    print(
        f"Wrote {len(user_info['repos'])} public repos and "
        f"{sum(len(info['prs']) for info in user_info['pull_requests'].values())} "
        f"pull requests across {len(user_info['pull_requests'])} external repos."
    )
