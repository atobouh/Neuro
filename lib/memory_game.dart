import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:neuro/colors.dart';

void main() => runApp(const MemoryGameApp());

class MemoryGameApp extends StatelessWidget {
  const MemoryGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Match Game',
      theme: ThemeData(
        fontFamily: 'OpenDyslexic',
        primaryColor: primaryTeal,
        scaffoldBackgroundColor: lightTealBg,
        appBarTheme: AppBarTheme(
          backgroundColor: primaryTeal,
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: warmYellow,
        ),
        cardColor: Colors.white,
        iconTheme: IconThemeData(color: cocoa),
      ),
      home: const MemoryGameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class CardModel {
  final String imageFileName;
  final String audioFileName;
  bool isFlipped;
  bool isMatched;

  CardModel({
    required this.imageFileName,
    required this.audioFileName,
    this.isFlipped = false,
    this.isMatched = false,
  });

  String get imagePath => 'assets/images/$imageFileName';
  String get audioPath => 'assets/audio/$audioFileName';
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late List<CardModel> _cards;
  CardModel? _firstFlippedCard;
  bool _canFlip = true;

  @override
  void initState() {
    super.initState();
    _initCards();
  }

  void _initCards() {
    final cardData = [
      {'image': 'sun.png', 'audio': 'sun.mp3'},
      {'image': 'star.png', 'audio': 'star.mp3'},
    ];
    _cards = [
      ...cardData,
      ...cardData,
    ].map((data) => CardModel(
      imageFileName: data['image']!,
      audioFileName: data['audio']!,
    )).toList();
    _cards.shuffle();
  }

  Future<void> _playAudio(String fileName) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(fileName));
  }

  void _onCardTapped(int index) async {
    if (!_canFlip || _cards[index].isFlipped || _cards[index].isMatched) return;

    setState(() {
      _cards[index].isFlipped = true;
    });

    await _playAudio(_cards[index].audioFileName);

    if (_firstFlippedCard == null) {
      _firstFlippedCard = _cards[index];
    } else {
      _canFlip = false;
      await Future.delayed(const Duration(seconds: 1));

      if (_firstFlippedCard!.imageFileName == _cards[index].imageFileName) {
        setState(() {
          _cards[index].isMatched = true;
          _firstFlippedCard!.isMatched = true;
        });
      } else {
        setState(() {
          _cards[index].isFlipped = false;
          _firstFlippedCard!.isFlipped = false;
        });
      }
      _firstFlippedCard = null;
      _canFlip = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Memory Match Game')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];
          return GestureDetector(
            onTap: () => _onCardTapped(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: card.isFlipped || card.isMatched
                    ? Colors.white
                    : skyBlue,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryTeal, width: 2),
              ),
              child: Center(
                child: card.isFlipped || card.isMatched
                    ? Image.asset(card.imagePath)
                    : Icon(Icons.help, color: cocoa),
              ),
            ),
          );
        },
      ),
    );
  }
}
