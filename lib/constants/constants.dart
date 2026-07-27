/// Wiring, not content.
///
/// Everything a reader sees — name, bio, experience, education, skills,
/// publications, certificates, awards, courses — lives in `profile.json` so it
/// can be edited and published without touching Dart or rebuilding the app.
/// Only the plumbing that says *where to find* that content belongs here.
class Constants {
  static String githubUsername = 'abdelaziz-mahdy';

  /// Repository holding both JSON documents.
  static String githubDataRepository = 'portfolio';
  static String githubDataBranch = 'main';

  /// Both documents live in `assets/`, so the bundled path and the path on
  /// `main` are the same string — one place to be wrong instead of two.
  static const String _assetDir = 'assets';

  static String _rawUrl(String file) =>
      'https://raw.githubusercontent.com/$githubUsername/$githubDataRepository/$githubDataBranch/$_assetDir/$file';

  /// CI-generated GitHub dataset. Served from a CDN with no rate limit and
  /// refreshed by the workflow without a redeploy.
  static String get githubDataUrl => _rawUrl('user_info.json');
  static const String githubDataAsset = '$_assetDir/user_info.json';

  /// Hand-edited biography content. Editing this file on `main` updates the
  /// live site; no rebuild required.
  static String get profileDataUrl => _rawUrl('profile.json');
  static const String profileDataAsset = '$_assetDir/profile.json';

  /// Used for document metadata before `profile.json` has loaded. The same
  /// name is in `web/index.html`, which is what crawlers actually read.
  static const String fallbackName = 'Abdelaziz Mahdy';
}
