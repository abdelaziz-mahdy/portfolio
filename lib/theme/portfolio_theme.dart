import 'package:flutter/material.dart';
import 'package:portfolio/theme/portfolio_palette.dart';

/// The app's two themes, built from one definition so light and dark cannot
/// drift apart.
///
/// Section and card headings read from [TextTheme] rather than literal
/// `TextStyle(fontSize: 20)` values, so the three headings that were all
/// "20px bold" now express an actual hierarchy.
abstract final class PortfolioTheme {
  static const _seed = Color(0xFF2563EB);

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );

    final base = ThemeData(colorScheme: colorScheme, useMaterial3: true);

    return base.copyWith(
      extensions: [
        brightness == Brightness.dark
            ? PortfolioPalette.dark
            : PortfolioPalette.light,
      ],
      textTheme: base.textTheme.copyWith(
        displaySmall: base.textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        headlineSmall: base.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          // A visible boundary in both themes: light-mode cards were
          // near-white on near-white with nothing separating them.
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
      ),
    );
  }
}
