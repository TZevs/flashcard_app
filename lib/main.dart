import 'package:flashcard_app/viewmodels/deck_viewmodel.dart';
import 'package:flashcard_app/viewmodels/flashcard_viewmodel.dart';
import 'package:flashcard_app/viewmodels/new_deck_viewmodel.dart';
import 'package:flashcard_app/views/deck_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const MyFlashCardApp());
  // await FlashcardDb.deleteDatabaseFile();
}

class MyFlashCardApp extends StatelessWidget {
  const MyFlashCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NewDeckViewmodel()),
        ChangeNotifierProvider(create: (context) => FlashcardViewModel()),
        ChangeNotifierProvider(create: (context) => DeckViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DeckScreen(),
      ),
    );
  }
}
