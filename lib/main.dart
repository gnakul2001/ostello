import 'package:flutter/material.dart';
import 'package:ostello/components/custom_dropdown.dart';
import 'package:ostello/screens/center_lists.dart';
import 'package:ostello/utils.dart';

// The main entry point for the application.
void main() {
  runApp(const MyApp());
}

// Global key to manage the Navigator state for routing and navigation.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Global key to manage the state of a custom dropdown button.
final GlobalKey<CustomDropdownButtonState> dropdownKey =
    GlobalKey<CustomDropdownButtonState>();

// The main application widget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Method to close all open dropdowns in the application.
  void closeAllDropdowns(BuildContext context) {
    dropdownKey.currentState?.closeDropdown();
  }

  // Build method to define the UI of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Use the global navigator key.
      navigatorKey: navigatorKey,

      // Title of the application.
      title: 'Ostello OA',

      // Disable the debug banner that appears in debug mode.
      debugShowCheckedModeBanner: false,

      // Custom scroll behavior defined in the code.
      scrollBehavior: MyCustomScrollBehavior(),

      // Theme settings for the application.
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      // The home widget, wrapped in SafeArea to avoid system UI overlaps.
      home: SafeArea(
        child: Scaffold(
          body: GestureDetector(
            // When the main body is tapped, defocus any text fields and close dropdowns.
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              closeAllDropdowns(context);
            },

            // The main screen of the application.
            child: const Screen1(),
          ),
        ),
      ),
    );
  }
}
