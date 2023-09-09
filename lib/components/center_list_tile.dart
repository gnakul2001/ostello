import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ostello/components/shimmer.dart';
import 'package:ostello/components/tags.dart';
import 'package:ostello/constants/constants.dart';
import 'package:ostello/models/centers.dart';
import 'package:ostello/utils.dart';
import 'package:sprintf/sprintf.dart';

class CenterList extends StatelessWidget {
  final CenterModel centerModel;
  final bool isLoading;

  /// Parameters:
  ///   - centerModel: A model containing information about the center.
  const CenterList(this.centerModel, {super.key, this.isLoading = false});

  /// Generates a widget presenting information in a centered list format.
  ///
  /// This widget arranges information in a centered list layout. The [centerModel]
  /// provides the necessary data related to the center that will be displayed
  /// within the returned widget.
  ///
  /// Returns:
  ///   A Flutter widget displaying center-related details in a list format.
  @override
  Widget build(BuildContext context) {
    double fem = Constants.fem(context);
    double ffem = Constants.ffem(context);
    bool isScreenPortrait = Constants.isScreenPortrait(context);
    double centerInfoWidth =
        // Card Width
        (338 * fem) -
            // Center Image Width
            (157 * fem) -
            // Left Card Padding
            (16 * fem) -
            // Left Padding
            (26 * fem);
    // Return a Container widget.
    return Container(
      // Set margin for the Container using EdgeInsets.
      margin: EdgeInsets.fromLTRB(
        (isScreenPortrait ? 0 : 13) *
            fem, // Conditional margin based on screen orientation
        0,
        (isScreenPortrait ? 0 : 13) * fem,
        21 * fem,
      ),
      // Set padding for the Container using EdgeInsets.
      padding: EdgeInsets.fromLTRB(0, 0, 0,
          (centerModel.bottomTexts?.isNotEmpty ?? false ? 8 : 0) * fem),
      // Apply a BoxDecoration with a background color and border radius if withBottomTexts is true, otherwise, set it to null.
      decoration: centerModel.bottomTexts?.isNotEmpty ?? false
          ? BoxDecoration(
              color: const Color(0xfff6effe),
              borderRadius: BorderRadius.circular(16 * fem),
            )
          : null,
      // Create a Column to arrange child widgets vertically.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nested Container for the main content area.
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 5 * fem),
            // Set padding for this Container.
            padding:
                EdgeInsets.fromLTRB(12 * fem, 12 * fem, 18 * fem, 14 * fem),
            height: 175 * fem,
            // Apply BoxDecoration with a background color, border radius, and shadow.
            decoration: BoxDecoration(
              color: const Color(0xfff6effe),
              borderRadius: BorderRadius.circular(16 * fem),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x3f000000),
                  offset: const Offset(0, 0),
                  blurRadius: 2 * fem,
                ),
              ],
            ),
            // Create a Row to arrange child widgets horizontally.
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Container for the center image.
                isLoading
                    ? ShimmerBlock(
                        child: Container(
                          margin: EdgeInsets.only(right: 12 * fem),
                          width: 157 * fem,
                          child: Container(
                            width: 157 * fem,
                            height: double.infinity,
                            decoration: ShapeDecoration(
                              color: const Color(0xfff6effe),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.only(right: 12 * fem),
                        width: 157 * fem,
                        // Create a Stack to overlay multiple widgets.
                        child: Stack(
                          children: [
                            // Container for the image.
                            Container(
                              width: 157 * fem,
                              height: double.infinity,
                              decoration: ShapeDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: getImageProvider(context),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            // Container with a gradient for text overlay.
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                0,
                                126.54 * fem,
                                0,
                                7.46 * fem,
                              ),
                              width: 157 * fem,
                              height: double.infinity,
                              decoration: ShapeDecoration(
                                gradient: LinearGradient(
                                  begin: const Alignment(0.006, 0.075),
                                  end: const Alignment(0.006, 0.767),
                                  colors: [
                                    Colors.white.withOpacity(0),
                                    const Color(0xE57D23E0)
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              // Create a Row to arrange child widgets horizontally.
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        0, 0, 4.62 * fem, 2.72 * fem),
                                    width: 5.85 * fem,
                                    height: 9.93 * fem,
                                    child: Image.asset(
                                      Constants.iconLocationPin,
                                      width: 5.85 * fem,
                                      height: 9.93 * fem,
                                    ),
                                  ),
                                  Flexible(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 109 * fem,
                                      ),
                                      child: Text(
                                        centerModel.centerLocation ?? "",
                                        softWrap: true,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: fontStyles(
                                          Constants.defaultFont,
                                          fontSize: 10 * ffem,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xeaffffff),
                                          height: 1.50 * fem,
                                          letterSpacing: 0.10 * fem,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                // Container for center info.
                Container(
                  width: double.infinity,
                  // Calculate max width to auto wrap the tags.
                  constraints: BoxConstraints(
                    maxWidth: centerInfoWidth,
                  ),
                  // Create a Column to arrange child widgets vertically.
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 8 * fem),
                            alignment: Alignment.topLeft,
                            child: isLoading
                                ? ShimmerBlock(
                                    child: Container(
                                      width: double.infinity,
                                      height: 20 * fem,
                                      decoration: BoxDecoration(
                                        color: const Color(0xfff6effe),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  )
                                : Text(
                                    centerModel.centerName ?? "",
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    style: fontStyles(
                                      Constants.defaultFont,
                                      fontSize: 16 * ffem,
                                      fontWeight: FontWeight.w700,
                                      height: 1.06 * fem,
                                      letterSpacing: 0.16 * fem,
                                      color: const Color(0xff272727),
                                    ),
                                  ),
                          ),
                          // Container for star rating and distance.
                          Container(
                            margin:
                                EdgeInsets.fromLTRB(1 * fem, 0, 0, 10 * fem),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    right: 5 * fem,
                                  ),
                                  child: isLoading
                                      ? ShimmerBlock(
                                          child: Container(
                                            width:
                                                (centerInfoWidth * 0.4) * fem,
                                            height: 20 * fem,
                                            decoration: BoxDecoration(
                                              color: const Color(0xfff6effe),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                        )
                                      : Row(
                                          children: [
                                            // Container for star icon.
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                0,
                                                0,
                                                3 * fem,
                                                1 * fem,
                                              ),
                                              width: 14 * fem,
                                              height: 14 * fem,
                                              child: Image.asset(
                                                Constants.iconGreenStar,
                                                width: 14 * fem,
                                                height: 14 * fem,
                                              ),
                                            ),
                                            // Text displaying star rating.
                                            Text(
                                              formatDouble(
                                                  centerModel.centerRating),
                                              style: fontStyles(
                                                Constants.defaultFont,
                                                fontSize: 12 * ffem,
                                                fontWeight: FontWeight.w400,
                                                height: 1.42 * fem,
                                                letterSpacing: 0.12 * fem,
                                                color: const Color(0xff414141),
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                                // Container for a small circle.
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                    0,
                                    0,
                                    6 * fem,
                                    0,
                                  ),
                                  width: 3 * fem,
                                  height: 3 * fem,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(1.5 * fem),
                                    color: const Color(0xff414141),
                                  ),
                                ),
                                // Text displaying distance.
                                isLoading
                                    ? ShimmerBlock(
                                        child: Container(
                                          width: ((centerInfoWidth * 0.6) -
                                                  5 -
                                                  3 -
                                                  6) *
                                              fem,
                                          height: 20 * fem,
                                          decoration: BoxDecoration(
                                            color: const Color(0xfff6effe),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                      )
                                    : Text(
                                        "${reduceLargeNumber(centerModel.centerDistance / 1000.0)}km away",
                                        style: fontStyles(
                                          Constants.defaultFont,
                                          fontSize: 12 * ffem,
                                          fontWeight: FontWeight.w400,
                                          height: 1.42 * fem,
                                          letterSpacing: 0.12 * fem,
                                          color: const Color(0xff414141),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Container for tags.
                      isLoading
                          ? ShimmerBlock(
                              child: Column(
                                children: [
                                  Container(
                                    height: 20 * fem,
                                    margin: EdgeInsets.only(bottom: 10 * fem),
                                    decoration: BoxDecoration(
                                      color: const Color(0xfff6effe),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  Container(
                                    height: 20 * fem,
                                    margin: EdgeInsets.only(bottom: 10 * fem),
                                    decoration: BoxDecoration(
                                      color: const Color(0xfff6effe),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  Container(
                                    height: 20 * fem,
                                    margin: EdgeInsets.only(bottom: 10 * fem),
                                    decoration: BoxDecoration(
                                      color: const Color(0xfff6effe),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: 1 * fem,
                                ),
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    spacing: 9 * fem,
                                    runSpacing: 10 * fem,
                                    children: [
                                      ...[
                                        for (int i = 0;
                                            i <
                                                (centerModel
                                                        .centerTags?.length ??
                                                    0);
                                            i++)
                                          Tag(
                                            centerModel
                                                    .centerTags?[i].tagText ??
                                                "",
                                            isHighlighted: centerModel
                                                    .centerTags?[i]
                                                    .isHighlighted ??
                                                false,
                                          ),
                                      ] // Function call to getTag
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Conditionally display the bottom text section.
          if (centerModel.bottomTexts?.isNotEmpty ?? false)
            LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return Container(
                  constraints: BoxConstraints(
                    minHeight: 0, // Resetting to 0
                    maxHeight: min(100 * fem, viewportConstraints.maxHeight),
                  ),
                  margin: EdgeInsets.fromLTRB(12 * fem, 0, 0, 0),
                  child: isLoading
                      ? ShimmerBlock(
                          child: Container(
                            width: centerInfoWidth + (157 + 12) * fem,
                            height: 20 * fem,
                            decoration: BoxDecoration(
                              color: const Color(0xfff6effe),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              ...[
                                for (int i = 0;
                                    i < (centerModel.bottomTexts?.length ?? 0);
                                    i++)
                                  Row(
                                    children: [
                                      // Container for a small circle.
                                      Container(
                                        margin: EdgeInsets.fromLTRB(
                                          10 * fem,
                                          0,
                                          6 * fem,
                                          0,
                                        ),
                                        width: 4 * fem,
                                        height: 4 * fem,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4 * fem),
                                          color: const Color(0xff414141),
                                        ),
                                      ),
                                      // Text displaying a message.
                                      Text(
                                        centerModel.bottomTexts?[i] ?? "",
                                        style: fontStyles(
                                          Constants.defaultFont,
                                          fontSize: 12 * ffem,
                                          fontWeight: FontWeight.w400,
                                          height: 1.42 * fem,
                                          color: const Color(0xff414141),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ],
                          ),
                        ),
                );
              },
            ),
        ],
      ),
    );
  }

  /// Generates an image provider based on the given `CenterModel`.
  ///
  /// This function checks the type of image (URL or asset) in the provided `CenterModel`
  /// and returns the appropriate image provider accordingly. If the image type is URL,
  /// it returns a `CachedNetworkImageProvider`. Otherwise, it returns an `AssetImage`.
  ///
  /// Returns:
  ///   A Flutter image provider for the given center's image.
  ImageProvider<Object> getImageProvider(BuildContext context) {
    double fem = Constants.fem(context);
    // Check if the type of centerImage is 'url' or use 'url' as a default.
    if ((centerModel.centerImage?.type ?? "url") == "url") {
      // If the image type is 'url', return a network image.
      return CachedNetworkImageProvider(
        // Use the provided URL from centerImage or a placeholder image.
        centerModel.centerImage?.url ??
            sprintf(
              // Format the placeholder image URL with specified dimensions.
              Constants.placeholderImage,
              [
                // Set the width of the image using the 'fem' factor.
                (157 * fem).toInt(),
                // Set the height of the image using the 'fem' factor.
                (149 * fem).toInt(),
              ],
            ),
      );
    } else {
      // If the image type is not 'url', return an asset image.
      return AssetImage(
        // Use the provided URL from centerImage or an empty string as a default.
        (centerModel.centerImage?.url ?? ""),
      );
    }
  }
}
