import 'package:flutter/material.dart';
import 'package:portfolio/constants/constants.dart';
import 'package:portfolio/github/data/github_data.dart';

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final ValueNotifier<String?> _userImageUrl = ValueNotifier(null);
  final ValueNotifier<String?> _errorMessage = ValueNotifier(null);
  final GitHubAPI _gitHubAPI =
      GitHubAPI(Constants.githubUsername, token: Constants.githubToken);

  @override
  void initState() {
    super.initState();
    _fetchUserImage();
  }

  Future<void> _fetchUserImage() async {
    _isLoading.value = true;
    try {
      final imageUrl = await _gitHubAPI.fetchUserAvatarUrl();
      _userImageUrl.value = imageUrl;
    } catch (e) {
      _errorMessage.value = 'Failed to load user image';
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: StylingConstants.listViewHeight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool isWide = constraints.maxWidth > 600;
            List<Widget> children = [
              const Spacer(),
              // Image and details go here
              _buildImageSection(),
              const Spacer(),
              Expanded(flex: 4, child: _buildDetailsSection()),
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
    // Build the image section here, using ValueListenableBuilder for _userImageUrl
    return ValueListenableBuilder<String?>(
      valueListenable: _userImageUrl,
      builder: (context, imageUrl, _) {
        return imageUrl != null
            ? ClipOval(
                child: Image.network(imageUrl,
                    width: 120, height: 120, fit: BoxFit.scaleDown))
            : const CircleAvatar(
                radius: 60,
                child: Icon(Icons.person,
                    size: 120)); // Placeholder for loading/error
      },
    );
  }

  Widget _buildDetailsSection() {
    // Build the details section here
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

  @override
  void dispose() {
    _isLoading.dispose();
    _userImageUrl.dispose();
    _errorMessage.dispose();
    super.dispose();
  }
}
