import 'package:flashcard_app/viewmodels/new_deck_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNewDeckViewModel extends Mock implements NewDeckViewmodel {}

void main() {
  group("New Deck ViewModel Tests", () {
    test("Setting the Deck Title", () {
      // Arrange
      final mockVM = MockNewDeckViewModel();
    });
  });
}
