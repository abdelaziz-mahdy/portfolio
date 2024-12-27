import os
import requests
import json

GITHUB_TOKEN = os.getenv('GITHUB_TOKEN')
HEADERS = {"Authorization": f"Bearer {GITHUB_TOKEN}"}


def run_query(query):
    """Sends a GraphQL query to the GitHub API and returns the JSON response."""
    response = requests.post(
        'https://api.github.com/graphql',
        json={'query': query},
        headers=HEADERS
    )
    if response.status_code == 200:
        return response.json()
    else:
        raise Exception(
            f"Query failed to run with code {response.status_code}. {query}"
        )


def fetch_all_repositories(username):
    """
    Fetch ALL (not just first 100) repositories owned by `username`
    using GraphQL pagination.
    """
    all_repos = []
    has_next_page = True
    after_cursor = None

    while has_next_page:
        # Notice the 'after' variable is passed as a GraphQL variable
        # but must be represented as a string inside the query:
        after_part = f', after: "{after_cursor}"' if after_cursor else ''

        query = f"""
        {{
          user(login: "{username}") {{
            repositories(
              first: 100,
              isFork: false,
              orderBy: {{field: UPDATED_AT, direction: DESC}}
              {after_part}
            ) {{
              pageInfo {{
                hasNextPage
                endCursor
              }}
              nodes {{
                name
                url
                stargazerCount
                description
                updatedAt
                object(expression: "HEAD:") {{
                  ... on Tree {{
                    entries {{
                      name
                      type
                    }}
                  }}
                }}
                homepageUrl
              }}
            }}
          }}
        }}
        """

        result = run_query(query)
        user_data = result.get('data', {}).get('user')
        if not user_data:
            break

        repo_data = user_data['repositories']
        # Add fetched nodes to all_repos
        all_repos.extend(repo_data['nodes'])

        # Update pagination info
        has_next_page = repo_data['pageInfo']['hasNextPage']
        after_cursor = repo_data['pageInfo']['endCursor']

    return all_repos


def fetch_all_pull_requests(username):
    """
    Fetch ALL (not just first 100) pull requests created by `username`
    using GraphQL pagination.
    """
    all_prs = []
    has_next_page = True
    after_cursor = None

    while has_next_page:
        after_part = f', after: "{after_cursor}"' if after_cursor else ''

        query = f"""
        {{
          user(login: "{username}") {{
            pullRequests(
              first: 100
              {after_part}
            ) {{
              pageInfo {{
                hasNextPage
                endCursor
              }}
              nodes {{
                title
                url
                state
                baseRepository {{
                  nameWithOwner
                  stargazerCount
                  url
                  description
                  owner {{
                    login
                  }}
                }}
              }}
            }}
          }}
        }}
        """

        result = run_query(query)
        user_data = result.get('data', {}).get('user')
        if not user_data:
            break

        pr_data = user_data['pullRequests']
        all_prs.extend(pr_data['nodes'])

        # Update pagination info
        has_next_page = pr_data['pageInfo']['hasNextPage']
        after_cursor = pr_data['pageInfo']['endCursor']

    return all_prs


