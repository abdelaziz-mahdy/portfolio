// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meta_seo/meta_seo.dart';
import 'package:portfolio/github/controller/portfolio_controller.dart';
import 'package:portfolio/github/models/portfolio_data.dart';
import 'package:portfolio/github/utils.dart';
import 'package:portfolio/service_locator.dart';

import 'package:portfolio/constants/constants.dart';
import 'package:portfolio/constants/view/course_card.dart';
import 'package:portfolio/constants/view/education_card.dart';
import 'package:portfolio/constants/view/experience_card.dart';
import 'package:portfolio/constants/view/profile_section.dart';
import 'package:portfolio/constants/view/skills_card.dart';
import 'package:portfolio/github/view/pull_requests/pull_requests_on_public_repos.dart';
import 'package:portfolio/github/view/repos/repositories_list.dart';

void main() {
  // It is required to add the following to run the meta_seo package correctly
  // before the running of the Flutter app
  if (kIsWeb) {
    MetaSEO().config();
  }
  setupServiceLocator();
  // Start the fetch before the first frame so the data is often ready by the
  // time the tree mounts.
  getIt<PortfolioController>().load();
  runApp(const MyApp());
}

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
    if (kIsWeb) {
      // Define MetaSEO object
      MetaSEO meta = MetaSEO();
      // add meta seo data for web app as you want
      meta.author(author: Constants.profileName);
      meta.description(
          description:
              "Portfolio of ${Constants.profileName} using Flutter, showcasing my skills and projects");
      meta.keywords(keywords: 'Flutter, Dart, SEO, Meta, Web, Portfolio');
    }
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
        home: Home(
          toggleTheme: _toggleTheme,
        ));
  }
}

class Home extends StatelessWidget {
  final void Function(bool) toggleTheme;
  const Home({
    super.key,
    required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final controller = getIt<PortfolioController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
        actions: [
          IconButton(
            tooltip: 'Email',
            icon: FaIcon(FontAwesomeIcons.envelope,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFFEA4335)),
            onPressed: () =>
                openExternalUrl(context, 'mailto:${Constants.email}'),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            tooltip: 'LinkedIn',
            icon: FaIcon(FontAwesomeIcons.linkedinIn,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF0A66C2)),
            onPressed: () => openExternalUrl(context, Constants.linkedInUrl),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            tooltip: 'GitHub',
            icon: FaIcon(FontAwesomeIcons.github,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF181717)),
            onPressed: () => openExternalUrl(
                context, 'https://github.com/${Constants.githubUsername}'),
          ),
          const SizedBox(
            width: 10,
          ),
          Switch(
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: toggleTheme,
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          switch (controller.status) {
            case PortfolioStatus.idle:
            case PortfolioStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case PortfolioStatus.error:
              return _ErrorView(
                error: controller.error,
                onRetry: controller.refresh,
              );
            case PortfolioStatus.ready:
              return _PortfolioBody(data: controller.data!);
          }
        },
      ),
    );
  }
}

class _PortfolioBody extends StatelessWidget {
  final PortfolioData data;

  const _PortfolioBody({required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isPortrait(context) ? 10 : 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProfileSection(data: data),
            StaggeredGrid.count(
              crossAxisCount: isPortrait(context) ? 1 : 2,
              children: [
                CourseCard(courses: Constants.courses),
                SkillsCard(skills: Constants.skills),
                ExperienceCard(experiences: Constants.experience),
                EducationCard(educations: Constants.education),
              ],
            ),
            PullRequestsOnPublicRepos(
              data: data,
              cardWidth: StylingConstants.cardsWidth,
            ),
            RepositoriesList(
              repositories: data.repositories,
              cardWidth: StylingConstants.cardsWidth,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final Object? error;
  final VoidCallback onRetry;

  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48),
            const SizedBox(height: 16),
            Text(
              'Could not load GitHub data.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '$error',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
