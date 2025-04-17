import 'package:firebase_core/firebase_core.dart';
import 'package:flashcard_app/viewmodels/auth_viewmodel.dart';
import 'package:flashcard_app/viewmodels/deck_viewmodel.dart';
import 'package:flashcard_app/viewmodels/edit_deck_viewmodel.dart';
import 'package:flashcard_app/viewmodels/flashcard_viewmodel.dart';
import 'package:flashcard_app/viewmodels/new_deck_viewmodel.dart';
import 'package:flashcard_app/views/deck_screen.dart';
import 'package:flashcard_app/views/landing_screen.dart';
import 'package:flashcard_app/widgets/themes/main_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flashcard_app/services/flashcard_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyFlashCardApp());
  // await FlashcardDb.deleteDatabaseFile();
}

class MyFlashCardApp extends StatelessWidget {
  const MyFlashCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => NewDeckViewmodel()),
        ChangeNotifierProvider(create: (context) => FlashcardViewModel()),
        ChangeNotifierProvider(create: (context) => DeckViewModel()),
        ChangeNotifierProvider(create: (context) => EditDeckViewmodel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LandingScreen(),
        theme: globalTheme,
      ),
    );
  }
}
