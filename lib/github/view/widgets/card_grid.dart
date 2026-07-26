import 'package:flutter/material.dart';

/// A responsive grid of equal-width columns.
///
/// The column count is supplied by the caller from a measured width, which is
/// the whole point: the previous grids hard-coded `crossAxisCount: 2` and
/// wrapped every child in `SizedBox(width: 400)`, so a 375px phone was asked
/// to lay out 800px of cards and scrolled sideways.
///
/// Rows use [IntrinsicHeight] so cards in the same row share a height instead
/// of leaving ragged gaps.
class CardGrid extends StatelessWidget {
  final int columns;
  final double spacing;
  final bool equalHeights;
  final List<Widget> children;

  const CardGrid({
    super.key,
    required this.columns,
    required this.children,
    this.spacing = 16,
    this.equalHeights = true,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    if (columns <= 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _withGaps(children, spacing),
      );
    }

    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += columns) {
      final slice = children.skip(i).take(columns).toList();

      final row = Row(
        crossAxisAlignment: equalHeights
            ? CrossAxisAlignment.stretch
            : CrossAxisAlignment.start,
        children: [
          for (var c = 0; c < columns; c++) ...[
            if (c > 0) SizedBox(width: spacing),
            Expanded(
              child: c < slice.length ? slice[c] : const SizedBox.shrink(),
            ),
          ],
        ],
      );

      rows.add(equalHeights ? IntrinsicHeight(child: row) : row);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _withGaps(rows, spacing),
    );
  }

  static List<Widget> _withGaps(List<Widget> items, double gap) {
    final result = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (i > 0) result.add(SizedBox(height: gap));
      result.add(items[i]);
    }
    return result;
  }
}
