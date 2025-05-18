import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class NewEditViewmodel extends ChangeNotifier {
  String newDeckId = uuid.v4();
  
  List<String> topicTags = [
    "Maths",
    "History",
    "Literature",
    "Psychology",
    "Sociology",
    "Biology",
    "Chemistry",
    "Physics",
    "Geography",
    "Health and Medicine",
    "Architecture",
    "Education",
    "Law",
    "Linguistics",
    "Languages",
    "Other",
  ];
  List<String> _selectedTags = [];
  List<String> get selectedTags => _selectedTags;

  List<FlashcardModel> _flashcards = [];
  List<FlashcardModel> get flashcards => _flashcards;
}