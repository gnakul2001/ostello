// Importing necessary Flutter and project-specific packages.
import 'package:flutter/material.dart';
import 'package:ostello/constants/constants.dart';
import 'package:ostello/utils.dart';

// A stateless widget representing a customizable filter tag.
class FilterTag extends StatelessWidget {
  // Properties for the FilterTag widget.
  final String tagText; // Text displayed on the tag.
  final bool isHighlighted; // Determines whether the tag is highlighted or not.
  final Container?
      iconHighlighted; // Icon to display when the tag is highlighted.
  final Container?
      iconUnHighlighted; // Icon to display when the tag is not highlighted.
  final Function()? onTap; // Callback function when the tag is tapped.

  // Constructor for the FilterTag widget with named and positional parameters.
  const FilterTag(
    this.tagText, {
    super.key,
    this.isHighlighted = false,
    this.iconHighlighted,
    this.iconUnHighlighted,
    this.onTap,
  });

  // Build method to describe the part of the user interface represented by this widget.
  @override
  Widget build(BuildContext context) {
    // Local variables for scaling factors based on screen dimensions.
    double fem = Constants.fem(context);
    double ffem = Constants.ffem(context);

    // Return an InkWell widget to provide tap gesture on the filter tag.
    return InkWell(
      onTap: onTap, // Execute the provided callback function on tap.
      child: Container(
        // Define padding and appearance for the filter tag container.
        padding: EdgeInsets.fromLTRB(
          11 * fem,
          6 * fem,
          6 * fem,
          7 * fem,
        ),
        constraints: iconHighlighted != null || iconUnHighlighted != null
            ? null
            : BoxConstraints(
                minWidth: 83 * fem,
              ),
        decoration: ShapeDecoration(
          color: isHighlighted
              ? Constants.primaryColor
              : Colors.white, // Set color based on the highlight status.
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1 * fem,
              color: Constants.primaryColor,
            ),
            borderRadius:
                BorderRadius.circular(18 * fem), // Rounded corners for the tag.
          ),
        ),
        // Check if icons are provided and display them accordingly.
        child: iconHighlighted != null || iconUnHighlighted != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Display the text of the tag.
                  Text(
                    tagText,
                    style: fontStyles(
                      Constants.defaultFont,
                      fontSize: 14 * ffem,
                      fontWeight: FontWeight.w400,
                      color:
                          isHighlighted ? Colors.white : Constants.primaryColor,
                      height: 1.21 * fem,
                      letterSpacing: 0.14 * fem,
                    ),
                  ),
                  // Display the icon based on the highlight status.
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.only(left: 4),
                      child:
                          isHighlighted ? iconHighlighted : iconUnHighlighted,
                    ),
                  ),
                ],
              )
            : Center(
                // Center the tag text if no icons are provided.
                child: Text(
                  tagText,
                  style: fontStyles(
                    Constants.defaultFont,
                    fontSize: 14 * ffem,
                    fontWeight: FontWeight.w400,
                    color:
                        isHighlighted ? Colors.white : Constants.primaryColor,
                    height: 1.21 * fem,
                    letterSpacing: 0.14 * fem,
                  ),
                ),
              ),
      ),
    );
  }
}
