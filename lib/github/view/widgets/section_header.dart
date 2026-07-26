import 'package:flutter/material.dart';
import 'package:portfolio/layout/breakpoints.dart';

/// A section title, its supporting line, and optional trailing content.
///
/// Headings read from [TextTheme] rather than a literal
/// `TextStyle(fontSize: 20, fontWeight: bold)`. Three headings all set to
/// "20px bold" expressed no hierarchy between the page, its sections, and the
/// cards inside them.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: theme.textTheme.headlineSmall),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );

    if (trailing == null) return text;

    return LayoutBuilder(
      builder: (context, constraints) {
        final metrics = LayoutMetrics.of(constraints.maxWidth);

        if (metrics.isCompact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [text, const SizedBox(height: 12), trailing!],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: text),
            const SizedBox(width: 16),
            trailing!,
          ],
        );
      },
    );
  }
}
