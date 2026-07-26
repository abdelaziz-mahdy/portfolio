import 'package:flutter/material.dart';
import 'package:portfolio/constants/models/course.dart';
import 'package:portfolio/constants/view/build_card_with_title_and_children.dart';
import 'package:portfolio/constants/view/info_entry.dart';

class CourseCard extends StatelessWidget {
  final List<Course> courses;

  const CourseCard({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return buildCardWithTitleAndChildren(
      context,
      'Courses',
      [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: courses
                .map((course) => InfoEntry(
                      title: course.title,
                      meta: [course.platform, course.period],
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
