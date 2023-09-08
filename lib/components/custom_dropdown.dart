import 'package:flutter/material.dart';
import 'package:ostello/components/radio_button.dart';
import 'package:ostello/constants/constants.dart';
import 'package:ostello/filters/sort_filter.dart';
import 'package:ostello/utils.dart';

// A custom widget that represents a dropdown button.
class CustomDropdownButton extends StatefulWidget {
  // A list of filters that will be shown as options in the dropdown.
  final List<SortFilter> sortFilters;

  // Constructor that takes in the list of filters and an optional key for this widget.
  const CustomDropdownButton(this.sortFilters, {super.key});

  // Overrides the createState method to return an instance of CustomDropdownButtonState.
  @override
  CustomDropdownButtonState createState() => CustomDropdownButtonState();
}

class CustomDropdownButtonState extends State<CustomDropdownButton> {
  // A nullable reference to the OverlayEntry, which manages the dropdown overlay's position and visibility.
  OverlayEntry? _overlayEntry;

  // A boolean flag to determine whether the dropdown is currently opened or closed.
  bool isDropdownOpened = false;

  // A nullable variable to store the width of the dropdown container.
  double? containerWidth;

  @override
  Widget build(BuildContext context) {
    // Getting the scale factors for responsive design.
    double fem = Constants.fem(context);
    double ffem = Constants.ffem(context);

    // Setting the container width.
    containerWidth = 152 * fem;

    // Return a GestureDetector wrapping the dropdown container.
    return GestureDetector(
      // Handling the onTap to toggle the dropdown.
      onTap: toggleDropdown,
      child: Container(
        // Conditionally set the width based on if the dropdown is opened.
        width: isDropdownOpened ? containerWidth : null,

        // Setting padding for the filter container.
        padding: EdgeInsets.fromLTRB(
          13 * fem,
          6 * fem,
          10 * fem,
          7 * fem,
        ),

        // Applying decoration to the filter container.
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1 * fem,
              color: Constants.primaryColor,
            ),
            borderRadius: BorderRadius.circular(18 * fem),
          ),
        ),
        child: Row(
          // Aligning children to space between each other.
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // "Sort" text element.
            Text(
              'Sort',
              style: fontStyles(
                Constants.defaultFont,
                fontSize: 14 * ffem,
                fontWeight: FontWeight.w400,
                color: Constants.primaryColor,
                height: 1.21 * fem,
                letterSpacing: 0.14 * fem,
              ),
            ),
            // Aligning the dropdown icon to center.
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(left: 12),
                width: 9 * fem,
                height: 9 * fem,
                // Displaying the dropdown icon.
                child: Image.asset(
                  'assets/images/down_button.png',
                  width: 9 * fem,
                  height: 9 * fem,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to toggle the state of the dropdown.
  void toggleDropdown() {
    // If the dropdown is currently open.
    if (isDropdownOpened) {
      closeDropdown(); // Close the dropdown.
    } else {
      openDropdown(); // Open the dropdown.
    }
  }

  // Function to open the dropdown.
  void openDropdown() {
    // Update the UI to reflect the dropdown's open state.
    setState(() {
      isDropdownOpened = true; // Mark the dropdown as opened.
    });
    _overlayEntry =
        _createOverlayEntry(); // Create the overlay for the dropdown.
    Overlay.of(context)
        .insert(_overlayEntry!); // Insert the overlay into the widget tree.
  }

  // Function to close the dropdown.
  void closeDropdown() {
    _overlayEntry?.remove(); // Remove the overlay entry from the widget tree.

    // Update the UI to reflect the dropdown's closed state.
    setState(() {
      isDropdownOpened = false; // Mark the dropdown as closed.
    });
  }

  // Function to create the overlay for the dropdown.
  OverlayEntry _createOverlayEntry() {
    // Getting the RenderBox of the widget.
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    // Finding the position of the RenderBox in global coordinates.
    var offset = renderBox.localToGlobal(Offset.zero);
    // Calculating scale factors for responsive design.
    double fem = Constants.fem(context);
    double ffem = Constants.ffem(context);

    // Returning an OverlayEntry for the dropdown.
    return OverlayEntry(
      builder: (context) => Positioned(
        // Setting the position for the dropdown.
        left: offset.dx,
        top: offset.dy,
        child: Wrap(
          children: [
            // The main container for the dropdown.
            Container(
              width: 152 * fem,
              decoration: ShapeDecoration(
                // Setting the background color.
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  // Setting the border of the dropdown.
                  side:
                      BorderSide(width: 1 * fem, color: Constants.primaryColor),
                  // Setting the border radius.
                  borderRadius: BorderRadius.circular(15 * fem),
                ),
                shadows: const [
                  // Applying shadow to the dropdown.
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 2,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Container(
                // Setting margins for inner content.
                margin:
                    EdgeInsets.fromLTRB(15 * fem, 8 * fem, 15 * fem, 8 * fem),
                constraints: BoxConstraints(maxWidth: 152 * fem),
                child: Column(
                  children: [
                    // Looping through the sortFilters to create dropdown items.
                    for (int i = 0; i < widget.sortFilters.length; i++)
                      Container(
                        margin: EdgeInsets.only(bottom: 5.0 * fem),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Radio button for each dropdown item.
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  0 * fem, 0 * fem, 12 * fem, 0 * fem),
                              width: 17 * fem,
                              height: 17 * fem,
                              child: RadioButton(
                                isChecked: widget.sortFilters[i].isChecked,
                              ),
                            ),
                            // Text label for each dropdown item.
                            Expanded(
                              child: Text(
                                widget.sortFilters[i].title,
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: fontStyles(
                                  Constants.defaultFont,
                                  fontSize: 14 * ffem,
                                  fontWeight: FontWeight.w600,
                                  height: 1.71 * fem,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
