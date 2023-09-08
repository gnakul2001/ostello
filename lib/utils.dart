import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:ostello/main.dart';
import 'package:permission_handler/permission_handler.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

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

String formatDouble(double value) {
  double temp = (value * 100).roundToDouble() / 100;
  List<String> parts = temp.toStringAsFixed(2).split('.');
  if (parts[1] == "00") {
    return parts[0];
  } else if (parts[1][1] == "0") {
    return '${parts[0]}.${parts[1][0]}';
  }

  return temp.toString();
}

String reduceLargeNumber(double number) {
  List<String> units = ["", "K", "M", "B", "T", "P", "E", "Z", "Y"];
  int index = 0;
  while (number >= 1000 && index < units.length - 1) {
    number /= 1000;
    index += 1;
  }
  return "${formatDouble(number)} ${units[index]}";
}

BuildContext getContext() {
  BuildContext? context = navigatorKey.currentContext;
  if (context != null) {
    return context;
  } else {
    throw Exception("No Context Available");
  }
}

requestBluetoothPermission() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.bluetooth,
    Permission.bluetoothConnect,
  ].request();
  bool anyDenied = statuses.values.any((status) {
    print(status.toString());
    return status.isDenied;
  });

  if (anyDenied) {
    showSnackbar(
      "Some permissions were denied.",
      labelText: "Open Settings",
      onPressed: _openAppSettings,
    );
    return false;
  }
  return true;
}

void showSnackbar(message, {String? labelText, Function()? onPressed}) {
  try {
    final snackBar = SnackBar(
      content: Text(message),
      action: (labelText ?? "").isNotEmpty
          ? SnackBarAction(
              label: labelText ?? "",
              onPressed: onPressed ?? () {},
            )
          : null,
    );
    ScaffoldMessenger.of(getContext()).showSnackBar(snackBar);
  } catch (e) {
    //
  }
}

void _openAppSettings() async {
  openAppSettings();
}
