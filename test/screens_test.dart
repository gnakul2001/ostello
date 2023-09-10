// Import required libraries for testing and the specific component under test.
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ostello/components/center_list_tile.dart';
import 'package:ostello/components/custom_dropdown.dart';
import 'package:ostello/components/filter_tag.dart';
import 'package:ostello/config/app_config.dart';
import 'package:ostello/main.dart';
import 'package:ostello/screens/center_lists.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  databaseFactory = databaseFactoryFfi;

  // Group of tests dedicated to Screen1 functionalities.
  group('Screen1 Tests', () {
    // Test to ensure the main widget of Screen1 is built without any errors.
    testWidgets('main widget builds without errors',
        (WidgetTester tester) async {
      await tester.pumpWidget(ConfigProvider(
          config: AppConfig(isUnderTest: true), child: const MyApp()));
      final screen1Finder = find.byType(Screen1);
      expect(screen1Finder, findsOneWidget);
    });

    // Test to validate the search bar widget's rendering.
    testWidgets('search bar widget renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(ConfigProvider(
          config: AppConfig(isUnderTest: true), child: const MyApp()));
      final searchBarFinder = find.byType(TextField);
      expect(searchBarFinder, findsOneWidget);
    });

    // Test to validate the rendering of filter widgets.
    testWidgets('filters widget renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(ConfigProvider(
          config: AppConfig(isUnderTest: true), child: const MyApp()));
      final filtersFinder = find.byType(FilterTag);
      expect(filtersFinder, findsWidgets);
    });

    // Test to validate the CustomDropdownButton widget's rendering.
    testWidgets('CustomDropdownButton widget renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(ConfigProvider(
          config: AppConfig(isUnderTest: true), child: const MyApp()));
      final dropdownFinder = find.byType(CustomDropdownButton);
      expect(dropdownFinder, findsOneWidget);
    });

    // Test to ensure the SVG icons in the search bar are rendered correctly.
    testWidgets('SVG icons in search bar render correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(ConfigProvider(
          config: AppConfig(isUnderTest: true), child: const MyApp()));
      final svgIconFinder = find.byType(SvgPicture);
      expect(svgIconFinder, findsAtLeastNWidgets(3));
    });

    // Test to validate the initial state of filter tags.
    testWidgets('Initial state of filters', (WidgetTester tester) async {
      await tester.pumpWidget(ConfigProvider(
          config: AppConfig(isUnderTest: true), child: const MyApp()));
      final filterTagFinder = find.byType(FilterTag);
      expect(filterTagFinder, findsNWidgets(4));
    });

    // Test to ensure the placeholder centers are loaded initially.
    testWidgets('Placeholder centers are loaded initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(ConfigProvider(
          config: AppConfig(isUnderTest: true), child: const MyApp()));
      final centerListFinder = find.byType(CenterList);
      expect(centerListFinder, findsNWidgets(6));
    });

    // Test to check the behavior of the microphone button.
    testWidgets('Microphone button behavior', (WidgetTester tester) async {
      await tester.pumpWidget(ConfigProvider(
          config: AppConfig(isUnderTest: true), child: const MyApp()));
      final finder = find.byKey(const Key('microphoneIcon'));
      expect(finder, findsOneWidget);
      await tester.tap(finder);
      await tester.pump();
      expect(find.text('The user has denied the use of speech recognition.'),
          findsOneWidget);
    });

    // Test to simulate and validate user interactions with filter tags.
    testWidgets('Interaction with filter tags', (WidgetTester tester) async {
      await tester.pumpWidget(ConfigProvider(
          config: AppConfig(isUnderTest: true), child: const MyApp()));
      final jeeFilterTagFinder = find.widgetWithText(FilterTag, 'JEE');
      expect(jeeFilterTagFinder, findsOneWidget);
      await tester.tap(jeeFilterTagFinder);
      await tester.pump();
    });
  });
}
