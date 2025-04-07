import 'package:flashcard_app/viewmodels/flashcard_viewmodel.dart';
import 'package:flashcard_app/viewmodels/new_deck_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyFlashCardApp());
}

class MyFlashCardApp extends StatelessWidget {
  const MyFlashCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => NewDeckViewmodel()),
        Provider(create: (context) => FlashcardViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
