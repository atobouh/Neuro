import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(WordBuilderApp());
}

class WordBuilderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Builder Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WordBuilderGame(),
    );
  }
}

class WordBuilderGame extends StatefulWidget {
  @override
  _WordBuilderGameState createState() => _WordBuilderGameState();
}

class _WordBuilderGameState extends State<WordBuilderGame> {
  final List<String> words = ['CAT', 'DOG', 'BAT', 'FISH', 'GOD', 'AND'];
  late String targetWord;
  late List<String> shuffledLetters;
  String userInput = '';
  List<Color> selectedColors = [
    Colors.lightBlueAccent,
    Colors.red,
    Colors.green,
    Colors.orangeAccent
  ];
  List<Color> letterColors = [];
  List<bool> selectedLetters = [];

  @override
  void initState() {
    super.initState();
    _generateNewWord();
  }

  void _generateNewWord() {
    targetWord = (words..shuffle()).first;
    shuffledLetters = targetWord.split('')..shuffle();
    userInput = '';
    selectedLetters = List<bool>.filled(shuffledLetters.length, false);
    letterColors = List<Color>.filled(shuffledLetters.length, Colors.white);
  }

  void _checkWord() {
    if (userInput.toUpperCase() == targetWord) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Correct! The word is: $targetWord')),
      );
      _generateNewWord();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Try again!')),
      );
    }
  }

  void _addLetter(String letter, int index) {
    setState(() {
      userInput += letter;
      selectedLetters[index] = true;
      letterColors[index] = selectedColors[Random().nextInt(selectedColors.length)];
    });
  }

  void _removeLetter() {
    setState(() {
      if (userInput.isNotEmpty) {
        userInput = userInput.substring(0, userInput.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Builder Game', style: TextStyle(fontFamily: 'OpenDyslexic')),
      ),
      body: Container(
        color: const Color  (0xFFC7E8CA),// Background color
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              // Cartoon Image

              SizedBox(height: 20),
              Text(
                'Your Word: $userInput',
                style: TextStyle(fontSize: 27, fontFamily: 'OpenDyslexic'),
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 10,
                children: List.generate(shuffledLetters.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      _addLetter(shuffledLetters[index], index);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: letterColors[index],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Text(
                        shuffledLetters[index],
                        style: TextStyle(fontSize: 20, fontFamily: 'OpenDyslexic'),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _checkWord,
                child: Text('Check Word'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _removeLetter,
                child: Text('Remove Last Letter'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _generateNewWord,
                child: Text('Skip Word'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}