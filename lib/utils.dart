import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:ostello/components/ask_ostello.dart';
import 'package:ostello/components/center_list_tile.dart';
import 'package:ostello/main.dart';
import 'package:ostello/models/centers.dart';
import 'package:permission_handler/permission_handler.dart';

// Custom class to extend Flutter's default scroll behavior and specify devices that can initiate a drag gesture.
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  // Override the dragDevices to include touch and mouse as devices that can initiate a drag.
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

// Function to generate a TextStyle based on the provided parameters.
// The function prioritizes the custom fontFamily provided, and falls back to a Google Font if not available.
TextStyle fontStyles(
  String fontFamily, {
  TextStyle? textStyle,
  Color? color,
  Color? backgroundColor,
  double? fontSize,
  FontWeight? fontWeight,
  FontStyle? fontStyle,
  double? letterSpacing,
  double? wordSpacing,
  TextBaseline? textBaseline,
  double? height,
  Locale? locale,
  Paint? foreground,
  Paint? background,
  List<Shadow>? shadows,
  List<FontFeature>? fontFeatures,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
}) {
  try {
    // Attempt to return a TextStyle with the provided parameters.
    return TextStyle(
      fontFamily: fontFamily,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    ).merge(textStyle);
  } catch (ex) {
    // If the specified font family is not available, fallback to a default Google font.
    return GoogleFonts.getFont(
      "Source Sans Pro",
      textStyle: textStyle,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    ).merge(textStyle);
  }
}

// Function to format a double value, removing trailing zeros after the decimal point.
String formatDouble(double value) {
  // Multiply by 100, round to the nearest whole number, and then divide by 100 to get a rounded value with two decimal places.
  double temp = (value * 100).roundToDouble() / 100;

  // Convert the rounded value to a string with exactly two decimal places and split it at the decimal point.
  List<String> parts = temp.toStringAsFixed(2).split('.');

  // If there are no significant digits after the decimal point, return just the whole number.
  if (parts[1] == "00") {
    return parts[0];
  }
  // If there's only one significant digit after the decimal point, return the whole number and the first digit.
  else if (parts[1][1] == "0") {
    return '${parts[0]}.${parts[1][0]}';
  }

  // Otherwise, return the rounded value as a string.
  return temp.toString();
}

// Function to format large numbers with appropriate units (like K, M, B, etc.).
String reduceLargeNumber(double number) {
  // Define a list of units to represent thousands, millions, billions, etc.
  List<String> units = ["", "K", "M", "B", "T", "P", "E", "Z", "Y"];
  int index = 0;

  // Keep dividing the number by 1000 and incrementing the index to get the appropriate unit, until the number is less than 1000 or we've used all units.
  while (number >= 1000 && index < units.length - 1) {
    number /= 1000;
    index += 1;
  }

  // Return the formatted number with the appropriate unit.
  return "${formatDouble(number)} ${units[index]}";
}

// Function to retrieve the current BuildContext using the global navigatorKey.
BuildContext getContext() {
  // Get the current context associated with the global navigator key.
  BuildContext? context = navigatorKey.currentContext;

  // If a context is available, return it.
  if (context != null) {
    return context;
  }
  // If no context is available, throw an exception.
  else {
    throw Exception("No Context Available");
  }
}

// Function to request Bluetooth permissions for the app.
requestBluetoothPermission() async {
  // Request both the Bluetooth and BluetoothConnect permissions.
  Map<Permission, PermissionStatus> statuses = await [
    Permission.bluetooth,
    Permission.bluetoothConnect,
  ].request();

  // Check if any of the requested permissions have been denied.
  bool anyDenied = statuses.values.any((status) {
    return status.isDenied;
  });

  // If any permissions were denied, show a snackbar prompting the user to open settings and adjust permissions.
  if (anyDenied) {
    showSnackbar(
      "Some permissions were denied.",
      labelText: "Open Settings",
      onPressed: _openAppSettings,
    );
    return false;
  }
  // Return true if all permissions were granted.
  return true;
}

// Function to show a snackbar with a given message and an optional action.
void showSnackbar(message,
    {String? labelText, Function()? onPressed, BuildContext? context}) {
  try {
    // Create a snackbar with the provided message.
    final snackBar = SnackBar(
      content: Text(message),
      // If labelText is provided and not empty, create a snackbar action; otherwise, don't add an action.
      action: (labelText ?? "").isNotEmpty
          ? SnackBarAction(
              label: labelText ?? "",
              // If an onPressed function is provided, use it; otherwise, provide a default empty function.
              onPressed: onPressed ?? () {},
            )
          : null,
    );
    // Display the snackbar using the current context.
    ScaffoldMessenger.of(context ?? getContext()).showSnackBar(snackBar);
  }
  // If there's an error in showing the snackbar, catch the exception.
  catch (e) {
    // Error handling can be added here if needed.
  }
}

// Function to open the app's settings page.
void _openAppSettings() async {
  openAppSettings();
}

// Function to execute a callback after the current frame is rendered.
void afterBuild(Function() callback) {
  // Schedule a callback for the end of this frame.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    callback(); // Invoke the provided callback.
  });
}

// Function to convert a list of CenterModel objects into a list of widgets.
List<Widget> getWidgetsFromCenterModelList(List<CenterModel> centerMap) {
  // Initialize an empty list of widgets.
  List<Widget> centers = [];

  // Loop through each CenterModel in the provided list.
  for (int i = 0; i < centerMap.length; i++) {
    CenterModel centerModel = centerMap[i];

    // Convert the current CenterModel into a widget and add it to the list.
    centers.add(CenterList(centerModel));

    // If it's the second CenterModel in the list, add an AskOstello widget.
    if (i == 1) {
      centers.add(const AskOstello());
    }
  }

  // If there's only one CenterModel in the list or if the list is empty, add an AskOstello widget.
  if (centerMap.length < 2 || centerMap.isEmpty) {
    centers.add(const AskOstello());
  }

  // Return the list of generated widgets.
  return centers;
}
