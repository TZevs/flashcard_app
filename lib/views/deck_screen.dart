import 'package:flutter/material.dart';

class DeckScreen extends StatelessWidget {
  const DeckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Decks"),
        ),
        body: Column(
          
        ),
      )
    );
  }
}