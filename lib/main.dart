import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:portfolio/constants/constants.dart';
import 'package:portfolio/constants/models/course.dart';
import 'package:portfolio/constants/models/education.dart';
import 'package:portfolio/constants/models/experience.dart';
import 'package:portfolio/github/view/pull_requests/pull_requests_on_public_repos.dart';
import 'package:portfolio/github/view/repos/repositories_list.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const PortfolioHomePage(),
    );
  }
}

class PortfolioHomePage extends StatelessWidget {
  const PortfolioHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.email),
            onPressed: () {
              // Handle your email action here
            },
          ),
          IconButton(
            icon: const Icon(Icons.link),
            onPressed: () {
              // Handle your LinkedIn action here
            },
          ),
          IconButton(
            icon: const Icon(Icons.code),
            onPressed: () {
              // Handle your GitHub action here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: StaggeredGrid.count(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
          // childAspectRatio: (MediaQuery.of(context).size.width / 2) / 300,
          children: [
            CourseCard(courses: Constants.courses),
            SkillsCard(skills: Constants.skills),
            EducationCard(educations: Constants.education),
            ExperienceCard(experiences: Constants.experience),
            // PullRequestsOnPublicRepos(),  // Uncomment if these are to be included
            // RepositoriesList(),           // Adjust layout or wrap with a fixed height Container if necessary
          ],
        ),
      ),
    );
  }
}

class SkillsCard extends StatelessWidget {
  final List<String> skills;

  const SkillsCard({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Skills',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: skills
                  .map((skill) => Card(
                        margin: const EdgeInsets.all(2.0),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            skill,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildCardWithTitleAndChildren(String title, List<Widget> children) {
  return Card(
    margin: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        ...children,
      ],
    ),
  );
}

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

class CustomCard extends StatelessWidget {
  final String title;
  final List<String> items;

  const CustomCard({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        child: ListTile(
          title: Text(title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items.map((item) => Text(item)).toList(),
          ),
        ),
      ),
    );
  }
}
