import 'package:flutter/material.dart';

final ThemeData globalTheme = ThemeData(
  textTheme: mainTextTheme,
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
  ),
  appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF30253e),
      iconTheme: IconThemeData(color: Color(0xFFEBE4C2), weight: 20),
      titleTextStyle: TextStyle(
          color: Color(0xFFEBE4C2), fontSize: 35, fontWeight: FontWeight.bold)),
  scaffoldBackgroundColor: Color(0xFF2D4B48),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFEEA83B),
      foregroundColor: Color(0xFF30253e),
      iconSize: 40),
  cardTheme: CardTheme(
    color: Color(0xFF5c8966),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    clipBehavior: Clip.hardEdge,
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Color(0xFFEEA83B),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Color(0xFFEEA83B)),
    ),
    floatingLabelStyle:
        TextStyle(color: Color(0xFFEEA83B), fontWeight: FontWeight.bold),
    labelStyle: TextStyle(
      color: Color(0xFFEEA83B),
    ),
    outlineBorder: BorderSide(
      color: Color(0xFFEEA83B),
    ),
    activeIndicatorBorder: BorderSide(
      color: Color(0xFFEEA83B),
    ),
    focusColor: Color(0xFFEEA83B),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: Color(0xFF30253e),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(Color(0xFFEEA83B)),
    foregroundColor: WidgetStatePropertyAll(Color(0xFF30253e)),
    textStyle: WidgetStatePropertyAll(TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
    )),
  )),
);

final TextTheme mainTextTheme = TextTheme(
  displayLarge: TextStyle(
    color: Color(0xFFEBE4C2),
    fontSize: 30,
    fontWeight: FontWeight.bold,
  ),
  displayMedium: TextStyle(
    color: Color(0xFFEBE4C2),
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
  displaySmall: TextStyle(
      color: Color(0xFFEBE4C2), fontSize: 18, fontWeight: FontWeight.normal),
);

final BoxDecoration addImgContainer = BoxDecoration(
  color: Color(0xFF30253e),
  borderRadius: BorderRadius.circular(10),
);

final DialogTheme tagDialog = DialogTheme(
  backgroundColor: Color(0xFF30253e),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
);
