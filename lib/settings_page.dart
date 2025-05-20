import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  String selectedLanguage = "English";
  String name = "";
  String age = "";
  File? profileImage;
  Uint8List? webImage;

  final List<String> languages = ["English", "French",];
  final picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() => webImage = bytes);
      } else {
        setState(() => profileImage = File(pickedFile.path));
      }
    }
  }

  void eraseData() {
    setState(() {
      name = "";
      age = "";
      musicEnabled = true;
      sfxEnabled = true;
      selectedLanguage = "English";
      profileImage = null;
      webImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF2A9C8A),
      ),
      body: Container(
        color: const Color(0xFFBFD7EA),
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: kIsWeb
                        ? (webImage != null
                        ? MemoryImage(webImage!)
                        : null)
                        : (profileImage != null
                        ? FileImage(profileImage!)
                        : null) as ImageProvider<Object>?,
                    backgroundColor: Colors.grey[300],
                    child: (profileImage == null && webImage == null)
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                  Positioned(
                    child: InkWell(
                      onTap: pickImage,
                      child: const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.camera_alt, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => name = val),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: "Age",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (val) => setState(() => age = val),
            ),
            const SizedBox(height: 16),
            _buildToggleTile("Music", musicEnabled, (val) {
              setState(() => musicEnabled = val);
            }),
            _buildToggleTile("SFX", sfxEnabled, (val) {
              setState(() => sfxEnabled = val);
            }),
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
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onPressed: eraseData,
                icon: const Icon(Icons.delete, size: 20),
                label: const Text("Erase Data", style: TextStyle(fontSize: 14)),
              ),
            ),
            const SizedBox(height: 20),
            const ListTile(
              title: Text("Credits"),
              subtitle: Text('App Developped By The NeuroPlay Team')
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