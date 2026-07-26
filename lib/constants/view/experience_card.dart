import 'package:flutter/material.dart';
import 'package:portfolio/constants/models/experience.dart';
import 'package:portfolio/constants/view/build_card_with_title_and_children.dart';
import 'package:portfolio/constants/view/info_entry.dart';

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
    final extra = experience.extra;

    return InfoEntry(
      title: '${experience.title}, ${experience.company}',
      // "Jul 2022 - Present" is self-evidently a period; the "Period:" prefix
      // was labelling something that needed no label.
      meta: [experience.period],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const EntryLabel('Responsibilities'),
          BulletList(items: experience.responsibilities),
          if (extra != null && extra.isNotEmpty) ...[
            const SizedBox(height: 12),
            const EntryLabel('Achievements'),
            BulletList(items: extra),
          ],
        ],
      ),
    );
  }
}
