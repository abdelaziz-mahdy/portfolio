import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/constants/view/profile_section.dart';
import 'package:portfolio/github/models/portfolio_data.dart';
import 'package:portfolio/profile/models/profile.dart';

void main() {
  testWidgets('stat tiles jump to the section that backs them up',
      (tester) async {
    var contributions = 0;
    var projects = 0;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: ProfileSection(
            profile: Profile.fromJson({'name': 'Octo Cat'}),
            githubData: PortfolioData.fromJson({
              'username': 'octocat',
              'image_url': '',
              'repos': <Map<String, dynamic>>[],
              'pull_requests': <String, dynamic>{},
            }),
            onShowContributions: () => contributions++,
            onShowProjects: () => projects++,
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Pull requests merged'));
    await tester.tap(find.text('Repos contributed to'));
    await tester.tap(find.text('Public projects'));
    await tester.tap(find.text('Stars earned'));

    expect(contributions, 2);
    expect(projects, 2);
  });
}
