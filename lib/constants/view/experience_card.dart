import 'package:flutter/material.dart';
import 'package:portfolio/constants/models/experience.dart';
import 'package:portfolio/constants/view/build_card_with_title_and_children.dart';

class ExperienceCard extends StatelessWidget {
  final List<Experience> experiences;

  const ExperienceCard({super.key, required this.experiences});

  @override
  Widget build(BuildContext context) {
    return buildCardWithTitleAndChildren(
      "Experience",
      experiences
          .map((experience) => _buildExperienceContent(context, experience))
          .toList(),
    );
  }

  Widget _buildExperienceContent(BuildContext context, Experience experience) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${experience.title} at ${experience.company}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Period: ${experience.period}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            const Text('Responsibilities:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ...experience.responsibilities.map((item) =>
                Text('• $item', style: const TextStyle(fontSize: 16))),
            if (experience.extra != null && experience.extra!.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text('Achievements:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ...experience.extra!.map((item) =>
                  Text('• $item', style: const TextStyle(fontSize: 16))),
            ],
          ],
        ),
      ),
    );
  }
}
