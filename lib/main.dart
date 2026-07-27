import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meta_seo/meta_seo.dart';
import 'package:portfolio/constants/constants.dart';
import 'package:portfolio/constants/view/course_card.dart';
import 'package:portfolio/constants/view/credentials_card.dart';
import 'package:portfolio/constants/view/education_card.dart';
import 'package:portfolio/constants/view/experience_card.dart';
import 'package:portfolio/constants/view/profile_section.dart';
import 'package:portfolio/constants/view/publications_card.dart';
import 'package:portfolio/constants/view/skills_card.dart';
import 'package:portfolio/github/controller/portfolio_controller.dart';
import 'package:portfolio/github/models/portfolio_data.dart';
import 'package:portfolio/github/utils.dart';
import 'package:portfolio/github/view/pull_requests/pull_requests_on_public_repos.dart';
import 'package:portfolio/github/view/repos/repositories_list.dart';
import 'package:portfolio/github/view/widgets/card_grid.dart';
import 'package:portfolio/layout/breakpoints.dart';
import 'package:portfolio/profile/models/profile.dart';
import 'package:portfolio/service_locator.dart';
import 'package:portfolio/theme/portfolio_theme.dart';
import 'package:portfolio/theme/theme_controller.dart';

void main() {
  // It is required to add the following to run the meta_seo package correctly
  // before the running of the Flutter app
  if (kIsWeb) {
    MetaSEO().config();
  }
  setupServiceLocator();
  // Start both loads before the first frame so the data is often ready by the
  // time the tree mounts.
  getIt<PortfolioController>().load();
  getIt<ThemeController>().load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // Crawlers read web/index.html, which carries the same values
      // statically; these are set from a constant because they must exist
      // before profile.json has loaded.
      MetaSEO meta = MetaSEO();
      meta.author(author: Constants.fallbackName);
      meta.description(
          description:
              'Portfolio of ${Constants.fallbackName}: open-source work, '
              'projects and publications.');
      meta.keywords(keywords: 'Flutter, Dart, Portfolio, Open Source, Python');
    }

    final themeController = getIt<ThemeController>();

    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) => MaterialApp(
        title: '${Constants.fallbackName} — Software Developer',
        theme: PortfolioTheme.light(),
        darkTheme: PortfolioTheme.dark(),
        themeMode: themeController.mode,
        home: const Home(),
      ),
    );
  }
}

/// Sections the nav can jump to.
enum _Section {
  profile('Profile'),
  background('Background'),
  contributions('Contributions'),
  projects('Projects');

  final String label;
  const _Section(this.label);
}

