import 'package:flutter/material.dart';
import 'package:portfolio/widgets/linked_text.dart';

/// One item inside a biography card: a title and its supporting lines.
///
/// These used to be [Card]s nested inside a [Card], which drew a second border
/// around every row and gave a course the same visual containment as the whole
/// Courses section. Containment should mean something; here the card boundary
/// belongs to the section, and the entries inside it just need hierarchy.
class InfoEntry extends StatelessWidget {
  final String title;
  final List<String?> meta;
  final Widget? child;

  const InfoEntry({
    super.key,
    required this.title,
    this.meta = const [],
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lines = meta.whereType<String>().where((m) => m.isNotEmpty).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (lines.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              // A middot separator reads as one supporting line rather than
              // three equally weighted ones stacked under the title.
              lines.join('  ·  '),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (child != null) ...[
            const SizedBox(height: 8),
            child!,
          ],
        ],
      ),
    );
  }
}

/// A bullet list with a hanging indent.
///
/// Prefixing a string with `'• '` looks right until the line wraps: the
/// continuation returns to the bullet's own left edge, so the bullet stops
/// marking where the item starts. Laying the marker out beside the text keeps
/// wrapped lines aligned under the first word.
class BulletList extends StatelessWidget {
  final List<String> items;

  const BulletList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('•',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        )),
                    const SizedBox(width: 8),
                    Expanded(
                      child: LinkedText(item, style: theme.textTheme.bodyMedium),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

/// A small uppercase label introducing a group inside an entry.
class EntryLabel extends StatelessWidget {
  final String text;

  const EntryLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          letterSpacing: 0.9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