def get_user_info(username):
    """
    Combines the above pagination helpers to build
    a cohesive 'user_info' dict with:
      - username
      - image_url
      - repos (all repos)
      - pull_requests (all PRs to external repos)
    """
    # -- You can also fetch the user's avatar if you want:
    avatar_query = f"""
    {{
      user(login: "{username}") {{
        login
        avatarUrl
      }}
    }}
    """
    avatar_result = run_query(avatar_query)
    user_data = avatar_result.get('data', {}).get('user')
    if not user_data:
        raise Exception(f"Failed to retrieve data for user '{username}'")

    # Fetch all repos and all PRs using pagination
    repos = fetch_all_repositories(username)
    prs = fetch_all_pull_requests(username)

    user_info = {
        'username': user_data['login'],
        'image_url': user_data['avatarUrl'],
        'repos': [],
        'pull_requests': {}
    }

    # Process owned repositories
    for repo in repos:
        repo_info = {
            'name': repo['name'],
            'stars': repo['stargazerCount'],
            'link': repo['url'],
            'description': repo['description'],
            'updated_at': repo['updatedAt'],
            'image': False,
            'image_link': None,
            'github_pages_link': repo['homepageUrl'] if repo['homepageUrl'] else None
        }

        # Check if there's a blob that looks like an image or screenshot
        if repo.get('object') and repo['object'].get('entries'):
            for entry in repo['object']['entries']:
                if (entry['type'] == 'blob' and
                   ('screenshot' in entry['name'].lower() or 'image' in entry['name'].lower())):
                    repo_info['image'] = True
                    repo_info['image_link'] = (
                        f"https://github.com/{username}/{
                            repo['name']}/blob/main/{entry['name']}"
                    )
                    break

        user_info['repos'].append(repo_info)

    # Process pull requests to external repositories
    for pr in prs:
        base_repo = pr['baseRepository']
        if not base_repo:
            continue

        if base_repo['owner']['login'] != username:
            base_repo_name = base_repo['nameWithOwner']
            if base_repo_name not in user_info['pull_requests']:
                user_info['pull_requests'][base_repo_name] = {
                    'repo_stars': base_repo['stargazerCount'],
                    'repo_link': base_repo['url'],
                    'repo_description': base_repo['description'],
                    'prs': []
                }
            pull_request_info = {
                'title': pr['title'],
                'link': pr['url'],
                'state': pr['state']
            }
            user_info['pull_requests'][base_repo_name]['prs'].append(
                pull_request_info)

    return user_info


if __name__ == '__main__':
    # For example, if GITHUB_REPOSITORY is "octocat/Hello-World", 'owner' = "octocat"
    repo_name = os.getenv('GITHUB_REPOSITORY')
    owner, _ = repo_name.split('/')
    try:
        user_info = get_user_info(owner)
        print(json.dumps(user_info, indent=4))

        # Print user info in JSON format for cleaner readability
        print(json.dumps(user_info, indent=4))

        # Separate 'owned' vs 'external' contributed repos
        owned_repos = []
        external_repos = []

        # (a) User's own repos
        for r in user_info['repos']:
            owned_repos.append({
                'name': r['name'],
                'link': r['link']
            })

        # (b) External repos contributed to via PRs
        for base_repo, info in user_info['pull_requests'].items():
            external_repos.append({
                'name': base_repo,
                'link': info['repo_link']
            })

        # Deduplicate each category (just in case)
        # (Though typically 'owned' should not appear in 'external')
        def deduplicate_repos(repo_list):
            unique = []
            seen = set()
            for repo in repo_list:
                if repo['name'] not in seen:
                    unique.append(repo)
                    seen.add(repo['name'])
            return unique

        owned_repos = deduplicate_repos(owned_repos)
        external_repos = deduplicate_repos(external_repos)

        # Prepare final contributed_repos structure
        contributed_repos = {
            "owned": owned_repos,
            "external": external_repos
        }

        # 1. Save the contributed repos (with sections) to JSON
        with open('contributed_repos.json', 'w') as f:
            json.dump(contributed_repos, f, indent=4)

        # 2. Create a README with two distinct sections
        with open('CONTRIBUTED_REPOS.md', 'w') as f:
            f.write("# Contributed Repositories\n\n")

            f.write("## Owned\n\n")
            for repo in owned_repos:
                f.write(f"- [{repo['name']}]({repo['link']})\n")

            f.write("\n## External\n\n")
            for repo in external_repos:
                f.write(f"- [{repo['name']}]({repo['link']})\n")

        print("Successfully saved 'contributed_repos.json' and 'CONTRIBUTED_REPOS.md' with two sections!")

    except Exception as e:
        print(f"Error: {e}")
