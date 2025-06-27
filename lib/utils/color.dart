import 'package:flutter/material.dart';

class MyColor {
  static const MaterialColor myColor = const MaterialColor(
    0xff007cee, // Base color in hexadecimal
    const <int, Color>{
      50: const Color.fromRGBO(0, 124, 238, 0.1), // 10%
      100: const Color.fromRGBO(0, 124, 238, 0.2), // 20%
      200: const Color.fromRGBO(0, 124, 238, 0.3), // 30%
      300: const Color.fromRGBO(0, 124, 238, 0.4), // 40%
      400: const Color.fromRGBO(0, 124, 238, 0.5), // 50%
      500: const Color.fromRGBO(0, 124, 238, 0.6), // 60%
      600: const Color.fromRGBO(0, 124, 238, 0.7), // 70%
      700: const Color.fromRGBO(0, 124, 238, 0.8), // 80%
      800: const Color.fromRGBO(0, 124, 238, 0.9), // 90%
      900: const Color.fromRGBO(0, 124, 238, 1.0), // 100%
    },
  );
}

