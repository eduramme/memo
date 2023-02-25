import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memo/flashcard.dart';

class Deck extends StatefulWidget {
  final String discipline;
  const Deck({super.key, required this.discipline});

  @override
  State<Deck> createState() => _DeckState();
}

class _DeckState extends State<Deck> {
  final decks = ['algebra', 'nuclear', 'fisica', 'photoshiop'];

  void _memo(deck) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Flashcard(discipline: widget.discipline, deck: deck),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tiles = decks.map(
      (deck) {
        return ListTile(
          onTap: () => _memo(deck),
          title: Text(
            deck,
            style: const TextStyle(fontSize: 18),
          ),
        );
      },
    );

    final divided = tiles.isNotEmpty
        ? ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList()
        : <Widget>[];

    return Scaffold(
        appBar: AppBar(
          title: Text('Decks - ${widget.discipline}'),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('subjects').doc(widget.discipline).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text("Loading...");
              }
              final collentionList = snapshot.data!.get('collectionsList');
              return ListView.builder(
                itemCount: collentionList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(collentionList[index]),
                        onTap: () => _memo(collentionList[index]),
                      ),
                      const Divider()
                    ],
                  );
                },
              );
            }));
  }
}
