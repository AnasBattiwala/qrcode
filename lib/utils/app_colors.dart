import 'package:flutter/material.dart';

class AppColors {
  static const Map<int, Color> _primaryColors = {
    50: Color.fromRGBO(255, 204, 104, .1),
    100: Color.fromRGBO(255, 204, 104, .2),
    200: Color.fromRGBO(255, 204, 104, .3),
    300: Color.fromRGBO(255, 204, 104, .4),
    400: Color.fromRGBO(255, 204, 104, .5),
    500: Color.fromRGBO(255, 204, 104, .6),
    600: Color.fromRGBO(255, 204, 104, .7),
    700: Color.fromRGBO(255, 204, 104, .8),
    800: Color.fromRGBO(255, 204, 104, .9),
    900: Color.fromRGBO(255, 204, 104, 1),
  };
  static const primaryColor = MaterialColor(0xFFFFCC68, _primaryColors);
}
