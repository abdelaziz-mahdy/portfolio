import 'package:flutter/material.dart';
import 'package:portfolio/constants/view/build_card_with_title_and_children.dart';

class SkillsCard extends StatelessWidget {
  final List<String> skills;

  const SkillsCard({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    return buildCardWithTitleAndChildren(
      context,
      'Skills',
      [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: skills.map((skill) => _SkillRow(skill: skill)).toList(),
          ),
        ),
      ],
    );
  }
}

/// One skill: the name, then what it means.
///
/// Each of these used to be a rounded outlined container — a chip. Chips are an
/// interactive affordance, and these are not interactive; the border promised a
/// tap that never happened. The strings are also `"Name - Description"` pairs
/// rendered as one undifferentiated run of text, so the skill and its blurb
/// carried identical weight and neither could be scanned.
class _SkillRow extends StatelessWidget {
  final String skill;

  const _SkillRow({required this.skill});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final separator = skill.indexOf(' - ');
    final name = separator == -1 ? skill : skill.substring(0, separator);
    final detail = separator == -1 ? null : skill.substring(separator + 3);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (detail != null)
            Text(
              detail,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}
