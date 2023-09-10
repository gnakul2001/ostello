// Importing necessary packages for Flutter and testing.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ostello/config/app_config.dart';

// Main function to run the tests.
void main() {
  // Test to check if the ConfigProvider can be accessed.
  testWidgets('can access ConfigProvider', (WidgetTester tester) async {
    // Create a small widget to fetch the ConfigProvider.
    final widget = MaterialApp(
      home: ConfigProvider(
        // Set the configuration with isUnderTest as true.
        config: AppConfig(isUnderTest: true),
        child: Builder(
          builder: (context) {
            // Get the ConfigProvider from the current context.
            final configProvider = ConfigProvider.of(context);
            // Display the 'isUnderTest' value as a Text widget.
            return Text(configProvider!.config!.isUnderTest.toString());
          },
        ),
      ),
    );

    // Render the widget for testing.
    await tester.pumpWidget(widget);

    // Verify if the displayed text is 'true'.
    expect(find.text('true'), findsOneWidget);
  });

  // Test to check if the updateShouldNotify behavior is correct.
  testWidgets('updateShouldNotify behaves correctly',
      (WidgetTester tester) async {
    // Create the initial widget tree with isUnderTest as true.
    final widget = MaterialApp(
      home: ConfigProvider(
        config: AppConfig(isUnderTest: true),
        child: Builder(
          builder: (context) {
            final configProvider = ConfigProvider.of(context);
            return Text(configProvider!.config!.isUnderTest.toString());
          },
        ),
      ),
    );

    // Render the initial widget for testing.
    await tester.pumpWidget(widget);

    // Update the widget tree with isUnderTest as false.
    await tester.pumpWidget(
      MaterialApp(
        home: ConfigProvider(
          config: AppConfig(isUnderTest: false),
          child: Builder(
            builder: (context) {
              final configProvider = ConfigProvider.of(context);
              return Text(configProvider!.config!.isUnderTest.toString());
            },
          ),
        ),
      ),
    );

    // Verify if the displayed text is updated to 'false'.
    expect(find.text('false'), findsOneWidget);
  });
}
