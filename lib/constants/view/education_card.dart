import 'package:flutter/material.dart';
import 'package:portfolio/constants/models/education.dart';
import 'package:portfolio/constants/view/build_card_with_title_and_children.dart';
import 'package:portfolio/constants/view/custom_card.dart';

class EducationCard extends StatelessWidget {
  final List<Education> educations;

  const EducationCard({super.key, required this.educations});

  @override
  Widget build(BuildContext context) {
    List<Widget> educationWidgets = educations
        .map((education) => CustomCard(
              title: education.degree,
              items: [
                education.institution,
                education.gradationProject,
                education.period
              ],
            ))
        .toList();
    return buildCardWithTitleAndChildren("Education", educationWidgets);
  }
}
