import 'package:flutter/material.dart';
import 'package:portfolio/constants/view/build_card_with_title_and_children.dart';
import 'package:portfolio/constants/view/info_entry.dart';
import 'package:portfolio/profile/models/profile.dart';

class CertificatesCard extends StatelessWidget {
  final List<Certificate> certificates;

  const CertificatesCard({super.key, required this.certificates});

  @override
  Widget build(BuildContext context) {
    return buildCardWithTitleAndChildren(
      context,
      'Certificates',
      [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: certificates
                .map((certificate) => InfoEntry(
                      title: certificate.name,
                      meta: [certificate.issuer, certificate.date],
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class AwardsCard extends StatelessWidget {
  final List<Award> awards;

  const AwardsCard({super.key, required this.awards});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return buildCardWithTitleAndChildren(
      context,
      'Awards',
      [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: awards
                .map((award) => InfoEntry(
                      title: award.title,
                      meta: [award.issuer, award.date],
                      child: award.description == null
                          ? null
                          : Text(
                              award.description!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
