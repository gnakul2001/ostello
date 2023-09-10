import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ostello/components/ask_ostello.dart';
import 'package:ostello/config/app_config.dart';
import 'package:ostello/constants/constants.dart';
import 'package:ostello/main.dart';
import 'package:ostello/models/centers.dart';
import 'package:ostello/utils.dart';

void main() {
  // Test to ensure that the custom scroll behavior includes both touch and mouse drag devices.
  test('MyCustomScrollBehavior drag devices', () {
    final behavior = MyCustomScrollBehavior();
    expect(behavior.dragDevices, contains(PointerDeviceKind.touch));
    expect(behavior.dragDevices, contains(PointerDeviceKind.mouse));
  });

  // Test to validate the fontStyles function's behavior when a valid fontFamily is provided.
  test('fontStyles function with provided fontFamily', () {
    final style = fontStyles('Arial', color: Constants.primaryColor);
    expect(style.color, Constants.primaryColor);
  });

  // Test to validate the fontStyles function's behavior when an invalid fontFamily is provided.
  test('fontStyles function with exception', () {
    final style = fontStyles('NonExistentFont', color: Constants.primaryColor);
    expect(
        style.color,
        Constants
            .primaryColor); // The function should handle exceptions gracefully.
  });

  // Test to validate the formatDouble function for various scenarios.
  test('formatDouble function', () {
    expect(formatDouble(123.4567), '123.46'); // Rounds to two decimal places.
    expect(formatDouble(123.4), '123.4'); // Keeps single decimal place.
    expect(formatDouble(123.0), '123'); // Removes unnecessary decimal.
  });

  // Test to validate the reduceLargeNumber function's formatting.
  test('reduceLargeNumber function', () {
    expect(reduceLargeNumber(1234567890),
        '1.23 B'); // Assuming the provided logic in reduceLargeNumber function.
  });

  // Test to ensure the getContext function returns a valid context.
  testWidgets('getContext function with valid context',
      (WidgetTester tester) async {
    await tester.pumpWidget(ConfigProvider(
        config: AppConfig(isUnderTest: true), child: const MyApp()));
    expect(getContext(), isNotNull);
  });

  // Test to validate the showSnackbar function displays a snackbar as expected.
  testWidgets('showSnackbar function', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showSnackbar('Test Snackbar', context: context);
              });
              return const Text('Test');
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Test Snackbar'), findsOneWidget);
  });

  // Test to validate that the afterBuild function invokes the provided callback.
  testWidgets('afterBuild function', (WidgetTester tester) async {
    bool callbackInvoked = false;
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          afterBuild(() {
            callbackInvoked = true;
          });
          return const SizedBox();
        },
      ),
    ));
    await tester.pump();
    expect(callbackInvoked, isTrue);
  });

  // Test to validate the getWidgetsFromCenterModelList function's output.
  test('getWidgetsFromCenterModelList function', () {
    final mockCenters = [CenterModel(), CenterModel(), CenterModel()];
    final widgets = getWidgetsFromCenterModelList(mockCenters);
    expect(widgets.length, 4); // 3 CenterList and 1 AskOstello widgets.
    expect(widgets[2].runtimeType,
        AskOstello); // The third widget should be AskOstello.
  });
}
