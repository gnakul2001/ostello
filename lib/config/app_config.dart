// Importing necessary Flutter Material Design libraries.
import 'package:flutter/material.dart';

// A configuration class that determines if the application is under test.
class AppConfig {
  // A flag to denote if the application is currently being tested.
  final bool isUnderTest;

  // Constructor for AppConfig with an optional named parameter, defaulting to false if not provided.
  AppConfig({this.isUnderTest = false});
}

// A widget that provides configuration settings to its descendants in the widget tree.
class ConfigProvider extends InheritedWidget {
  // The configuration settings to be provided.
  final AppConfig? config;

  // Constructor for ConfigProvider, taking in an optional configuration and a required child widget.
  const ConfigProvider({Key? key, this.config, required Widget child})
      : super(key: key, child: child);

  // A method to retrieve the nearest ConfigProvider from the widget tree.
  static ConfigProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ConfigProvider>();
  }

  // Determines whether the widget should be updated based on changes in the configuration.
  @override
  bool updateShouldNotify(ConfigProvider oldWidget) {
    return config!.isUnderTest != oldWidget.config!.isUnderTest;
  }
}
