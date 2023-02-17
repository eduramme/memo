import 'package:flutter/material.dart';
import 'package:memo/discipline.dart';
import 'package:memo/flashcard.dart';

class Congrats extends StatefulWidget {
  final String discipline, deck;
  const Congrats({super.key, required this.discipline, required this.deck});

  @override
  State<Congrats> createState() => _CongratsState();
}

class _CongratsState extends State<Congrats> {
  void _goHome() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Discipline(),
      ),
    );
  }

  void _practiceMore() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Flashcard(discipline: widget.discipline, deck: widget.deck),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("title"),
        ),
        body: Center(
            child: Column(children: [
          Text("Congrats!! - Você raticou a disciplina ${widget.discipline} e o deck ${widget.deck}"),
          const Text("Ainda faltam 21093 cards a serem estudados nesse Deck"),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () => _goHome(),
            child: const Text('Home'),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () => _practiceMore(),
            child: const Text('Practice'),
          )
        ])));
  }
}
