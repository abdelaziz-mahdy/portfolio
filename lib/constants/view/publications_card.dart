import 'package:flutter/material.dart';
import 'package:portfolio/constants/view/build_card_with_title_and_children.dart';
import 'package:portfolio/constants/view/info_entry.dart';
import 'package:portfolio/github/utils.dart';
import 'package:portfolio/profile/models/profile.dart';

class PublicationsCard extends StatelessWidget {
  final List<Publication> publications;

  const PublicationsCard({super.key, required this.publications});

  @override
  Widget build(BuildContext context) {
    return buildCardWithTitleAndChildren(
      context,
      'Publications',
      [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: publications
                .map((publication) => InfoEntry(
                      title: publication.title,
                      meta: [publication.venue, publication.date],
                      child: _Details(publication: publication),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _Details extends StatelessWidget {
  final Publication publication;

  const _Details({required this.publication});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (publication.citation != null)
          Text(
            publication.citation!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        if (publication.url != null) ...[
          const SizedBox(height: 6),
          // A DOI is the citable, permanent handle — worth an explicit action
          // rather than being buried in the citation text.
          TextButton.icon(
            onPressed: () => openExternalUrl(context, publication.url),
            icon: const Icon(Icons.open_in_new, size: 15),
            label: const Text('Read the paper'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ],
    );
  }
}
