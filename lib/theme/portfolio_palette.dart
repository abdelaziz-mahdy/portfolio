import 'package:flutter/material.dart';

/// Semantic colours that Material's [ColorScheme] has no slot for.
///
/// These live in a [ThemeExtension] rather than as constants so every value
/// flips with the theme. Hard-coded colours were the root cause of the star
/// icon rendering at 1.22:1 in light mode while passing comfortably in dark.
///
/// Every text-on-chip pairing below clears the WCAG AA 4.5:1 threshold with
/// [onStateChip]; the ratios are noted so a future edit cannot quietly break
/// them.
@immutable
class PortfolioPalette extends ThemeExtension<PortfolioPalette> {
  /// Pull request merged. White on this: 6.51:1.
  final Color prMerged;

  /// Pull request open. White on this: 5.08:1.
  ///
  /// This is deliberately darker than GitHub's brand green (`#2CBE4E`), which
  /// only reaches 2.45:1 against white and fails as a label background.
  final Color prOpen;

  /// Pull request closed. White on this: 5.47:1.
  final Color prClosed;

  /// Any state the dataset does not recognise. Rendered as an outlined chip
  /// rather than a filled one — the previous `grey.shade300` fill put white
  /// text at 1.32:1, which is invisible.
  final Color prUnknown;

  /// Foreground for filled state chips.
  final Color onStateChip;

  /// Star glyph on repository cards.
  final Color star;

  const PortfolioPalette({
    required this.prMerged,
    required this.prOpen,
    required this.prClosed,
    required this.prUnknown,
    required this.onStateChip,
    required this.star,
  });

  static const light = PortfolioPalette(
    prMerged: Color(0xFF6F42C1),
    prOpen: Color(0xFF1A7F37),
    prClosed: Color(0xFFCB2431),
    prUnknown: Color(0xFF49454F),
    onStateChip: Color(0xFFFFFFFF),
    star: Color(0xFFB26A00),
  );

  static const dark = PortfolioPalette(
    prMerged: Color(0xFF6F42C1),
    prOpen: Color(0xFF1A7F37),
    prClosed: Color(0xFFCB2431),
    prUnknown: Color(0xFFCAC4D0),
    onStateChip: Color(0xFFFFFFFF),
    star: Color(0xFFE3B341),
  );

  /// Colour for a pull request state string (`merged`, `open`, `closed`).
  Color forState(String? state) {
    switch (state?.toLowerCase()) {
      case 'merged':
        return prMerged;
      case 'open':
        return prOpen;
      case 'closed':
        return prClosed;
      default:
        return prUnknown;
    }
  }

  /// Whether [state] is one the palette has a filled treatment for.
  bool isKnownState(String? state) {
    const known = {'merged', 'open', 'closed'};
    return known.contains(state?.toLowerCase());
  }

  @override
  PortfolioPalette copyWith({
    Color? prMerged,
    Color? prOpen,
    Color? prClosed,
    Color? prUnknown,
    Color? onStateChip,
    Color? star,
  }) {
    return PortfolioPalette(
      prMerged: prMerged ?? this.prMerged,
      prOpen: prOpen ?? this.prOpen,
      prClosed: prClosed ?? this.prClosed,
      prUnknown: prUnknown ?? this.prUnknown,
      onStateChip: onStateChip ?? this.onStateChip,
      star: star ?? this.star,
    );
  }

  @override
  PortfolioPalette lerp(covariant PortfolioPalette? other, double t) {
    if (other == null) return this;
    return PortfolioPalette(
      prMerged: Color.lerp(prMerged, other.prMerged, t)!,
      prOpen: Color.lerp(prOpen, other.prOpen, t)!,
      prClosed: Color.lerp(prClosed, other.prClosed, t)!,
      prUnknown: Color.lerp(prUnknown, other.prUnknown, t)!,
      onStateChip: Color.lerp(onStateChip, other.onStateChip, t)!,
      star: Color.lerp(star, other.star, t)!,
    );
  }
}

extension PortfolioPaletteAccess on BuildContext {
  PortfolioPalette get palette => Theme.of(this).extension<PortfolioPalette>()!;
}
