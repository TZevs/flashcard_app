import 'package:flashcard_app/views/share_decks_screen.dart';
import 'package:flutter/material.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFF30253e),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              iconSize: 30,
              color: Color(0xFFEEA83B),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => ShareDecksScreen()));
              },
              icon: Icon(Icons.public)),
          IconButton(
            iconSize: 30,
            color: Color(0xFFEEA83B),
            onPressed: () {},
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
