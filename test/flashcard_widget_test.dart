import 'dart:io';

import 'package:flashcard_app/viewmodels/flashcard_viewmodel.dart';
import 'package:flashcard_app/widgets/flashcard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockFlashcardViewModel extends Mock implements FlashcardViewModel {}

@GenerateMocks([FlashcardViewModel])
void main() {
  group("Testing the Flashcard Widget", () {
    testWidgets("With both content and image", (WidgetTester tester) async {
      final mockViewModel = MockFlashcardViewModel();
      final testingContent = "Hello Testing";
      final testingImg = File("imgs/testingImg.jpg").path;

      await tester.pumpWidget(MaterialApp(
        home: ChangeNotifierProvider<FlashcardViewModel>.value(
          value: mockViewModel,
          child: FlashcardWidget(content: testingContent, img: testingImg),
        ),
      ));

      expect(find.text(testingContent), findsOneWidget);
      expect(find.image(FileImage(File(testingImg))), findsOneWidget);
    });

    testWidgets("The speak() function", (WidgetTester tester) async {
      final mockViewModel = MockFlashcardViewModel();
      final testingContent = "Hello Testing";

      await tester.pumpWidget(MaterialApp(
        home: ChangeNotifierProvider<FlashcardViewModel>.value(
          value: mockViewModel,
          child: FlashcardWidget(content: testingContent),
        ),
      ));

      expect(find.text(testingContent), findsOneWidget);

      await tester.tap(find.byIcon(Icons.speaker));
      await tester.pump();
      verify(mockViewModel.speak(testingContent)).called(1);
    });

    testWidgets("Without an image", (WidgetTester tester) async {
      final mockViewModel = MockFlashcardViewModel();
      final testingContent = "Hello Testing";
      final testingImg = File("imgs/testingImg.jpg").path;

      await tester.pumpWidget(MaterialApp(
        home: ChangeNotifierProvider<FlashcardViewModel>.value(
          value: mockViewModel,
          child: FlashcardWidget(content: testingContent),
        ),
      ));

      expect(find.text(testingContent), findsOneWidget);
      expect(find.image(FileImage(File(testingImg))), findsNothing);
    });

    testWidgets("Without content or an image", (WidgetTester tester) async {
      final mockViewModel = MockFlashcardViewModel();
      final testingContent = "Hello Testing";
      final testingImg = File("imgs/testingImg.jpg").path;

      await tester.pumpWidget(MaterialApp(
        home: ChangeNotifierProvider<FlashcardViewModel>.value(
          value: mockViewModel,
          child: FlashcardWidget(
            content: "",
          ),
        ),
      ));

      expect(find.text(testingContent), findsNothing);
      expect(find.image(FileImage(File(testingImg))), findsNothing);
    });
  });
}
