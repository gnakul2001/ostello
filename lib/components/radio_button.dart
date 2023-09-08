import 'package:flutter/material.dart';
import 'package:ostello/constants/constants.dart';

class RadioButton extends StatelessWidget {
  final bool isChecked;

  /// Constructs a RadioButton.
  ///
  /// The [isChecked] parameter indicates if the radio button is selected.
  /// By default, it's set to `false`.
  const RadioButton({Key? key, this.isChecked = false}) : super(key: key);

  /// Builds a custom-styled radio button.
  ///
  /// The radio button can be visually toggled between checked and unchecked states
  /// based on the [isChecked] value.
  ///
  /// Returns:
  ///   A custom-styled radio button widget.
  @override
  Widget build(BuildContext context) {
    // Custom styled radio button
    return SizedBox(
      width: 16,
      height: 16,
      child: Stack(
        children: [
          // Outer circle of the radio button
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 16,
              height: 16,
              decoration: const ShapeDecoration(
                shape: OvalBorder(
                  side: BorderSide(
                    width: 0.25,
                    color: Constants.primaryColor,
                  ),
                ),
              ),
            ),
          ),
          if (isChecked)
            // Inner circle indicating the radio is checked
            Positioned(
              left: 2,
              top: 2,
              child: Container(
                width: 12,
                height: 12,
                decoration: const ShapeDecoration(
                  color: Constants.primaryColor,
                  shape: OvalBorder(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
