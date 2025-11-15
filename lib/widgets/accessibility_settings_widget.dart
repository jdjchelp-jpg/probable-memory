import 'package:flutter/material.dart';
import 'package:wonderlapse/services/accessibility_service.dart';

class AccessibilitySettingsWidget extends StatefulWidget {
  final AccessibilitySettings settings;
  final Function(AccessibilitySettings) onSettingsChanged;

  const AccessibilitySettingsWidget({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
  });

  @override
  State<AccessibilitySettingsWidget> createState() =>
      _AccessibilitySettingsWidgetState();
}

class _AccessibilitySettingsWidgetState
    extends State<AccessibilitySettingsWidget> {
  late AccessibilitySettings _currentSettings;

  @override
  void initState() {
    super.initState();
    _currentSettings = widget.settings;
  }

  void _updateSetting(AccessibilitySettings newSettings) {
    setState(() => _currentSettings = newSettings);
    widget.onSettingsChanged(newSettings);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Accessibility Settings',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            _buildSwitchTile(
              'Reduced Motion',
              'Minimize animations and transitions',
              _currentSettings.reducedMotion,
              (value) => _updateSetting(
                _currentSettings.copyWith(reducedMotion: value),
              ),
            ),
            _buildSwitchTile(
              'High Contrast',
              'Increase contrast for better visibility',
              _currentSettings.highContrast,
              (value) => _updateSetting(
                _currentSettings.copyWith(highContrast: value),
              ),
            ),
            _buildSwitchTile(
              'Dyslexia Font',
              'Use OpenDyslexic font for easier reading',
              _currentSettings.dyslexiaFont,
              (value) => _updateSetting(
                _currentSettings.copyWith(dyslexiaFont: value),
              ),
            ),
            _buildSwitchTile(
              'Magnifier Mode',
              'Enlarge countdown numbers',
              _currentSettings.magnifierMode,
              (value) => _updateSetting(
                _currentSettings.copyWith(magnifierMode: value),
              ),
            ),
            _buildSwitchTile(
              'Shapes Only Mode',
              'Use shapes instead of colors',
              _currentSettings.shapesOnly,
              (value) => _updateSetting(
                _currentSettings.copyWith(shapesOnly: value),
              ),
            ),
            _buildSwitchTile(
              'Text-to-Speech',
              'Enable audio reading of content',
              _currentSettings.textToSpeechEnabled,
              (value) => _updateSetting(
                _currentSettings.copyWith(textToSpeechEnabled: value),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Text Size',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Slider(
              value: _currentSettings.textScaleFactor,
              min: 0.8,
              max: 2.0,
              divisions: 12,
              label: '${(_currentSettings.textScaleFactor * 100).toInt()}%',
              onChanged: (value) => _updateSetting(
                _currentSettings.copyWith(textScaleFactor: value),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Letter Spacing',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Slider(
              value: _currentSettings.letterSpacing,
              min: 0.0,
              max: 5.0,
              divisions: 10,
              label: '${_currentSettings.letterSpacing.toStringAsFixed(1)}',
              onChanged: (value) => _updateSetting(
                _currentSettings.copyWith(letterSpacing: value),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Line Height',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Slider(
              value: _currentSettings.lineHeight,
              min: 1.0,
              max: 3.0,
              divisions: 10,
              label: '${_currentSettings.lineHeight.toStringAsFixed(1)}',
              onChanged: (value) => _updateSetting(
                _currentSettings.copyWith(lineHeight: value),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Speech Settings',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text('Speech Speed'),
            Slider(
              value: _currentSettings.speechSpeed,
              min: 0.5,
              max: 2.0,
              divisions: 15,
              label: '${(_currentSettings.speechSpeed * 100).toInt()}%',
              onChanged: (value) => _updateSetting(
                _currentSettings.copyWith(speechSpeed: value),
              ),
            ),
            const SizedBox(height: 12),
            Text('Speech Pitch'),
            Slider(
              value: _currentSettings.speechPitch,
              min: 0.5,
              max: 2.0,
              divisions: 15,
              label: '${(_currentSettings.speechPitch * 100).toInt()}%',
              onChanged: (value) => _updateSetting(
                _currentSettings.copyWith(speechPitch: value),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
