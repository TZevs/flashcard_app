import 'package:flashcard_app/viewmodels/edit_deck_viewmodel.dart';
import 'package:flashcard_app/viewmodels/new_deck_viewmodel.dart';
import 'package:flashcard_app/widgets/themes/main_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TagsWidget extends StatefulWidget {
  final NewDeckViewmodel? newVM;
  final EditDeckViewmodel? editVM;
  const TagsWidget({super.key, this.newVM, this.editVM});

  @override
  State<TagsWidget> createState() => _TagsWidgetState();
}

class _TagsWidgetState extends State<TagsWidget> {
  @override
  Widget build(BuildContext context) {
    final isNew = widget.newVM != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Select Tags:", style: mainTextTheme.displayMedium),
        SizedBox(height: 2),
        isNew
            ? Consumer<NewDeckViewmodel>(
                builder: (context, viewModel, child) =>
                    _buildTagsContent(viewModel))
            : Consumer<EditDeckViewmodel>(
                builder: (context, viewModel, child) =>
                    _buildTagsContent(viewModel)),
      ],
    );
  }

  Widget _buildTagsContent(dynamic viewModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 8,
          children: viewModel.topics.map((tag) {
            return ChoiceChip(
                label: Text(tag),
                selected: viewModel.selectedTags.contains(tag),
                selectedColor: Color(0xFFEEA83B),
                disabledColor: Color(0xFFEBE4C2),
                onSelected: (isSelected) {
                  if (isSelected) {
                    viewModel.addTag(tag);
                  } else {
                    viewModel.removeTag(tag);
                  }
                });
          }).toList(),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  viewModel.clearTags();
                },
                child: Text("Clear")),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Done")),
          ],
        ),
      ],
    );
  }
}
