import 'package:flutter/material.dart';
import 'package:portfolio/constants/constants.dart';
import 'package:portfolio/github/models/portfolio_data.dart';

class ProfileSection extends StatelessWidget {
  final PortfolioData data;

  const ProfileSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: StylingConstants.profileSectionHeight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth > 600;
            final children = [
              const Spacer(),
              Expanded(child: _buildImageSection()),
              const Spacer(),
              Expanded(flex: 4, child: _buildDetailsSection(context)),
              const Spacer(),
            ];

            return isWide
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children)
                : Column(children: children);
          },
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    if (data.imageUrl.isEmpty) {
      return const _AvatarPlaceholder();
    }

    return ClipOval(
      child: Image.network(
        data.imageUrl,
        fit: BoxFit.scaleDown,
        // A broken avatar should not read as a broken page.
        errorBuilder: (context, error, stackTrace) => const _AvatarPlaceholder(),
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(Constants.profileName,
            style: Theme.of(context).textTheme.titleLarge),
        ...Constants.profile.map((detail) => Text(detail)),
      ],
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 60,
      child: Icon(Icons.person, size: 120),
    );
  }
}
