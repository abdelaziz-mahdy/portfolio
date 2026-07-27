import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/github/utils.dart';

/// Renders text that may contain inline `[label](url)` links.
///
/// Content lives in `profile.json`, so it cannot carry widgets — a URL written
/// into a sentence would otherwise render as a raw string: unclickable, and
/// long enough to wrap mid-path and wreck the line. This keeps the source
/// readable and the output tappable without adding a field for every link.
class LinkedText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;

  const LinkedText(this.text, {super.key, this.style, this.maxLines});

  static final _pattern = RegExp(r'\[([^\]]+)\]\(([^)\s]+)\)');

  /// Whether [text] contains at least one inline link.
  static bool hasLink(String text) => _pattern.hasMatch(text);

  /// The text with link markup flattened to its labels, for places that need a
  /// plain string such as a semantics label.
  static String strip(String text) =>
      text.replaceAllMapped(_pattern, (match) => match.group(1)!);

  @override
  State<LinkedText> createState() => _LinkedTextState();
}

class _LinkedTextState extends State<LinkedText> {
  final _recognizers = <TapGestureRecognizer>[];

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  void _disposeRecognizers() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = widget.style ?? theme.textTheme.bodyMedium;

    // Recognizers hold a callback each; rebuilding without disposing the old
    // ones leaks them.
    _disposeRecognizers();

    final spans = <InlineSpan>[];
    var index = 0;

    for (final match in LinkedText._pattern.allMatches(widget.text)) {
      if (match.start > index) {
        spans.add(TextSpan(text: widget.text.substring(index, match.start)));
      }

      final label = match.group(1)!;
      final url = match.group(2)!;
      final recognizer = TapGestureRecognizer()
        ..onTap = () => openExternalUrl(context, url);
      _recognizers.add(recognizer);

      spans.add(TextSpan(
        text: label,
        recognizer: recognizer,
        style: baseStyle?.copyWith(
          color: theme.colorScheme.primary,
          decoration: TextDecoration.underline,
          decorationColor: theme.colorScheme.primary.withValues(alpha: 0.5),
        ),
        // Without this a screen reader reads the label as ordinary prose and
        // never announces that it leads somewhere.
        semanticsLabel: '$label, link',
      ));

      index = match.end;
    }

    if (index < widget.text.length) {
      spans.add(TextSpan(text: widget.text.substring(index)));
    }

    return Text.rich(
      TextSpan(style: baseStyle, children: spans),
      maxLines: widget.maxLines,
      overflow:
          widget.maxLines == null ? TextOverflow.clip : TextOverflow.ellipsis,
    );
  }
}
