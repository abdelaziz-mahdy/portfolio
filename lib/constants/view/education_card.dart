import 'package:flutter/material.dart';
import 'package:portfolio/constants/view/build_card_with_title_and_children.dart';
import 'package:portfolio/constants/view/info_entry.dart';
import 'package:portfolio/profile/models/profile.dart';

class EducationCard extends StatelessWidget {
  final List<Education> educations;

  const EducationCard({super.key, required this.educations});

  @override
  Widget build(BuildContext context) {
    return buildCardWithTitleAndChildren(
      context,
      'Education',
      [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: educations
                .map((education) => InfoEntry(
                      title: education.degree,
                      meta: [
                        education.institution,
                        education.period,
                        education.location,
                      ],
                      child: education.graduationProject == null
                          ? null
                          : _GraduationProject(education: education),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

/// The graduation project is a distinct fact, not another line of metadata —
/// it previously sat with the institution and the dates in identical grey
/// text, so it read as a third date field.
class _GraduationProject extends StatelessWidget {
  final Education education;

  const _GraduationProject({required this.education});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const EntryLabel('Graduation project'),
        Text(education.graduationProject!, style: theme.textTheme.bodyMedium),
        if (education.graduationProjectDescription != null) ...[
          const SizedBox(height: 3),
          Text(
            education.graduationProjectDescription!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
