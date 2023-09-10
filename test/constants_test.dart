// Importing the necessary Flutter and related libraries
import 'package:flutter/material.dart'; // Importing Flutter's core material design library
import 'package:flutter_test/flutter_test.dart'; // Importing Flutter's testing library
import 'package:ostello/constants/constants.dart'; // Importing app-specific constants

void main() {
  // Grouping tests related to constants initialization
  group('Constants Initialization Tests', () {
    // Testing if the primary and placeholder text colors are initialized correctly
    test('Colors are correctly initialized', () {
      expect(Constants.primaryColor, const Color(0xFF7D23E0));
      expect(Constants.textPlaceholderColor, const Color(0xff787878));
    });

    // Testing if the default font is initialized correctly
    test('Default font is correctly initialized', () {
      expect(Constants.defaultFont, "AvenirNextLTPro");
    });

    // Testing if the baseWidth and baseWidthLandscape constants are correctly initialized
    test('baseWidth and baseWidthLandscape is correctly initialized', () {
      expect(Constants.baseWidth, 390);
      expect(Constants.baseWidthLandscape, 784);
    });

    // Testing if the paths to icon and SVG assets are correctly initialized
    test('Icon and SVG paths are correctly initialized', () {
      expect(Constants.iconSearch, "assets/images/search.svg");
      expect(Constants.iconLine, "assets/images/line.svg");
      expect(Constants.iconMicrophone, "assets/images/microphone.svg");
      expect(Constants.iconDown, "assets/images/down_button.svg");
      expect(Constants.iconFilterDark, "assets/images/filter_button_dark.png");
      expect(
          Constants.iconFilterWhite, "assets/images/filter_button_light.png");
      expect(Constants.iconLocationPin, "assets/images/location_pin.png");
      expect(Constants.iconGreenStar, "assets/images/green_star.png");
      expect(Constants.iconAskOstello, "assets/images/ask_ostello.png");
    });

    // Testing if the placeholder image URL is correctly initialized
    test('Placeholder image URL format is correct', () {
      const placeholderImage = Constants.placeholderImage;
      expect(placeholderImage, contains("https://via.placeholder.com/"));
    });
  });

  // Grouping tests related to screen utility functions
  testWidgets('Screen utility functions', (WidgetTester tester) async {
    // Setting the screen size for portrait mode
    tester.view.physicalSize = const Size(390, 800);
    tester.view.devicePixelRatio = 1.0;

    // Testing in Portrait Orientation
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (BuildContext context) {
          // Checking if the screen is in portrait mode
          expect(Constants.isScreenPortrait(context), isTrue);

          // Calculating expected values for portrait mode
          const expectedFEMPortrait = 390 / Constants.baseWidth;
          const expectedFFEMPortrait = expectedFEMPortrait * 0.97;

          // Verifying font scale values for portrait mode
          expect(Constants.fem(context), closeTo(expectedFEMPortrait, 0.001));
          expect(Constants.ffem(context), closeTo(expectedFFEMPortrait, 0.001));

          return const Placeholder();
        },
      ),
    ));

    // Rotating the screen to Landscape orientation
    tester.view.physicalSize = const Size(800, 390);

    // Testing in Landscape Orientation
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (BuildContext context) {
          // Checking if the screen is in landscape mode
          expect(Constants.isScreenPortrait(context), isFalse);

          // Calculating expected values for landscape mode
          const expectedFEMLandscape = 800 / Constants.baseWidthLandscape;
          const expectedFFEMLandscape = expectedFEMLandscape * 0.97;

          // Verifying font scale values for landscape mode
          expect(Constants.fem(context), closeTo(expectedFEMLandscape, 0.001));
          expect(
              Constants.ffem(context), closeTo(expectedFFEMLandscape, 0.001));

          return const Placeholder();
        },
      ),
    ));

    // Resetting the screen to its original size after the test ends
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  // Testing if sort filter options are initialized correctly
  test('Sort filter options are correctly initialized', () {
    expect(Constants.sortFilterOpt, [
      {"key": "relevance", "value": "Relevance"},
      {"key": "distance", "value": "Distance"},
      {"key": "discount", "value": "Discount"},
      {"key": "rating", "value": "Rating"}
    ]);
  });
}
