import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: SettingsPage()));
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool musicEnabled = true;
  bool sfxEnabled = true;
  double touchSensitivity = 0.5;
  String screenShake = "Normal";
  String selectedLanguage = "English";

  final List<String> screenShakeOptions = ["Off", "Normal", "High"];
  final List<String> languages = ["English", "French",];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',
        style: TextStyle(color: Colors.white,
        fontWeight: FontWeight.bold ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[800],
      ),
      body: Container(
        color: Colors.green[100],
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildToggleTile("Music", musicEnabled, (val) {
              setState(() => musicEnabled = val);
            }),
            _buildToggleTile("SFX", sfxEnabled, (val) {
              setState(() => sfxEnabled = val);
            }),
            _buildDropdownTile(
              title: "Screenshake",
              options: screenShakeOptions,
              selected: screenShake,
              onChanged: (val) {
                if (val != null) {
                  setState(() => screenShake = val);
                }
              },
            ),
            ListTile(
              title: const Text("Touch Sensitivity"),
              subtitle: Slider(
                value: touchSensitivity,
                min: 0,
                max: 1,
                onChanged: (val) {
                  setState(() => touchSensitivity = val);
                },
              ),
            ),
            ListTile(
              title: const Text("Save Data"),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  // Implement erase logic
                },
                child: const Text("ERASE"),
              ),
            ),
            _buildDropdownTile(
              title: "Language",
              options: languages,
              selected: selectedLanguage,
              onChanged: (val) {
                if (val != null) {
                  setState(() => selectedLanguage = val);
                }
              },
            ),
            const ListTile(
              title: Text("Credits"),
              subtitle: Text("App developed by Neuroplay Team."),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleTile(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required List<String> options,
    required String selected,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      trailing: DropdownButton<String>(
        value: selected,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}