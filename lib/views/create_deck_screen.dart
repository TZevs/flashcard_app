import 'package:flashcard_app/viewmodels/new_deck_viewmodel.dart';
import 'package:flashcard_app/widgets/appbar_widget.dart';
import 'package:flashcard_app/widgets/edit_box_widget.dart';
import 'package:flashcard_app/widgets/preview_box_widget.dart';
import 'package:flashcard_app/widgets/themes/main_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateDeckScreen extends StatefulWidget {
  const CreateDeckScreen({super.key});

  @override
  State<CreateDeckScreen> createState() => _CreateDeckScreenState();
}

class _CreateDeckScreenState extends State<CreateDeckScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _cardFrontController = TextEditingController();
  final TextEditingController _cardBackController = TextEditingController();

  void _addTags(BuildContext context, NewDeckViewmodel viewModel) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Select Tags",
                  style: mainTextTheme.displayMedium,
                  textAlign: TextAlign.center),
              content: Consumer<NewDeckViewmodel>(
                  builder: (context, viewModel, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                          },
                        );
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
              }),
            ));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _cardFrontController.dispose();
    _cardBackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NewDeckViewmodel>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        appBar: AppbarWidget(title: "New Deck"),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        style: TextStyle(color: Color(0xFFEBE4C2)),
                        controller: _titleController,
                        decoration: InputDecoration(labelText: "Deck Title"),
                      ),
                      SizedBox(height: 10),
                      SwitchListTile(
                          tileColor: Color(0xFFEEA83B),
                          activeColor: Color(0xFFEEA83B),
                          inactiveTrackColor: Color(0xFFEEA83B),
                          inactiveThumbColor: Color(0xFF30253e),
                          trackOutlineColor:
                              WidgetStatePropertyAll(Color(0xFF30253e)),
                          title: Text(viewModel.publicOrPrivateLabel,
                              style: TextStyle(color: Color(0xFF30253e))),
                          value: viewModel.isPublic,
                          onChanged: (bool value) async {
                            viewModel.setIsPublic(value);
                            if (viewModel.isPublic) {
                              _addTags(context, viewModel);
                            }
                          }),
                      SizedBox(height: 10),
                      TextField(
                        style: TextStyle(color: Color(0xFFEBE4C2)),
                        controller: _cardFrontController,
                        decoration: InputDecoration(labelText: "Card Front"),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: addImgContainer,
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
                            if (viewModel.frontImg != null)
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      viewModel.frontImg!,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      viewModel.clearFrontImg();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.close,
                                          size: 16, color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        style: TextStyle(color: Color(0xFFEBE4C2)),
                        controller: _cardBackController,
                        decoration: InputDecoration(labelText: "Card Back"),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: addImgContainer,
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
                            if (viewModel.backImg != null)
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      viewModel.backImg!,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      viewModel.clearBackImg();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.close,
                                          size: 16, color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: () {
                            viewModel.addFlashcard(_cardFrontController.text,
                                _cardBackController.text);

                            _cardFrontController.clear();
                            _cardBackController.clear();
                          },
                          child: Text("Add Flashcard"),
                        ),
                      ),
                      Consumer<NewDeckViewmodel>(
                          builder: (context, viewModel, child) {
                        return Column(
                          children: viewModel.flashcards.map((item) {
                            int index = viewModel.flashcards.indexOf(item);
                            return Padding(
                              padding: const EdgeInsets.all(7.5),
                              child: ListTile(
                                subtitleTextStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                onTap: () => showDialog(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          content: PreviewBoxWidget(card: item),
                                        )),
                                leading: Icon(item.frontImgPath != null ||
                                        item.backImgPath != null
                                    ? Icons.image_outlined
                                    : Icons.hide_image_outlined),
                                title: Text(item.cardFront ?? ''),
                                subtitle: Text(item.cardBack ?? ''),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () => showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (_) => EditDialog(
                                                index: index,
                                                card: item,
                                                newVM: viewModel))),
                                    IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () =>
                                            viewModel.removeFlashcard(index)),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                      SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: ElevatedButton(
                onPressed: () async {
                  await viewModel.addNewDeck(_titleController.text);
                  viewModel.reset();
                  Navigator.pop(context);
                },
                child: Text("Save Deck"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
