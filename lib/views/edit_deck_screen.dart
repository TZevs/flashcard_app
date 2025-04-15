import 'package:flashcard_app/viewmodels/edit_deck_viewmodel.dart';
import 'package:flashcard_app/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditDeckScreen extends StatefulWidget {
  const EditDeckScreen({super.key});

  @override
  State<EditDeckScreen> createState() => _EditDeckScreenState();
}

class _EditDeckScreenState extends State<EditDeckScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _cardFrontController = TextEditingController();
  final TextEditingController _cardBackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<EditDeckViewmodel>(builder: (context, viewModel, child) {
      return SafeArea(
          child: Scaffold(
        appBar: AppbarWidget(
          title: "Edit Deck",
        ),
      ));
    });
  }
}
