import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/profile/models/profile.dart';

void main() {
  group('Profile.fromJson', () {
    test('parses the shipped profile.json', () {
      final raw = File('assets/profile.json').readAsStringSync();
      final profile =
          Profile.fromJson(json.decode(raw) as Map<String, dynamic>);

      expect(profile.name, isNotEmpty);
      expect(profile.tagline, isNotEmpty);
      expect(profile.experience, isNotEmpty);
      expect(profile.skills, isNotEmpty);
      expect(profile.education, isNotEmpty);
    });

    test('the shipped profile carries no phone number or third-party contacts',
        () {
      // assets/profile.json is committed to a public repository and served from a
      // CDN. A regression that pastes CV contact details in here would expose
      // the author's phone and other people's addresses.
      final raw = File('assets/profile.json').readAsStringSync();

      expect(RegExp(r'\+\d[\d\s().-]{7,}').hasMatch(raw), isFalse,
          reason: 'profile.json must not contain a phone number');
      expect(raw.toLowerCase().contains('reference'), isFalse,
          reason: 'profile.json must not contain a references section');

      final emails = RegExp(r'[\w.+-]+@[\w-]+\.[\w.]+')
          .allMatches(raw)
          .map((m) => m.group(0)!)
          .toSet();
      expect(emails.length, lessThanOrEqualTo(1),
          reason: 'only the author\'s own address belongs here, found $emails');
    });

    test('treats null, missing and blank optional strings alike', () {
      final profile = Profile.fromJson({
        'name': 'Test Person',
        'tagline': 'Developer',
        'location': '   ',
        'education': [
          {
            'degree': 'BSc',
            'institution': 'Somewhere',
            'period': '2018 - 2022',
            'graduation_project': null,
          }
        ],
      });

      expect(profile.location, isNull);
      expect(profile.email, isNull);
      expect(profile.summary, isEmpty);
      expect(profile.publications, isEmpty);
      expect(profile.education.single.graduationProject, isNull);
      expect(profile.education.single.location, isNull);
    });

    test('survives a document with nothing but a name', () {
      final profile = Profile.fromJson({'name': 'Test Person'});

      expect(profile.name, 'Test Person');
      expect(profile.tagline, '');
      expect(profile.skills, isEmpty);
      expect(profile.experience, isEmpty);
    });
  });
}
