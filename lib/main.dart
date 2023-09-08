import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ostello/components/custom_dropdown.dart';
import 'package:ostello/screens/center_lists.dart';
import 'package:ostello/utils.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<CustomDropdownButtonState> dropdownKey =
    GlobalKey<CustomDropdownButtonState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void closeAllDropdowns(BuildContext context) {
    dropdownKey.currentState?.closeDropdown();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Ostello OA',
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              closeAllDropdowns(context);
            },
            child: const Screen1(),
          ),
        ),
      ),
    );
  }
}
