import 'package:portfolio/constants/models/course.dart';
import 'package:portfolio/constants/models/education.dart';
import 'package:portfolio/constants/models/experience.dart';

class Constants {
  static String githubUsername = 'zezo357';
  static String? githubToken;
  static String profilePictureUrl = ''; // Replace with actual path or URL
  static String profileName =
      'Abdelaziz Mahdy'; // Replace with your actual name

  static List<String> profile = [
    'Passionate CS graduate with a focus on mobile application development, especially in Flutter.',
    'Developed Multiple apps and contributed to packages like \'pytorch_lite\' and \'media-kit\'.',
    'Aiming to master full-stack development.',
    'Active in open-source contributor.'
  ];

  static List<Education> education = [
    Education(
        degree: 'Bachelor\'s Degree in Computer Science',
        institution: 'Nile University',
        gradationProject: 'Smartphone medical diagnosis',
        period: 'Sep 2018 - Sep 2022' // Placeholder for actual period
        )
  ];

  static List<Experience> experience = [
    Experience(
        title: 'Full Stack Developer',
        company: 'Intixel',
        responsibilities: [
          'Developed backend using Django.',
          'Integrated blockchain and managed smart contracts in Solidity.',
          'Implemented oblivious transfer in Dart & Python.',
          'Set up gRPC server/client.',
          'Crafted two Flutter apps one published (https://play.google.com/store/apps/details?id=com.intixel.hayaty).',
          'Managed Docker deployment scripts.',
          'Automated workflows with GitHub Actions.',
        ],
        extra: ['Employee of the year 2023'],
        period: 'Jul 2022 - Present')
  ];

  static List<String> skills = [
    'Flutter Development - Seamless mobile application creation',
    'Data Analysis - Insightful data interpretation',
    'Full Stack Development - Proficient in Dart, Python, JavaScript, TypeScript, SQL',
    'Critical Thinking - Innovative problem-solving',
    'Game Development - Experience with Unreal Engine 4 and Unity',
    'Docker - Deployment using containerized environments',
    'GitHub Actions - Workflow automation for productivity',
    'gRPC - High-performance inter-service communication',
    'Object-Oriented Programming - Adherence to best practices',
    'Design Patterns - Solution implementation for complex challenges'
  ];

  static List<String> languages = ['Arabic', 'English'];

  static List<Course> courses = [
    Course(
        title: 'Advanced full stack web development',
        platform: 'Udacity',
        period: '02/2022 - 04/2022'),
    Course(
        title:
            'Improving Deep Neural Networks: Hyperparameter Tuning, Regularization and Optimization',
        platform: 'Coursera',
        period: '09/2021 - 09/2021'),
    Course(
        title: 'Structuring Machine Learning Projects',
        platform: 'Coursera',
        period: '09/2021 - 09/2021'),
    Course(
        title: 'Neural Networks and Deep Learning',
        platform: 'Coursera',
        period: '08/2021 - 09/2021')
  ];
}

class StylingConstants {
  static const double cardsWidth = 400;
  static const double listViewHeight = 400;
}
