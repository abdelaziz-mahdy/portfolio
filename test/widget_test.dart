import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/github/models/portfolio_data.dart';

void main() {
  group('PortfolioData.fromJson', () {
    final json = {
      'generated_at': '2026-07-26T03:00:00+00:00',
      'username': 'octocat',
      'name': 'The Octocat',
      'image_url': 'https://example.com/avatar.png',
      'profile_url': 'https://github.com/octocat',
      'repos': [
        {
          'name': 'no-demo',
          'full_name': 'octocat/no-demo',
          'owner': 'octocat',
          'link': 'https://github.com/octocat/no-demo',
          'description': null,
          'stars': 5,
          'forks': 1,
          'language': 'Dart',
          'topics': ['flutter'],
          'updated_at': '2026-01-01T00:00:00Z',
          'archived': false,
          'is_organization': false,
          'demo_url': null,
        },
        {
          'name': 'with-demo',
          'full_name': 'octocat/with-demo',
          'owner': 'octocat',
          'link': 'https://github.com/octocat/with-demo',
          'description': 'Has a live demo',
          'stars': 5,
          'forks': 0,
          'language': null,
          'topics': <String>[],
          'updated_at': '2026-02-01T00:00:00Z',
          'archived': false,
          'is_organization': false,
          'demo_url': 'https://octocat.github.io/with-demo/',
        },
      ],
      'pull_requests': {
        'flutter/flutter': {
          'repo_stars': 160000,
          'repo_link': 'https://github.com/flutter/flutter',
          'repo_description': 'Flutter makes it easy...',
          'prs': [
            {
              'title': 'Older',
              'link': 'https://github.com/flutter/flutter/pull/1',
              'state': 'merged',
              'created_at': '2025-01-01T00:00:00Z',
              'merged_at': '2025-01-05T00:00:00Z',
            },
            {
              'title': 'Newer',
              'link': 'https://github.com/flutter/flutter/pull/2',
              'state': 'open',
              'created_at': '2026-01-01T00:00:00Z',
              'merged_at': null,
            },
          ],
        },
      },
    };

    test('breaks star ties in favour of repos with a demo', () {
      final data = PortfolioData.fromJson(json);

      expect(data.repositories.first.name, 'with-demo');
      expect(data.repositories.first.hasDemo, isTrue);
      expect(data.repositories.last.hasDemo, isFalse);
    });

    test('sorts pull requests newest first', () {
      final data = PortfolioData.fromJson(json);

      expect(data.contributions.single.pullRequests.first.title, 'Newer');
    });

    test('aggregates pull request states across repositories', () {
      final data = PortfolioData.fromJson(json);

      expect(data.totalPullRequests, 2);
      expect(data.pullRequestStates, {'open': 1, 'merged': 1});
    });

    test('tolerates a dataset written by an older script version', () {
      final data = PortfolioData.fromJson({
        'username': 'octocat',
        'image_url': '',
        'repos': [
          {
            'name': 'legacy',
            'link': 'https://github.com/octocat/legacy',
            'stars': 1,
          }
        ],
        'pull_requests': <String, dynamic>{},
      });

      expect(data.name, 'octocat');
      expect(data.profileUrl, 'https://github.com/octocat');
      expect(data.repositories.single.fullName, 'legacy');
      expect(data.repositories.single.hasDemo, isFalse);
    });
  });
}
