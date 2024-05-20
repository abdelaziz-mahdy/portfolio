import requests
import os
from github import Github

# Initialize GitHub API client
token = os.getenv('GITHUB_TOKEN')
g = Github(token)

def get_user_info(username):
    user = g.get_user(username)
    user_info = {
        'username': user.login,
        'image_url': user.avatar_url,
        'repos': [],
        'pull_requests': {}
    }

    # Get all repos that are not forks
    for repo in user.get_repos():
        if not repo.fork:
            repo_info = {
                'name': repo.name,
                'stars': repo.stargazers_count,
                'link': repo.html_url,
                'image': False,
                'image_link': None,
                'github_pages_link': None
            }

            # Check for screenshot/image in repo
            contents = repo.get_contents("")
            for content_file in contents:
                if 'screenshot' in content_file.path.lower() or 'image' in content_file.path.lower():
                    repo_info['image'] = True
                    repo_info['image_link'] = content_file.download_url
                    break

            # Check for GitHub Pages
            if repo.has_pages:
                repo_info['github_pages_link'] = f'https://{username}.github.io/{repo.name}/'

            user_info['repos'].append(repo_info)

    # Get all pull requests
    for repo in user.get_repos():
        prs = repo.get_pulls(state='all')
        for pr in prs:
            if pr.user.login == username:
                if repo.name not in user_info['pull_requests']:
                    user_info['pull_requests'][repo.name] = {
                        'repo_stars': repo.stargazers_count,
                        'repo_link': repo.html_url,
                        'pull_requests': []
                    }
                user_info['pull_requests'][repo.name]['pull_requests'].append({
                    'title': pr.title,
                    'link': pr.html_url
                })

    return user_info

if __name__ == '__main__':
    repo_name = os.getenv('GITHUB_REPOSITORY')
    owner, _ = repo_name.split('/')
    user_info = get_user_info(owner)

    # Print user info for debugging purposes
    print(user_info)
