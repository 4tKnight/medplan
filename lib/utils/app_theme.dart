import 'package:flutter/material.dart';
import 'package:medplan/utils/color.dart';
import 'package:medplan/utils/global.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    fontFamily: "Poppins",
    primarySwatch: MyColor.myColor,
    scaffoldBackgroundColor: const Color.fromRGBO(
      249,
      251,
      255,
      1,
    ), //Colors.white,
    primaryColor: primaryColor,
    brightness: Brightness.light,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primaryColor,
      selectionColor: Colors.grey,
      selectionHandleColor: primaryColor,
    ),
    colorScheme: ColorScheme.light(
      // primary: MyColor.myColor,
      primary: primaryColor,
      onPrimary: Colors.white,
      // primaryVariant: Colors.black,
      secondary:
          Colors
              .blue, //responsible for the color that shows when you scroll to the end of a scrollable page
      // brightness: Brightness.dark
    ),
    shadowColor: Colors.grey[200],
    cardColor:
        Colors
            .grey[50], //THIS IS WHAT IS RESPONSIBLE FOR THE TEXTFIELD TOOLBAROPTION COLOR

    // cardColor: Color.fromRGBO(233, 239, 245, 0.9),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor, // sets text and icon color
        side: BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        textStyle: TextStyle(color: primaryColor),
      ),
    ),
  );

  //*DARK MODE
  static final ThemeData darkTheme = ThemeData(
    primarySwatch: MyColor.myColor,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.black87,
    // brightness: Brightness.dark,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primaryColor,
      selectionColor: Colors.grey,
      selectionHandleColor: primaryColor,
    ),
    shadowColor: const Color.fromRGBO(52, 54, 59, 1),
    cardColor: const Color.fromRGBO(
      52,
      54,
      59,
      1,
    ), //THIS IS WHAT IS RESPONSIBLE FOR THE TEXTFIELD TOOLBAROPTION COLOR & //gradient for viewing post
    colorScheme: const ColorScheme.light(
      // primary: MyColor.myColor,
      primary: Colors.black,
      onPrimary: Colors.black,
      // primaryVariant: Colors.white,
      secondary: Colors.green, //cause of scroll end color
      brightness: Brightness.dark,
    ),

    buttonTheme: ButtonThemeData(
      buttonColor: primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(primaryColor),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        // backgroundColor: MaterialStateProperty.all(primaryColor),
        textStyle: MaterialStateProperty.all(TextStyle(color: primaryColor)),
        side: MaterialStateProperty.all(BorderSide(color: primaryColor)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
      ),
    ),
    fontFamily: "Poppins",
  );
}
