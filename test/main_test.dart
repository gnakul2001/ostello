// Import necessary libraries for testing and the components under test.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ostello/config/app_config.dart';
import 'package:ostello/main.dart';
import 'package:ostello/screens/center_lists.dart';

void main() {
  // Test to ensure the app renders correctly with expected properties.
  testWidgets('Renders correctly with expected properties',
      (WidgetTester tester) async {
    // Pump the MyApp widget wrapped in a ConfigProvider for testing.
    await tester.pumpWidget(ConfigProvider(
        config: AppConfig(isUnderTest: true), child: const MyApp()));

    // Check if the app contains necessary widgets.
    expect(find.byType(SafeArea), findsOneWidget); // Check if SafeArea exists.
    expect(
        find.byType(GestureDetector),
        findsAtLeastNWidgets(
            1)); // Check if at least one GestureDetector exists.
    expect(find.byType(Screen1), findsOneWidget); // Check if Screen1 exists.
  });

  // Test to validate the app's theme properties.
  testWidgets('App theming is set correctly', (WidgetTester tester) async {
    // Pump the MyApp widget wrapped in a ConfigProvider for testing.
    await tester.pumpWidget(ConfigProvider(
        config: AppConfig(isUnderTest: true), child: const MyApp()));

    // Retrieve the ThemeData to check its properties.
    final ThemeData theme = Theme.of(tester.element(find.byType(MaterialApp)));

    // Assert that the primary color of the theme is blue.
    expect(theme.primaryColor, Colors.blue);
  });

  // Test to ensure the debug mode banner is not shown in the app.
  testWidgets('Debug mode banner is not shown', (WidgetTester tester) async {
    // Pump the MyApp widget wrapped in a ConfigProvider for testing.
    await tester.pumpWidget(ConfigProvider(
        config: AppConfig(isUnderTest: true), child: const MyApp()));

    // Retrieve the MaterialApp widget to check its properties.
    final MaterialApp app = tester.widget(find.byType(MaterialApp));

    // Assert that the debug banner is turned off.
    expect(app.debugShowCheckedModeBanner, false);
  });
}
