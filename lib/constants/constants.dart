import 'package:flutter/material.dart';

class Constants {
  // Define primary and placeholder text colors for the application theme.
  static const Color primaryColor = Color(0xFF7D23E0);
  static const Color textPlaceholderColor = Color(0xff787878);

  // Default font used throughout the application.
  static const String defaultFont = "AvenirNextLTPro";

  // Reference screen widths for portrait and landscape orientations.
  // These are used for scaling UI elements to match different screen sizes.
  static const double baseWidth = 390;
  static const double baseWidthLandscape = 784;

  // Path to various icons and SVG images used in the application.
  static const String iconSearch = "assets/images/search.svg";
  static const String iconLine = "assets/images/line.svg";
  static const String iconMicrophone = "assets/images/microphone.svg";
  static const String iconDown = "assets/images/down_button.svg";
  static const String iconFilterDark = "assets/images/filter_button_dark.png";
  static const String iconFilterWhite = "assets/images/filter_button_light.png";
  static const String iconLocationPin = "assets/images/location_pin.png";
  static const String iconGreenStar = "assets/images/green_star.png";
  static const String iconAskOstello = "assets/images/ask_ostello.png";

  // Placeholder image URL template (can be formatted with width and height).
  static const String placeholderImage = "https://via.placeholder.com/%dx%d";

  // Utility function to determine if the screen orientation is portrait.
  static bool isScreenPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  // Function to get effective media query element width
  // based on screen orientation and pre-defined base widths.
  static double fem(BuildContext context) {
    return MediaQuery.of(context).size.width /
        (isScreenPortrait(context) ? baseWidth : baseWidthLandscape);
  }

  // Function to get slightly adjusted effective media query element width.
  static double ffem(BuildContext context) {
    return fem(context) * 0.97;
  }

  // List of options for sorting filters.
  static const List<Map<String, String>> sortFilterOpt = [
    {"key": "relevance", "value": "Relevance"},
    {"key": "distance", "value": "Distance"},
    {"key": "discount", "value": "Discount"},
    {"key": "rating", "value": "Rating"}
  ];
}
