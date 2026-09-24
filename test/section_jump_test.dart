import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/github/controller/portfolio_controller.dart';
import 'package:portfolio/github/data/portfolio_data_source.dart';
import 'package:portfolio/github/models/portfolio_data.dart';
import 'package:portfolio/main.dart';
import 'package:portfolio/profile/models/profile.dart';
import 'package:portfolio/service_locator.dart';
import 'package:portfolio/theme/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Serves the committed JSON instead of fetching it from the CDN.
class _AssetDataSource extends PortfolioDataSource {
  @override
  Future<PortfolioData> fetchGithubData() async => PortfolioData.fromJson(
      jsonDecode(File('assets/user_info.json').readAsStringSync())
          as Map<String, dynamic>);

  @override
  Future<Profile> fetchProfile() async => Profile.fromJson(
      jsonDecode(File('assets/profile.json').readAsStringSync())
          as Map<String, dynamic>);
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await getIt.reset();
    getIt.registerSingleton<PortfolioController>(
        PortfolioController(_AssetDataSource()));
    getIt.registerSingleton<ThemeController>(ThemeController());
  });

  // Background is far taller than the window, which is the case
  // Scrollable.ensureVisible's fractional alignment got wrong: it pushed the
  // heading above the viewport, under the app bar.
  for (final (nav, heading) in [
    ('Contributions', 'Open-source contributions'),
    ('Projects', 'Projects'),
    ('Background', 'Experience'),
  ]) {
    testWidgets('$nav jump lands its heading just below the app bar',
        (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.runAsync(() => getIt<PortfolioController>().load());
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(TextButton, nav));
      await tester.pumpAndSettle();

      final appBarBottom = tester.getBottomLeft(find.byType(AppBar)).dy;
      final headingTop = tester
          .getTopLeft(find
              .descendant(
                of: find.byType(SingleChildScrollView),
                matching: find.text(heading),
              )
              .first)
          .dy;

      expect(headingTop, greaterThanOrEqualTo(appBarBottom));
      expect(headingTop, lessThan(appBarBottom + 64));
    });
  }
}
