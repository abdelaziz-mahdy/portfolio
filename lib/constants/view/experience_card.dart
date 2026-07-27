import 'package:flutter/material.dart';
import 'package:portfolio/constants/view/build_card_with_title_and_children.dart';
import 'package:portfolio/constants/view/info_entry.dart';
import 'package:portfolio/profile/models/profile.dart';

class ExperienceCard extends StatelessWidget {
  final List<Experience> experiences;

  const ExperienceCard({super.key, required this.experiences});

  @override
  Widget build(BuildContext context) {
    return buildCardWithTitleAndChildren(
      context,
      'Experience',
      [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: experiences
                .map((experience) => _Experience(experience: experience))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _Experience extends StatelessWidget {
  final Experience experience;

  const _Experience({required this.experience});

  @override
  Widget build(BuildContext context) {
    return InfoEntry(
      title: '${experience.title}, ${experience.company}',
      // "05/2025 - Present" is self-evidently a period; the old "Period:"
      // prefix labelled something that needed no label.
      meta: [experience.period, experience.location],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (experience.responsibilities.isNotEmpty) ...[
            const EntryLabel('Responsibilities'),
            BulletList(items: experience.responsibilities),
          ],
          if (experience.extra.isNotEmpty) ...[
            const SizedBox(height: 12),
            const EntryLabel('Achievements'),
            BulletList(items: experience.extra),
          ],
        ],
      ),
    );
  }
}
