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
        repositories(first: 100, isFork: false) {{
          nodes {{
            name
            url
            stargazerCount
            object(expression: "HEAD:screenshot/") {{
              ... on Tree {{
                entries {{
                  name
                  object {{
                    ... on Blob {{
                      text
                      url
                    }}
                  }}
                }}
              }}
            }}
            hasPages
            homepageUrl
          }}
        }}
        pullRequests(first: 100) {{
          nodes {{
            title
            url
            baseRepository {{
              nameWithOwner
              stargazerCount
              url
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
        print("Failed to retrieve user data:", result)
        raise Exception("Failed to retrieve user data")

    user_info = {
        'username': user_data['login'],
        'image_url': user_data['avatarUrl'],
        'repos': [],
        'pull_requests': []
    }

    # Process repositories
    for repo in user_data['repositories']['nodes']:
        repo_info = {
            'name': repo['name'],
            'stars': repo['stargazerCount'],
            'link': repo['url'],
            'image': False,
            'image_link': None,
            'github_pages_link': repo['homepageUrl'] if repo['hasPages'] else None
        }

        if repo['object']:
            for entry in repo['object']['entries']:
                if 'screenshot' in entry['name'].lower() or 'image' in entry['name'].lower():
                    repo_info['image'] = True
                    repo_info['image_link'] = entry['object']['url']
                    break

        user_info['repos'].append(repo_info)

    # Process pull requests
    for pr in user_data['pullRequests']['nodes']:
        pull_request_info = {
            'title': pr['title'],
            'link': pr['url'],
            'base_repo_name': pr['baseRepository']['nameWithOwner'],
            'base_repo_stars': pr['baseRepository']['stargazerCount'],
            'base_repo_link': pr['baseRepository']['url']
        }
        user_info['pull_requests'].append(pull_request_info)

    return user_info

if __name__ == '__main__':
    repo_name = os.getenv('GITHUB_REPOSITORY')
    owner, _ = repo_name.split('/')
    try:
        user_info = get_user_info(owner)
        # Print user info in JSON format for cleaner readability
        print(json.dumps(user_info, indent=4))
    except Exception as e:
        print(f"Error: {e}")
