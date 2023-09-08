import 'package:flutter/material.dart';
import 'package:ostello/constants/constants.dart';
import 'package:ostello/utils.dart';

class Tag extends StatelessWidget {
  final String tagText;
  final bool isHighlighted;

  /// Parameters:
  ///   - tagText: The text content of the tag.
  const Tag(this.tagText, {super.key, this.isHighlighted = false});

  /// Generates a tag widget with customizable text content and highlight style.
  ///
  /// This function creates a tag widget based on the provided [tagText]. The [isHighlighted]
  /// parameter determines whether the tag should be styled in a highlighted manner. By default,
  /// the tag is not highlighted.
  ///
  /// Returns:
  ///   A Flutter widget representing the customizable tag.
  @override
  Widget build(BuildContext context) {
    double fem = Constants.fem(context);
    double ffem = Constants.ffem(context);
    // Outer container holding the tag
    return Container(
      // Padding for the tag content
      padding: const EdgeInsets.only(
        left: 5,
        right: 5,
      ),
      // Ensure a minimum width if the tag is highlighted
      constraints: isHighlighted ? const BoxConstraints(minWidth: 57) : null,
      // Fixed height for the tag
      height: 19 * fem,
      // Decoration properties for the tag (color, border, borderRadius)
      decoration: BoxDecoration(
        color: isHighlighted ? Constants.primaryColor : Colors.transparent,
        border: Border.all(
          color: Constants.primaryColor,
        ),
        borderRadius: BorderRadius.circular(4 * fem),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The actual text of the tag
          Text(
            tagText,
            style: fontStyles(
              Constants.defaultFont,
              fontSize: 10 * ffem,
              fontWeight: FontWeight.w600,
              // Adjusting text height based on highlight status
              height: (isHighlighted ? 1.7 : 1) * ffem / fem,
              // Adjusting letter spacing based on highlight status
              letterSpacing: (isHighlighted ? 0.1 : 1.2) * fem,
              // Adjusting text color based on highlight status
              color: isHighlighted ? Colors.white : Constants.primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
