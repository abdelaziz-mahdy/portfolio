import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Color getStateColor(String? state) {
  switch (state?.toLowerCase()) {
    case 'open':
      // GitHub uses shades of green to represent open states.
      // Converted hex to RGB: R=44, G=190, B=78
      return const Color.fromRGBO(44, 190, 78,
          1.0); // This RGB is a close match to GitHub's open state color.
    case 'closed':
      // GitHub uses shades of red to represent closed states.
      // Converted hex to RGB: R=203, G=36, B=49
      return const Color.fromRGBO(203, 36, 49,
          1.0); // This RGB is a close match to GitHub's closed state color.
    case 'merged':
      // GitHub uses shades of purple to represent merged states.
      // Converted hex to RGB: R=111, G=66, B=193
      return const Color.fromRGBO(111, 66, 193,
          1.0); // This RGB is a close match to GitHub's merged state color.
    default:
      // Default grey color for undefined states.
      return Colors.grey.shade300;
  }
}

bool isPortrait(BuildContext context) {
  return MediaQuery.of(context).size.width < 600;
}

/// Opens [url] in a new tab or the platform browser.
///
/// Reports failure through the caller's [ScaffoldMessenger] rather than
/// throwing, so a dead link never breaks the page.
Future<void> openExternalUrl(BuildContext context, String? url) async {
  if (url == null || url.isEmpty) {
    return;
  }

  final uri = Uri.tryParse(url);
  if (uri == null || !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not open $url')),
    );
  }
}
