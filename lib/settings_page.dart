import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      title: 'Localized App',
      theme: ThemeData(
        fontFamily: 'OpenDyslexic',
      ),
      home: SettingsPage(
        locale: _locale,
        onLocaleChange: setLocale,
      ),
    );
  }
}

// Localization strings
const localizedStrings = {
  'en': {
    'settings': 'Settings',
    'name': 'Name',
    'age': 'Age',
    'music': 'Music',
    'sfx': 'SFX',
    'language': 'Language',
    'erase': 'Erase Data',
    'credits': 'App Developed By The NeuroPlay Team',
  },
  'fr': {
    'settings': 'Paramètres',
    'name': 'Nom',
    'age': 'Âge',
    'music': 'Musique',
    'sfx': 'Effets sonores',
    'language': 'Langue',
    'erase': 'Effacer les données',
    'credits': "Développé par l'équipe NeuroPlay",
  },
};

class SettingsPage extends StatefulWidget {
  final Locale locale;
  final Function(Locale) onLocaleChange;

  const SettingsPage({super.key, required this.locale, required this.onLocaleChange});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool musicEnabled = true;
  bool sfxEnabled = true;
  String name = "";
  String age = "";
  File? profileImage;
  Uint8List? webImage;
  final picker = ImagePicker();

  late String selectedLanguage;
  final List<String> languages = ['English', 'French'];

  @override
  void initState() {
    super.initState();
    selectedLanguage = widget.locale.languageCode == 'fr' ? 'French' : 'English';
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          webImage = bytes;
          profileImage = null;
        });
      } else {
        setState(() {
          profileImage = File(pickedFile.path);
          webImage = null;
        });
      }
    }
  }

  void eraseData() {
    setState(() {
      name = "";
      age = "";
      musicEnabled = true;
      sfxEnabled = true;
      profileImage = null;
      webImage = null;
      selectedLanguage = 'English';
      widget.onLocaleChange(const Locale('en'));
    });
  }

  String t(String key) {
    return localizedStrings[widget.locale.languageCode]?[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t('settings'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF2CB9B0),
      ),
      body: Container(
        color: const Color(0xFFE3FAF9),
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
                        ? (webImage != null ? MemoryImage(webImage!) : null)
                        : (profileImage != null ? FileImage(profileImage!) : null)
                    as ImageProvider<Object>?,
                    backgroundColor: Colors.grey[300],
                    child: (profileImage == null && webImage == null)
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                  InkWell(
                    onTap: pickImage,
                    onLongPress: () {
                      setState(() {
                        profileImage = null;
                        webImage = null;
                      });
                    },
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.camera_alt, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: t("name"),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2CB9B0)),
                ),
              ),
              onChanged: (val) => setState(() => name = val),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: t("age"),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2CB9B0)),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (val) => setState(() => age = val),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(t("music")),
              trailing: Switch(
                value: musicEnabled,
                onChanged: (val) => setState(() => musicEnabled = val),
                thumbColor: MaterialStateProperty.all(Colors.white),
                trackColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return const Color(0xFF2CB9B0);
                  }
                  return Colors.grey.shade400;
                }),
              ),
            ),
            ListTile(
              title: Text(t("sfx")),
              trailing: Switch(
                value: sfxEnabled,
                onChanged: (val) => setState(() => sfxEnabled = val),
                thumbColor: MaterialStateProperty.all(Colors.white),
                trackColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return const Color(0xFF2CB9B0);
                  }
                  return Colors.grey.shade400;
                }),
              ),
            ),
            ListTile(
              title: Text(t("language")),
              trailing: DropdownButton<String>(
                value: selectedLanguage,
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      selectedLanguage = value;
                      widget.onLocaleChange(Locale(value == 'French' ? 'fr' : 'en'));
                    });
                  }
                },
                items: languages.map((lang) {
                  return DropdownMenuItem<String>(
                    value: lang,
                    child: Text(lang),
                  );
                }).toList(),
              ),
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
                label: Text(t("erase"), style: const TextStyle(fontSize: 14)),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Center(
                child: Text(
                  t("credits"),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}