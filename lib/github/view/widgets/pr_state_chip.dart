import 'package:flutter/material.dart';
import 'package:portfolio/theme/portfolio_palette.dart';

/// The order state chips are always rendered in.
///
/// Previously the order came from `Map` insertion, which followed whatever
/// order the API returned pull requests in — so `foam3` read merged/open/closed
/// while `fvp` read open/closed/merged. Scanning a column of cards depends on
/// the same value sitting in the same place every time.
const _stateOrder = ['merged', 'open', 'closed'];

/// Sorts a `state -> count` map into a stable, meaningful order: the three
/// known states first, then anything unrecognised alphabetically.
List<MapEntry<String, int>> orderedStates(Map<String, int> states) {
  final entries = states.entries.toList();
  entries.sort((a, b) {
    final ai = _stateOrder.indexOf(a.key);
    final bi = _stateOrder.indexOf(b.key);
    if (ai != -1 && bi != -1) return ai.compareTo(bi);
    if (ai != -1) return -1;
    if (bi != -1) return 1;
    return a.key.compareTo(b.key);
  });
  return entries;
}

IconData _glyphFor(String state) {
  switch (state) {
    case 'merged':
      return Icons.call_merge;
    case 'open':
      return Icons.radio_button_unchecked;
    case 'closed':
      return Icons.close;
    default:
      return Icons.help_outline;
  }
}

/// A pull request state as a count, a word, and a glyph.
///
/// Three channels rather than one: the rule is that colour must never be the
/// only carrier of meaning, which rules out the bare coloured dot this
/// replaces.
class PrStateChip extends StatelessWidget {
  final String state;
  final int count;

  const PrStateChip({super.key, required this.state, required this.count});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isKnown = palette.isKnownState(state);
    final color = palette.forState(state);

    // Unknown states get an outline rather than a fill: the old grey.shade300
    // fill put white text at 1.32:1.
    final foreground = isKnown ? palette.onStateChip : color;

    return Semantics(
      label: '$count $state pull requests',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isKnown ? color : Colors.transparent,
          border: isKnown ? null : Border.all(color: color),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_glyphFor(state), size: 13, color: foreground),
            const SizedBox(width: 5),
            Text(
              '$count $state',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A wrapped row of state chips in the canonical order.
class PrStateChips extends StatelessWidget {
  final Map<String, int> states;

  const PrStateChips({super.key, required this.states});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: orderedStates(states)
          .map((entry) => PrStateChip(state: entry.key, count: entry.value))
          .toList(),
    );
  }
}
