import 'package:flutter/material.dart';
import 'package:portfolio/constants/view/build_card_with_title_and_children.dart';
import 'package:portfolio/profile/models/profile.dart';

class SkillsCard extends StatelessWidget {
  final List<Skill> skills;

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

/// A skill category, then what's in it.
///
/// These used to be rounded outlined containers — chips. A chip is an
/// interactive affordance, and these are not interactive; the border promised
/// a tap that never happened. The category and its contents also shared one
/// weight, so neither could be scanned.
class _SkillRow extends StatelessWidget {
  final Skill skill;

  const _SkillRow({required this.skill});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            skill.category,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (skill.items.isNotEmpty)
            Text(
              skill.items,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}
