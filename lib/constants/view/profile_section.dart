import 'package:flutter/material.dart';
import 'package:portfolio/github/models/portfolio_data.dart';
import 'package:portfolio/github/utils.dart';
import 'package:portfolio/github/view/widgets/card_grid.dart';
import 'package:portfolio/layout/breakpoints.dart';
import 'package:portfolio/profile/models/profile.dart';
import 'package:portfolio/widgets/linked_text.dart';

/// The hero.
///
/// It no longer sits inside a fixed 400px box padded out with `Spacer()`s —
/// the content was about 180px tall, so half the first screen was empty and
/// could not shrink on a short viewport. And it now carries the numbers: 488
/// merged pull requests was previously plain body text far below the fold.
class ProfileSection extends StatelessWidget {
  final Profile profile;
  final PortfolioData githubData;

  const ProfileSection({
    super.key,
    required this.profile,
    required this.githubData,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final metrics = LayoutMetrics.of(constraints.maxWidth);
        final identity = _Identity(profile: profile, metrics: metrics);
        final isWide = metrics.breakpoint == Breakpoint.expanded ||
            metrics.breakpoint == Breakpoint.large;

        // On a wide window the bio stops at its readable measure well short of
        // the right edge, which left the hero looking left-aligned against the
        // full-width sections below it. Bringing the stats up alongside the
        // identity fills the row instead of padding it with empty space.
        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _Avatar(imageUrl: githubData.imageUrl, radius: 64),
              const SizedBox(width: 32),
              Expanded(child: identity),
              const SizedBox(width: 32),
              SizedBox(
                width: 400,
                child: _StatGrid(data: githubData, columns: 2),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (metrics.isCompact)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Avatar(imageUrl: githubData.imageUrl, radius: 44),
                  const SizedBox(height: 20),
                  identity,
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _Avatar(imageUrl: githubData.imageUrl, radius: 64),
                  const SizedBox(width: 32),
                  Expanded(child: identity),
                ],
              ),
            const SizedBox(height: 28),
            _StatGrid(data: githubData, columns: metrics.isCompact ? 2 : 4),
          ],
        );
      },
    );
  }
}

class _Identity extends StatelessWidget {
  final Profile profile;
  final LayoutMetrics metrics;

  const _Identity({required this.profile, required this.metrics});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      // Caps the measure at roughly 70 characters. The bio previously ran the
      // full container width — about 95 characters on a 1600px display.
      constraints: BoxConstraints(maxWidth: metrics.readableTextWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            profile.name,
            style: metrics.isCompact
                ? theme.textTheme.headlineSmall
                : theme.textTheme.displaySmall,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Flexible(
                child: Text(
                  profile.tagline,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              if (profile.location != null) ...[
                Text(
                  '  ·  ',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Flexible(
                  child: Text(
                    profile.location!,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          ...profile.summary.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: LinkedText(line, style: theme.textTheme.bodyMedium),
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String imageUrl;
  final double radius;

  const _Avatar({required this.imageUrl, required this.radius});

  @override
  Widget build(BuildContext context) {
    final placeholder = CircleAvatar(
      radius: radius,
      child: Icon(Icons.person, size: radius * 1.2),
    );

    if (imageUrl.isEmpty) return placeholder;

    return ClipOval(
      child: Image.network(
        imageUrl,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        // Reserving the final size up front keeps the hero from reflowing when
        // the avatar arrives.
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) return child;
          return SizedBox(width: radius * 2, height: radius * 2);
        },
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }
}

/// The evidence, above the fold.
class _StatGrid extends StatelessWidget {
  final PortfolioData data;
  final int columns;

  const _StatGrid({required this.data, required this.columns});

  @override
  Widget build(BuildContext context) {
    final merged = data.pullRequestStates['merged'] ?? 0;

    return CardGrid(
      columns: columns,
      spacing: 12,
      children: [
        _Stat(formatCount(merged), 'Pull requests merged'),
        _Stat('${data.contributions.length}', 'Repos contributed to'),
        _Stat('${data.repositories.length}', 'Public projects'),
        _Stat(formatCount(data.totalStars), 'Stars earned'),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;

  const _Stat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
