import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens [url] in a new tab or the platform browser.
///
/// Reports failure through the caller's [ScaffoldMessenger] rather than
/// throwing, so a dead link never breaks the page.
Future<void> openExternalUrl(BuildContext context, String? url) async {
  if (url == null || url.isEmpty) {
    return;
  }

  final uri = Uri.tryParse(url);
  final messenger = ScaffoldMessenger.maybeOf(context);

  if (uri == null ||
      !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    messenger?.showSnackBar(
      SnackBar(content: Text('Could not open $url')),
    );
  }
}

/// Compact star counts: 12837 reads as "12.8k".
String formatCount(int value) {
  if (value < 1000) return '$value';
  if (value < 10000) return '${(value / 1000).toStringAsFixed(1)}k';
  if (value < 1000000) return '${(value / 1000).round()}k';
  return '${(value / 1000000).toStringAsFixed(1)}M';
}
