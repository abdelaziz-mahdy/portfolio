import 'package:flutter/material.dart';

/// A titled card used by the biography sections.
///
/// The heading reads from [TextTheme] rather than a literal
/// `TextStyle(fontSize: 20, fontWeight: bold)`, which is why this takes a
/// [BuildContext]: the old top-level function had no way to reach the theme,
/// so it hard-coded the size.
Widget buildCardWithTitleAndChildren(
  BuildContext context,
  String title,
  List<Widget> children,
) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          ...children,
        ],
      ),
    ),
  );
}
