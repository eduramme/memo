import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memo/deck.dart';

class Discipline extends StatefulWidget {
  const Discipline({super.key});

  @override
  State<Discipline> createState() => _DisciplineState();
}

class _DisciplineState extends State<Discipline> {
  final items = ['Matemática', 'Química', 'Física', 'Biologia'];
  final decks = ['algebra', 'nuclear', 'fisica', 'photoshiop'];

  void _pushSaved(discipline) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Deck(discipline: discipline),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Disciplinas';

    return Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('subjects').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text("Loading...");
              }
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(snapshot.data!.docs[index].id),
                        onTap: () => _pushSaved(snapshot.data!.docs[index].id),
                      ),
                      const Divider()
                    ],
                  );
                },
              );
            }));
  }
}
