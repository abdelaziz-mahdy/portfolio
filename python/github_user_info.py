import os
import requests
import json

GITHUB_TOKEN = os.getenv('GITHUB_TOKEN')
HEADERS = {"Authorization": f"Bearer {GITHUB_TOKEN}"}

def run_query(query):
    request = requests.post('https://api.github.com/graphql', json={'query': query}, headers=HEADERS)
    if request.status_code == 200:
        return request.json()
    else:
        raise Exception(f"Query failed to run by returning code of {request.status_code}. {query}")

def get_user_info(username):
    query = f"""
    {{
      user(login: "{username}") {{
        login
        avatarUrl
        repositories(first: 100, isFork: false, orderBy: {{field: UPDATED_AT, direction: DESC}}) {{
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
        pullRequests(first: 100) {{
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

    if 'errors' in result:
        print("Errors:", result['errors'])
        raise Exception("Query returned errors")

    user_data = result.get('data', {}).get('user')
    if not user_data:
        raise Exception("Failed to retrieve user data")

    user_info = {
        'username': user_data['login'],
        'image_url': user_data['avatarUrl'],
        'repos': [],
        'pull_requests': {}
    }

    # Process repositories
    for repo in user_data['repositories']['nodes']:
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

        if repo['object']:
            for entry in repo['object']['entries']:
                if entry['type'] == 'blob' and ('screenshot' in entry['name'].lower() or 'image' in entry['name'].lower()):
                    repo_info['image'] = True
                    repo_info['image_link'] = f"https://github.com/{username}/{repo['name']}/blob/main/{entry['name']}"
                    break

        user_info['repos'].append(repo_info)

    # Process pull requests
    for pr in user_data['pullRequests']['nodes']:
        if pr['baseRepository']['owner']['login'] != username:
            base_repo_name = pr['baseRepository']['nameWithOwner']
            if base_repo_name not in user_info['pull_requests']:
                user_info['pull_requests'][base_repo_name] = {
                    'repo_stars': pr['baseRepository']['stargazerCount'],
                    'repo_link': pr['baseRepository']['url'],
                    'repo_description': pr['baseRepository']['description'],
                    'prs': []
                }
            pull_request_info = {
                'title': pr['title'],
                'link': pr['url'],
                'state': pr['state']
            }
            user_info['pull_requests'][base_repo_name]['prs'].append(pull_request_info)

    return user_info

if __name__ == '__main__':
    repo_name = os.getenv('GITHUB_REPOSITORY')
    owner, _ = repo_name.split('/')
    try:
        user_info = get_user_info(owner)
        # Print user info in JSON format for cleaner readability
        print(json.dumps(user_info, indent=4))
        # Save user info to a JSON file
        with open('user_info.json', 'w') as f:
            json.dump(user_info, f)
    except Exception as e:
        print(f"Error: {e}")
