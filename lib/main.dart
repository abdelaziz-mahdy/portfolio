import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:portfolio/constants/constants.dart';
import 'package:portfolio/constants/view/course_card.dart';
import 'package:portfolio/constants/view/education_card.dart';
import 'package:portfolio/constants/view/experience_card.dart';
import 'package:portfolio/constants/view/profile_section.dart';
import 'package:portfolio/constants/view/skills_card.dart';
import 'package:portfolio/github/view/pull_requests/pull_requests_on_public_repos.dart';
import 'package:portfolio/github/view/repos/repositories_list.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme(bool isOn) {
    setState(() {
      _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Portfolio',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              brightness: Brightness.dark, seedColor: Colors.blue),
          useMaterial3: true,
        ),
        themeMode: _themeMode,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Portfolio'),
            actions: [
              IconButton(
                icon: const Icon(Icons.email),
                onPressed: () {
                  // Handle your email action here
                },
              ),
              IconButton(
                icon: const Icon(Icons.link),
                onPressed: () {
                  // Handle your LinkedIn action here
                },
              ),
              IconButton(
                icon: const Icon(Icons.code),
                onPressed: () {
                  // Handle your GitHub action here
                },
              ),
              Builder(builder: (context) {
                return Switch(
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: _toggleTheme,
                );
              }),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const ProfileSection(),
                StaggeredGrid.count(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 600 ? 2 : 1,
                  // childAspectRatio: (MediaQuery.of(context).size.width / 2) / 300,
                  children: [
                    CourseCard(courses: Constants.courses),
                    SkillsCard(skills: Constants.skills),
                    EducationCard(educations: Constants.education),
                    ExperienceCard(experiences: Constants.experience),
                  ],
                ),
                const SizedBox(
                    height: StylingConstants.listViewHeight,
                    child: PullRequestsOnPublicRepos(
                      cardWidth: StylingConstants.cardsWidth,
                    )), // Uncomment if these are to be included
                const SizedBox(
                    height: StylingConstants.listViewHeight,
                    child: RepositoriesList(
                      cardWidth: StylingConstants.cardsWidth,
                    )), // Adjust layout or wrap with a fixed height Container if necessary
              ],
            ),
          ),
        ));
  }
}
