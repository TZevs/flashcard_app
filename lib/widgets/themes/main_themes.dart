import 'package:flutter/material.dart';

final ThemeData globalTheme = ThemeData(
  primaryColor: Color(0xFF2D4B48),
  listTileTheme: ListTileThemeData(
    tileColor: Color(0xFF5c8966),
    textColor: Color(0xFFEBE4C2),
    iconColor: Color(0xFFEBE4C2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    subtitleTextStyle: TextStyle(
      fontSize: 16,
    ),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStatePropertyAll(Color(0xFFEBE4C2)),
    trackColor: WidgetStatePropertyAll(Color(0xFF30253e)),
    trackOutlineColor: WidgetStatePropertyAll(Color(0xFF30253e)),
  ),
  appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF30253e),
      iconTheme: IconThemeData(color: Color(0xFFEBE4C2)),
      titleTextStyle: TextStyle(
          color: Color(0xFFEBE4C2), fontSize: 35, fontWeight: FontWeight.bold)),
  scaffoldBackgroundColor: Color(0xFF2D4B48),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF7BB497),
    foregroundColor: Color(0xFF30253e),
  ),
  cardTheme: CardTheme(
    color: Color(0xFF5c8966),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    clipBehavior: Clip.hardEdge,
    shadowColor: const Color(0xFFEBE4C2),
  ),
);

final TextTheme mainTextTheme = TextTheme(
  displayLarge: TextStyle(
    color: Color(0xFFEBE4C2),
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
  displayMedium: TextStyle(
    color: Color(0xFFEBE4C2),
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
  displaySmall: TextStyle(
    color: Color(0xFFEBE4C2),
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
);
