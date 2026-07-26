import 'package:flutter/widgets.dart';

/// Material's window size classes.
///
/// This replaces the single `isPortrait()` boolean, which answered "is the
/// window narrower than 600px" and was then used to decide every layout
/// question on the page — including ones where a 1280px laptop and a 2560px
/// display need different answers.
enum Breakpoint {
  compact,
  medium,
  expanded,
  large;

  static Breakpoint of(double width) {
    if (width < 600) return Breakpoint.compact;
    if (width < 840) return Breakpoint.medium;
    if (width < 1240) return Breakpoint.expanded;
    return Breakpoint.large;
  }

  bool get isCompact => this == Breakpoint.compact;
}

/// Layout metrics derived from the available width.
///
/// Always build these from a [LayoutBuilder]'s constraints rather than from
/// `MediaQuery.size`, so a widget nested inside a narrower column gets the
/// column's width and not the window's.
@immutable
class LayoutMetrics {
  final double width;
  final Breakpoint breakpoint;

  const LayoutMetrics._(this.width, this.breakpoint);

  factory LayoutMetrics.of(double width) =>
      LayoutMetrics._(width, Breakpoint.of(width));

  bool get isCompact => breakpoint.isCompact;

  /// Horizontal page inset. Wider windows get more room, rather than the same
  /// narrow gutter at every size.
  double get pageGutter => switch (breakpoint) {
        Breakpoint.compact => 16,
        Breakpoint.medium => 24,
        Breakpoint.expanded => 40,
        Breakpoint.large => 56,
      };

  /// Vertical space between major sections.
  double get sectionGap => isCompact ? 32 : 48;

  /// Column count for a card grid whose cards read comfortably at ~360px.
  ///
  /// Derived from the width actually available instead of a fixed count, which
  /// is what put 800px of cards into a 355px column on a phone.
  int columnsFor({double minCardWidth = 340, int max = 3}) {
    final columns = (width / minCardWidth).floor();
    return columns.clamp(1, max);
  }

  /// Longest comfortable line for running text, in logical pixels.
  ///
  /// Roughly 70 characters at the body text size — past that the eye starts
  /// losing its place on the return sweep.
  double get readableTextWidth => 620;
}

/// Reads layout metrics from the nearest [MediaQuery].
///
/// Prefer [LayoutMetrics.of] with a [LayoutBuilder]; this is for places that
/// genuinely care about the window, such as the page shell.
LayoutMetrics windowMetrics(BuildContext context) =>
    LayoutMetrics.of(MediaQuery.sizeOf(context).width);
