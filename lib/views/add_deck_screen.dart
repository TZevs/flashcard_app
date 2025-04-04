import 'package:flutter/material.dart';

class AddDeckScreen extends StatefulWidget {
  const AddDeckScreen({super.key});

  @override
  State<AddDeckScreen> createState() => _AddDeckScreen();
}

class _AddDeckScreen extends State<AddDeckScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _cardFrontController = TextEditingController();
  final TextEditingController _cardBackController = TextEditingController();
  bool _isPublic = false;
  List<Map<String, dynamic>> _tempFlashcards = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("New Deck"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Deck Title',
              ),
            ),
            SwitchListTile(
              title: Text("Make Public?"),
              value: _isPublic, 
              onChanged: (bool value) => setState(() {
                _isPublic = value;
              }),
            ),
          ],
        ),
      )
    );
  }
}