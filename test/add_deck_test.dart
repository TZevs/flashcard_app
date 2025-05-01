import 'package:flashcard_app/viewmodels/new_deck_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNewDeckViewModel extends Mock implements NewDeckViewmodel {}

void main() {
  group("New Deck ViewModel Tests", () {
    test("Setting the Deck Title", () {
      // Arrange
      final vm = NewDeckViewmodel();
      const newTitle = 'Test Deck';

      // Act
      vm.setDeckTitle(newTitle);

      // Assert
      expect(vm.deckTitle, newTitle);
    });

    test("setIsPublic to true, updating the label", () {
      // Arrange
      final vm = NewDeckViewmodel();
      vm.publicOrPrivateLabel = "Make Public?";
      vm.isPublic = false;

      // Act
      vm.setIsPublic(true);

      // Assert
      expect(vm.isPublic, isTrue);
      expect(vm.publicOrPrivateLabel, "Make Private?");
    });

    test("setIsPublic to false, updating the label", () {
      // Arrange
      final vm = NewDeckViewmodel();
      vm.publicOrPrivateLabel = "Make Private?";
      vm.isPublic = true;

      // Act
      vm.setIsPublic(false);

      // Assert
      expect(vm.isPublic, isFalse);
      expect(vm.publicOrPrivateLabel, "Make Public?");
    });

    test('addTag dosent allow duplicates', () {
      // Arrange
      final vm = NewDeckViewmodel();
      const tag = 'Maths';

      // Act
      vm.addTag(tag);
      vm.addTag(tag);

      // Assert
      expect(vm.selectedTags.length, 1);
      expect(vm.selectedTags.contains(tag), isTrue);
    });

    test('removeTag removes tag', () {
      // Arrange
      final vm = NewDeckViewmodel();
      const tag = 'Maths';
      vm.addTag(tag);
      final beforeLen = vm.selectedTags.length;

      // Act
      vm.removeTag(tag);

      // Assert
      expect(vm.selectedTags.contains(tag), isFalse);
      expect(vm.selectedTags.length, beforeLen - 1);
    });

    test('clearTags removes all tags', () {
      // Arrange
      final vm = NewDeckViewmodel();
      vm.addTag('Math');
      vm.addTag('Science');

      // Act
      vm.clearTags();

      // Assert
      expect(vm.selectedTags, isEmpty);
    });

    test("addFlashcard adds card without images", () {
      // Arrange
      final vm = NewDeckViewmodel();
      const front = "front test";
      const back = "back test";

      // Act
      vm.addFlashcard(front, back);

      // Assert
      expect(vm.flashcards.length, 1);
      expect(vm.flashcards.first.cardFront, front);
      expect(vm.flashcards.first.cardBack, back);
      expect(vm.flashcards.first.frontImgPath, isNull);
      expect(vm.flashcards.first.backImgPath, isNull);
    });

    test("removeFlashcard removes card from list", () {
      // Arrange
      final vm = NewDeckViewmodel();
      vm.addFlashcard("front test", "back test");

      // Act
      vm.removeFlashcard(0);

      // Assert
      expect(vm.flashcards, isEmpty);
    });

    test('editFlashcard updates the front and back text', () {
      // Arrange
      final vm = NewDeckViewmodel();
      vm.addFlashcard('old front', 'old back');

      // Act
      vm.editFlashcard(0, 'new front', 'new back');
      final result = vm.flashcards[0];

      // Assert
      expect(result.cardFront, 'new front');
      expect(result.cardBack, 'new back');
      expect(vm.flashcards.first.frontImgPath, isNull);
      expect(vm.flashcards.first.backImgPath, isNull);
      expect(vm.flashcards.length, 1);
    });
  });
}