/// Scrolls the page to one edge. Flutter's default shortcuts cover the arrow
/// and page keys but not Home/End.
class _ScrollToEdgeIntent extends Intent {
  final bool toEnd;
  const _ScrollToEdgeIntent({required this.toEnd});
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scrollController = ScrollController();
  final _sectionKeys = {
    for (final section in _Section.values) section: GlobalKey(),
  };

  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final shouldShow = _scrollController.offset > 600;
    if (shouldShow != _showBackToTop) {
      setState(() => _showBackToTop = shouldShow);
    }
  }

  Future<void> _jumpTo(_Section section) async {
    final target = _sectionKeys[section]?.currentContext;
    if (target == null) return;

    await Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      alignment: 0.05,
    );
  }

  void _scrollToEdge(bool toEnd) {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      toEnd
          ? _scrollController.position.maxScrollExtent
          : _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = getIt<PortfolioController>();
    final metrics = windowMetrics(context);

    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.home):
            _ScrollToEdgeIntent(toEnd: false),
        SingleActivator(LogicalKeyboardKey.end):
            _ScrollToEdgeIntent(toEnd: true),
      },
      child: Actions(
        actions: {
          _ScrollToEdgeIntent: CallbackAction<_ScrollToEdgeIntent>(
            onInvoke: (intent) {
              _scrollToEdge(intent.toEnd);
              return null;
            },
          ),
        },
        // Without focus somewhere in the page, no key event reaches the
        // scrollable and the keyboard cannot move the page at all.
        child: Focus(
          autofocus: true,
          child: ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              final profile = controller.profile;

              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    metrics.isCompact
                        ? 'Portfolio'
                        : (profile?.name ?? Constants.fallbackName),
                  ),
                  actions: [
                    if (metrics.isCompact)
                      // The same jumps as the wide layout, folded into a menu
                      // so phone visitors are not left scrolling the page.
                      PopupMenuButton<_Section>(
                        tooltip: 'Jump to section',
                        icon: const Icon(Icons.menu),
                        onSelected: _jumpTo,
                        itemBuilder: (context) => _Section.values
                            .map((section) => PopupMenuItem<_Section>(
                                  value: section,
                                  child: Text(section.label),
                                ))
                            .toList(),
                      )
                    else
                      for (final section in _Section.values)
                        TextButton(
                          onPressed: () => _jumpTo(section),
                          child: Text(section.label),
                        ),
                    const SizedBox(width: 8),
                    if (profile != null) _ContactActions(profile: profile),
                    ThemeModeButton(controller: getIt<ThemeController>()),
                    const SizedBox(width: 8),
                  ],
                ),
                floatingActionButton: _showBackToTop
                    ? FloatingActionButton.small(
                        tooltip: 'Back to top',
                        onPressed: () => _scrollToEdge(false),
                        child: const Icon(Icons.arrow_upward),
                      )
                    : null,
                body: switch (controller.status) {
                  PortfolioStatus.idle ||
                  PortfolioStatus.loading =>
                    const Center(child: CircularProgressIndicator()),
                  PortfolioStatus.error => _ErrorView(
                      error: controller.error,
                      onRetry: controller.refresh,
                    ),
                  PortfolioStatus.ready => _PortfolioBody(
                      profile: controller.profile!,
                      githubData: controller.githubData!,
                      scrollController: _scrollController,
                      sectionKeys: _sectionKeys,
                    ),
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ContactActions extends StatelessWidget {
  final Profile profile;

  const _ContactActions({required this.profile});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (profile.email != null)
          IconButton(
            tooltip: 'Email',
            icon: FaIcon(FontAwesomeIcons.envelope,
                color: isDark ? Colors.white : const Color(0xFFC5221F)),
            onPressed: () => openExternalUrl(context, 'mailto:${profile.email}'),
          ),
        if (profile.linkedInUrl != null)
          IconButton(
            tooltip: 'LinkedIn',
            icon: FaIcon(FontAwesomeIcons.linkedinIn,
                color: isDark ? Colors.white : const Color(0xFF0A66C2)),
            onPressed: () => openExternalUrl(context, profile.linkedInUrl),
          ),
        if (profile.githubUrl != null)
          IconButton(
            tooltip: 'GitHub',
            icon: FaIcon(FontAwesomeIcons.github,
                color: isDark ? Colors.white : const Color(0xFF181717)),
            onPressed: () => openExternalUrl(context, profile.githubUrl),
          ),
      ],
    );
  }
}

class _PortfolioBody extends StatelessWidget {
  final Profile profile;
  final PortfolioData githubData;
  final ScrollController scrollController;
  final Map<_Section, GlobalKey> sectionKeys;

  const _PortfolioBody({
    required this.profile,
    required this.githubData,
    required this.scrollController,
    required this.sectionKeys,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final metrics = LayoutMetrics.of(constraints.maxWidth);

        // Cards size to their content. Stretching them to a shared height only
        // moves the imbalance inside the border, where empty space reads as a
        // bug rather than as the content simply ending. Ordering long cards
        // together and short ones together is what evens the rows out.
        final background = <Widget>[
          if (profile.experience.isNotEmpty)
            ExperienceCard(experiences: profile.experience),
          if (profile.skills.isNotEmpty) SkillsCard(skills: profile.skills),
          if (profile.education.isNotEmpty)
            EducationCard(educations: profile.education),
          if (profile.publications.isNotEmpty)
            PublicationsCard(publications: profile.publications),
          if (profile.awards.isNotEmpty) AwardsCard(awards: profile.awards),
          if (profile.certificates.isNotEmpty)
            CertificatesCard(certificates: profile.certificates),
          if (profile.courses.isNotEmpty) CourseCard(courses: profile.courses),
        ];

        return Scrollbar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.symmetric(
              horizontal: metrics.pageGutter,
              vertical: 32,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    KeyedSubtree(
                      key: sectionKeys[_Section.profile],
                      child: ProfileSection(
                        profile: profile,
                        githubData: githubData,
                      ),
                    ),
                    SizedBox(height: metrics.sectionGap),
                    KeyedSubtree(
                      key: sectionKeys[_Section.background],
                      child: CardGrid(
                        columns: metrics.columnsFor(minCardWidth: 420, max: 2),
                        equalHeights: false,
                        children: background,
                      ),
                    ),
                    SizedBox(height: metrics.sectionGap),
                    KeyedSubtree(
                      key: sectionKeys[_Section.contributions],
                      child: PullRequestsOnPublicRepos(data: githubData),
                    ),
                    SizedBox(height: metrics.sectionGap),
                    KeyedSubtree(
                      key: sectionKeys[_Section.projects],
                      child: RepositoriesList(
                        repositories: githubData.repositories,
                      ),
                    ),
                    SizedBox(height: metrics.sectionGap),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
              'Could not load the portfolio.',
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
