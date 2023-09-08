import 'package:flutter/material.dart';

class Constants {
  static const Color primaryColor = Color(0xFF7D23E0);
  static const Color textPlaceholderColor = Color(0xff787878);

  static const String defaultFont = "AvenirNextLTPro";

  static const double baseWidth = 390;
  static const double baseWidthLandscape = 784;

  static const String iconSearch = "assets/images/search.svg";
  static const String iconLine = "assets/images/line.svg";
  static const String iconMicrophone = "assets/images/microphone.svg";
  static const String iconLocationPin = "assets/images/location_pin.png";
  static const String iconGreenStar = "assets/images/green_star.png";
  static const String iconAskOstello = "assets/images/ask_ostello.png";

  static const String placeholderImage = "https://via.placeholder.com/%dx%d";

  static bool isScreenPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static double fem(BuildContext context) {
    return MediaQuery.of(context).size.width /
        (isScreenPortrait(context) ? baseWidth : baseWidthLandscape);
  }

  static double ffem(BuildContext context) {
    return fem(context) * 0.97;
  }
}
