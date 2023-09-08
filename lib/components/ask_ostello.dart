import 'package:flutter/material.dart';
import 'package:ostello/constants/constants.dart';
import 'package:ostello/utils.dart';

class AskOstello extends StatelessWidget {
  const AskOstello({super.key});

  /// Generates a widget presenting the "Ask Ostello" feature.
  ///
  /// This widget includes an image positioned to the left, followed by
  /// a descriptive text and a clickable text box, allowing users to access
  /// the "Ask Ostello" feature.
  ///
  /// Returns:
  ///   A Flutter widget representing the "Ask Ostello" feature.
  @override
  Widget build(BuildContext context) {
    double fem = Constants.fem(context);
    double ffem = Constants.ffem(context);
    bool isScreenPortrait = Constants.isScreenPortrait(context);
    // Main container holding the entire content
    return Container(
      // Margins to position the main container
      margin: EdgeInsets.fromLTRB(
        (isScreenPortrait ? 0 : 13) * fem,
        0,
        (isScreenPortrait ? 0 : 13) * fem,
        21 * fem,
      ),
      // Conditional height based on screen orientation
      height: (isScreenPortrait ? 100 : 175) * fem,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Container holding the image
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 5 * fem, 0),
            width: 75 * fem,
            child: Image.asset(
              Constants.iconAskOstello,
              width: 450 * fem,
              height: 450 * fem,
            ),
          ),
          // Container holding the descriptive text
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 8 * fem, 0),
            constraints: BoxConstraints(
              maxWidth: 156 * fem,
            ),
            child: Text(
              'Having a tough time navigating through your career roadmap?',
              style: fontStyles(
                Constants.defaultFont,
                fontSize: 12 * ffem,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          // Container for the "Ask Ostello" button
          Container(
            margin: EdgeInsets.fromLTRB(0, 27 * fem, 0, 30),
            padding: EdgeInsets.fromLTRB(12 * fem, 6 * fem, 12 * fem, 5 * fem),
            width: 90 * fem,
            height: 28 * fem,
            decoration: BoxDecoration(
              color: Constants.primaryColor,
              borderRadius: BorderRadius.circular(11 * fem),
            ),
            child: Center(
              child: Text(
                'Ask Ostello',
                style: fontStyles(
                  Constants.defaultFont,
                  fontSize: 12 * ffem,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
