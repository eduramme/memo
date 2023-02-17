import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memo/congrats.dart';

class Flashcard extends StatefulWidget {
  final String discipline, deck;
  const Flashcard({super.key, required this.discipline, required this.deck});

  @override
  State<Flashcard> createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  var _flashcards = [];
  bool _showAnswer = false;
  int _cardIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() async {
    final response = await FirebaseFirestore.instance.collection('subjects').doc(widget.discipline).collection(widget.deck).limit(5).get();
    if (response.docs.isNotEmpty) {
      setState(() {
        _flashcards = response.docs;
      });
    } else {
      throw Exception("Failed to load data");
    }
  }

  void _toggleAnswer() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  void _nextCard(grade) {
    final card = _flashcards[_cardIndex];
    if (_cardIndex < 4) {
      _sm2(grade, _flashcards[_cardIndex]['repetitionNumber'], _flashcards[_cardIndex]['EF'], _flashcards[_cardIndex]['interval']);
      setState(() {
        _cardIndex += 1;
        _showAnswer = false;
      });
    } else {
      setState(() {
        _cardIndex = 0;
        _showAnswer = false;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Congrats(discipline: widget.discipline, deck: widget.deck),
          ),
        );
      });
    }
  }

  void _sm2(grade, repetitionNumber, easinessFactor, interval) {
    final firestoreCollection = FirebaseFirestore.instance.collection('subjects').doc(widget.discipline).collection(widget.deck);
    if (grade >= 3) {
      if (repetitionNumber == 0) {
        interval = 1;
      } else if (repetitionNumber == 1) {
        interval = 6;
      } else {
        interval = interval * easinessFactor;
      }
      repetitionNumber++;
    } else {
      repetitionNumber = 0;
      interval = 1;
    }

    easinessFactor = easinessFactor + (0.1 - (5 - grade) * (0.08 + (5 - grade) * 0.02));
    if (easinessFactor < 1.3) {
      easinessFactor = 1.3;
    }

    final currentDate = DateTime.now();
    var reviewDate = currentDate.add(Duration(days: interval.ceil()));
    reviewDate = DateTime(reviewDate.year, reviewDate.month, reviewDate.day, 0, reviewDate.minute, reviewDate.second);

    firestoreCollection
        .doc(_flashcards[_cardIndex].id)
        .update({
          'repetitionNumber': repetitionNumber,
          'EF': easinessFactor,
          'interval': interval,
          'currentGrade': grade,
          'lastReviewDate': currentDate,
          'reviewDate': reviewDate,
          'shouldReview': false,
        })
        .then((value) => {print("Card updated!")})
        .catchError((error) => {print(error)});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: (_flashcards.isNotEmpty)
            ? Scaffold(
                appBar: AppBar(
                  title: Text('Memo - ${widget.discipline} / ${widget.deck}'),
                ),
                body: GestureDetector(
                  onTap: _toggleAnswer,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _showAnswer ? Colors.lightGreen[700] : Colors.grey[600],
                    ),
                    child: Center(
                      child: Text(
                        _showAnswer ? _flashcards[_cardIndex]['Answer'] : _flashcards[_cardIndex]['Question'],
                        style: const TextStyle(fontSize: 32.0, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.sentiment_very_dissatisfied),
                      label: 'forgot',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.sentiment_dissatisfied),
                      label: 'hard',
                    ),
                    BottomNavigationBarItem(icon: Icon(Icons.sentiment_dissatisfied), label: 'medium'),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.sentiment_satisfied),
                      label: 'easy',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.sentiment_very_satisfied),
                      label: 'too easy',
                    ),
                  ],
                  onTap: (int grade) {
                    _nextCard(grade);
                  },
                ))
            : const Text("Loading..."));
  }
}
