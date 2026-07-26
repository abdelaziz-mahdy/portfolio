import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Owns the app's theme mode and remembers the visitor's choice.
///
/// The previous control was a bare [Switch]. It had no label, and because it
/// only ever produced [ThemeMode.light] or [ThemeMode.dark], the first tap
/// permanently opted the visitor out of following their operating system —
/// a one-way door with no handle. The choice was also lost on reload.
class ThemeController extends ChangeNotifier {
  static const _storageKey = 'theme_mode';

  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;

  /// Restores the stored preference. Failing to read it is not worth
  /// surfacing — the app simply follows the system, which is the default.
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_storageKey);
      final restored = ThemeMode.values
          .where((mode) => mode.name == stored)
          .firstOrNull;
      if (restored != null && restored != _mode) {
        _mode = restored;
        notifyListeners();
      }
    } catch (_) {
      // Keep ThemeMode.system.
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    if (mode == _mode) return;
    _mode = mode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, mode.name);
    } catch (_) {
      // The theme still applies for this session.
    }
  }
}

/// Three-way theme control: System, Light, Dark.
class ThemeModeButton extends StatelessWidget {
  final ThemeController controller;

  const ThemeModeButton({super.key, required this.controller});

  static const _labels = {
    ThemeMode.system: 'System',
    ThemeMode.light: 'Light',
    ThemeMode.dark: 'Dark',
  };

  static const _icons = {
    ThemeMode.system: Icons.brightness_auto_outlined,
    ThemeMode.light: Icons.light_mode_outlined,
    ThemeMode.dark: Icons.dark_mode_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ThemeMode>(
      tooltip: 'Theme: ${_labels[controller.mode]}',
      icon: Icon(_icons[controller.mode]),
      initialValue: controller.mode,
      onSelected: controller.setMode,
      itemBuilder: (context) => ThemeMode.values
          .map((mode) => PopupMenuItem<ThemeMode>(
                value: mode,
                child: Row(
                  children: [
                    Icon(_icons[mode], size: 18),
                    const SizedBox(width: 12),
                    Text(_labels[mode]!),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
