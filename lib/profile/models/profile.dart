/// Models for `profile.json` — the biography content.
///
/// This lives in JSON rather than in Dart so the content can be edited and
/// published without touching code or rebuilding: the app reads the file from
/// the CDN at runtime, the same way it reads the CI-generated GitHub dataset.
library;

class Profile {
  final String name;
  final String tagline;
  final String? location;
  final String? email;
  final String? linkedInUrl;
  final String? githubUrl;
  final List<String> summary;
  final List<String> languages;
  final List<Skill> skills;
  final List<Experience> experience;
  final List<Education> education;
  final List<Publication> publications;
  final List<Certificate> certificates;
  final List<Award> awards;
  final List<Course> courses;

  const Profile({
    required this.name,
    required this.tagline,
    required this.location,
    required this.email,
    required this.linkedInUrl,
    required this.githubUrl,
    required this.summary,
    required this.languages,
    required this.skills,
    required this.experience,
    required this.education,
    required this.publications,
    required this.certificates,
    required this.awards,
    required this.courses,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] as String? ?? '',
      tagline: json['tagline'] as String? ?? '',
      location: _text(json['location']),
      email: _text(json['email']),
      linkedInUrl: _text(json['linkedin_url']),
      githubUrl: _text(json['github_url']),
      summary: _strings(json['summary']),
      languages: _strings(json['languages']),
      skills: _list(json['skills'], Skill.fromJson),
      experience: _list(json['experience'], Experience.fromJson),
      education: _list(json['education'], Education.fromJson),
      publications: _list(json['publications'], Publication.fromJson),
      certificates: _list(json['certificates'], Certificate.fromJson),
      awards: _list(json['awards'], Award.fromJson),
      courses: _list(json['courses'], Course.fromJson),
    );
  }
}

/// Null, missing and blank all mean "not provided", so every optional string
/// funnels through here. A section keyed off a null renders nothing; one keyed
/// off an empty string renders an empty line.
String? _text(dynamic value) {
  if (value is! String) return null;
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

List<String> _strings(dynamic value) =>
    (value as List? ?? []).whereType<String>().toList();

List<T> _list<T>(dynamic value, T Function(Map<String, dynamic>) parse) =>
    (value as List? ?? [])
        .whereType<Map>()
        .map((item) => parse(item.cast<String, dynamic>()))
        .toList();

class Skill {
  final String category;
  final String items;

  const Skill({required this.category, required this.items});

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
        category: json['category'] as String? ?? '',
        items: json['items'] as String? ?? '',
      );
}

class Experience {
  final String title;
  final String company;
  final String period;
  final String? location;
  final List<String> responsibilities;
  final List<String> extra;

  const Experience({
    required this.title,
    required this.company,
    required this.period,
    required this.location,
    required this.responsibilities,
    required this.extra,
  });

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
        title: json['title'] as String? ?? '',
        company: json['company'] as String? ?? '',
        period: json['period'] as String? ?? '',
        location: _text(json['location']),
        responsibilities: _strings(json['responsibilities']),
        extra: _strings(json['extra']),
      );
}

class Education {
  final String degree;
  final String institution;
  final String period;
  final String? location;
  final String? graduationProject;
  final String? graduationProjectDescription;

  const Education({
    required this.degree,
    required this.institution,
    required this.period,
    required this.location,
    required this.graduationProject,
    required this.graduationProjectDescription,
  });

  factory Education.fromJson(Map<String, dynamic> json) => Education(
        degree: json['degree'] as String? ?? '',
        institution: json['institution'] as String? ?? '',
        period: json['period'] as String? ?? '',
        location: _text(json['location']),
        graduationProject: _text(json['graduation_project']),
        graduationProjectDescription:
            _text(json['graduation_project_description']),
      );
}

class Publication {
  final String title;
  final String venue;
  final String date;
  final String? citation;
  final String? url;

  const Publication({
    required this.title,
    required this.venue,
    required this.date,
    required this.citation,
    required this.url,
  });

  factory Publication.fromJson(Map<String, dynamic> json) => Publication(
        title: json['title'] as String? ?? '',
        venue: json['venue'] as String? ?? '',
        date: json['date'] as String? ?? '',
        citation: _text(json['citation']),
        url: _text(json['url']),
      );
}

class Certificate {
  final String name;
  final String issuer;
  final String date;

  const Certificate({
    required this.name,
    required this.issuer,
    required this.date,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) => Certificate(
        name: json['name'] as String? ?? '',
        issuer: json['issuer'] as String? ?? '',
        date: json['date'] as String? ?? '',
      );
}

class Award {
  final String title;
  final String issuer;
  final String date;
  final String? description;

  const Award({
    required this.title,
    required this.issuer,
    required this.date,
    required this.description,
  });

  factory Award.fromJson(Map<String, dynamic> json) => Award(
        title: json['title'] as String? ?? '',
        issuer: json['issuer'] as String? ?? '',
        date: json['date'] as String? ?? '',
        description: _text(json['description']),
      );
}

class Course {
  final String title;
  final String platform;
  final String period;

  const Course({
    required this.title,
    required this.platform,
    required this.period,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        title: json['title'] as String? ?? '',
        platform: json['platform'] as String? ?? '',
        period: json['period'] as String? ?? '',
      );
}
