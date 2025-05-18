import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flashcard_app/widgets/themes/main_themes.dart';
import 'package:flutter/material.dart';

class EditDialog extends StatefulWidget {
  final int index;
  final FlashcardModel card;
  final dynamic vm;
  const EditDialog({super.key, required this.index, required this.card, required this.vm});

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Flashcard", style: mainTextTheme.displayMedium),
    );
  }
}