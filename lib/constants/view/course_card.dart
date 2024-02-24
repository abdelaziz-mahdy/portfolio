import 'package:flutter/material.dart';
import 'package:portfolio/constants/models/course.dart';
import 'package:portfolio/constants/view/build_card_with_title_and_children.dart';
import 'package:portfolio/constants/view/custom_card.dart';

class CourseCard extends StatelessWidget {
  final List<Course> courses;

  const CourseCard({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    List<Widget> courseWidgets = courses
        .map((course) => CustomCard(
              title: course.title,
              items: [course.platform, course.period],
            ))
        .toList();
    return buildCardWithTitleAndChildren("Courses", courseWidgets);
  }
}
