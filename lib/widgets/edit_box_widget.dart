import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flashcard_app/viewmodels/edit_deck_viewmodel.dart';
import 'package:flashcard_app/viewmodels/new_deck_viewmodel.dart';
import 'package:flashcard_app/widgets/themes/main_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditDialog extends StatefulWidget {
  final int index;
  final FlashcardModel card;
  final NewDeckViewmodel? newVM;
  final EditDeckViewmodel? editVM;
  const EditDialog({super.key, required this.index, required this.card, this.newVM, this.editVM});

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  final TextEditingController _cardFrontController = TextEditingController();
  final TextEditingController _cardBackController = TextEditingController();

  @override
  void dispose() {
    _cardFrontController.dispose();
    _cardBackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel;
    if (widget.newVM != null) {
      viewModel = Provider.of<NewDeckViewmodel>(context, listen: false);
    }
    else {
      viewModel = Provider.of<EditDeckViewmodel>(context, listen: false);
    }

    _cardFrontController.text = widget.card.cardFront ?? '';
    _cardBackController.text = widget.card.cardBack ?? '';

    return AlertDialog(
      title: Text(
        "Edit Flashcard",
        style: mainTextTheme.displayMedium,
      ),
      icon: IconButton(
        color: Color(0xFFEBE4C2),
        alignment: Alignment.topRight,
        icon: Icon(Icons.close),
        onPressed: () {
          _cardFrontController.clear();
          _cardBackController.clear();
          Navigator.pop(context);
        }
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            style: TextStyle(color: Color(0xFFEBE4C2)),
            controller: _cardFrontController,
            decoration: InputDecoration(
              labelText: "Card Front",
            ),
          ),
          SizedBox(height: 10),
          Container(
            color: Color(0xFF5c8966),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  color: Color(0xFFEEA83B),
                  onPressed: () {
                    viewModel.captureImg(isFront: true);
                  },
                  icon: Icon(Icons.camera_alt)),
                IconButton(
                  color: Color(0xFFEEA83B),
                  onPressed: () {
                    viewModel.galleryImg(isFront: true);
                  },
                  icon: Icon(Icons.image)),
              ],
            ),
          ),
          SizedBox(height: 10),
          TextField(
            style: TextStyle(color: Color(0xFFEBE4C2)),
            controller: _cardBackController,
            decoration: InputDecoration(
              labelText: "Card Back",
            ),
          ),
          SizedBox(height: 10),
          Container(
            color: Color(0xFF5c8966),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  color: Color(0xFFEEA83B),
                  onPressed: () {
                    viewModel.captureImg(isFront: false);
                  },
                  icon: Icon(Icons.camera_alt)),
                IconButton(
                  color: Color(0xFFEEA83B),
                  onPressed: () {
                    viewModel.galleryImg(isFront: false);
                  },
                  icon: Icon(Icons.image)),
              ],
            ),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              viewModel.editFlashcard(
                widget.index,
                _cardFrontController.text,
                _cardBackController.text
              );

              _cardFrontController.clear();
              _cardBackController.clear();
              Navigator.pop(context);
            },
            child: Text("Save"))
        ],
      ),
    );
    
  }
}