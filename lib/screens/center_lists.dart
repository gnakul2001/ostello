import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ostello/components/ask_ostello.dart';
import 'package:ostello/components/center_list_tile.dart';
import 'package:ostello/components/custom_dropdown.dart';
import 'package:ostello/constants/constants.dart';
import 'package:ostello/dio_client.dart';
import 'package:ostello/filters/sort_filter.dart';
import 'package:ostello/main.dart';
import 'package:ostello/models/centers.dart';
import 'package:ostello/utils.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});
  @override
  State<Screen1> createState() => Screen1State();
}

class Screen1State extends State<Screen1> {
  // Define variables related to layout configurations and screen properties
  double fem =
      0; // Factor for enhancing responsive design based on screen dimensions
  double ffem = 0; // Factor specifically for font scaling in responsive design
  bool isScreenPortrait =
      true; // Boolean variable to determine if the screen is in portrait mode
  List<Widget> centers =
      []; // List to hold widgets representing each center's data
  TextEditingController controller =
      TextEditingController(); // Controller for text input
  bool isInited = false; // Flag to determine if initialization is complete

// Default function called when the widget is first created
  @override
  void initState() {
    super.initState();
  }

// Fetch data related to centers from the provided API endpoint
  void fetchCenterData() async {
    var url =
        'https://raw.githubusercontent.com/gnakul2001/ostello-python-dummy-data/master/center-dummy-data.json';
    DioClient dio = DioClient(); // Instantiate Dio client for network requests
    Response response = await dio.get(url); // Make a GET request

    if (response.statusCode == 200) {
      // Check if the request was successful
      List<dynamic> centerData =
          jsonDecode(response.data); // Decode the JSON data
      centers.clear(); // Clear any existing data in the centers list

      // Iterate through each center in the fetched data
      for (var center in centerData) {
        if (center["type"] == "list") {
          // Check the type of the center data
          var centerData = center["data"];
          centers.add(
            CenterList(
              CenterModel(
                centerImage: CenterImage(
                  type: centerData["center_image"]["type"] ??
                      "url", // Get the type of image (default to "url")
                  url: centerData["center_image"]["url"] ??
                      "", // Get the image URL
                ),
                centerLocation: centerData["center_location"] ??
                    "", // Get the center location
                centerName:
                    centerData["center_name"] ?? "", // Get the center name
                centerRating:
                    centerData["center_rating"] ?? 0, // Get the center rating
                centerDistance: centerData["center_distance"] ??
                    0, // Get the distance to the center
                centerTags: [
                  ...[
                    for (var tag in centerData["center_tags"] ??
                        []) // Iterate through each tag
                      CenterTag(
                        tagText: tag["tag_text"] ?? "", // Get the tag text
                        isHighlighted: tag["is_highlighted"] ??
                            false, // Determine if the tag is highlighted
                      )
                  ]
                ],
                bottomTexts: [
                  ...[
                    for (var str in centerData["bottom_texts"] ?? [])
                      str, // Iterate through bottom texts
                  ]
                ],
              ),
            ),
          );
        } else {
          centers.add(
            const AskOstello(),
          );
        }
        setState(() {}); // Update the UI with the fetched data
      }
    } else {
      throw Exception(
          'Failed to load center data'); // Throw an exception if the request failed
    }
  }

// Initialization function to set up necessary configurations and fetch data
  Future<void> init() async {
    isInited = true; // Mark the initialization as complete
    fem = Constants.fem(
        context); // Calculate the responsive design factor based on the screen size
    ffem = Constants.ffem(
        context); // Calculate the font scaling factor based on the screen size
    isScreenPortrait =
        Constants.isScreenPortrait(context); // Determine the screen orientation

    // Add placeholder data to the centers list while waiting for the actual data
    centers.addAll([
      CenterList(CenterModel(), isLoading: true),
      CenterList(CenterModel(), isLoading: true),
      CenterList(CenterModel(), isLoading: true),
      CenterList(CenterModel(), isLoading: true),
      CenterList(CenterModel(), isLoading: true),
      CenterList(CenterModel(), isLoading: true),
    ]);

    fetchCenterData(); // Fetch the center data
  }

  @override
  Widget build(BuildContext context) {
    if (!isInited) init(); // Initialize required variables or states

    return SizedBox(
      width: MediaQuery.of(context)
          .size
          .width, // Set width to occupy full available space
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white, // Set background color of the container to white
        ),
        child: Column(
          children: [
            if (isScreenPortrait) ...[
              // Display AppBar in portrait mode
              getAppBar(context),
              // Display Search Box in portrait mode
              getSearchBox(context),
            ],

            // Display AppBar and Search Box side-by-side in landscape mode
            if (!isScreenPortrait)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getAppBar(context),
                  getSearchBox(context),
                ],
              ),

            // Display Filters
            getFilters(context),

            // Display center lists
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                    26 / (isScreenPortrait ? 1 : 2) * fem,
                    16 * fem,
                    26 / (isScreenPortrait ? 1 : 2) * fem,
                    0,
                  ),
                  child: LayoutBuilder(
                    builder: (
                      BuildContext context,
                      BoxConstraints constraints,
                    ) {
                      // Display centers in a column layout in portrait mode
                      if (isScreenPortrait) {
                        // Return a column with all the centers stacked vertically
                        return Column(
                          children: centers,
                        );
                      } else {
                        // Display centers in a grid-like layout in landscape mode
                        List<Widget> rows = [];

                        for (int i = 0; i < centers.length; i += 2) {
                          // Create a list to store the children for the current row
                          List<Widget> childrenInRow = [];

                          // Add the first center to the row
                          childrenInRow.add(Expanded(child: centers[i]));

                          // Check if there is a subsequent center to be added in the same row
                          if (i + 1 < centers.length) {
                            childrenInRow.add(Expanded(child: centers[i + 1]));
                          }

                          // Add the created children to the row, aligning them to the start
                          rows.add(Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: childrenInRow,
                          ));
                        }
                        // Return a column with all the created rows
                        return Column(
                          children: [...rows],
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Generates an app bar widget for the application.
  ///
  /// This function creates an app bar widget that typically appears at the top of
  /// the application's user interface. It includes a back button on the left and
  /// a title text indicating the current context or screen.
  ///
  /// Parameters:
  ///   - context: The [BuildContext] used for widget construction.
  ///
  /// Returns:
  ///   A Flutter widget representing the app bar.
  Widget getAppBar(BuildContext context) {
    // Create a container to hold the app bar content.
    return Container(
      // Set the width of the container based on screen orientation.
      width: !isScreenPortrait
          ? MediaQuery.of(context).size.width * (2 / 6)
          : MediaQuery.of(context).size.width,
      // Set padding for the container.
      padding: EdgeInsets.fromLTRB(26 * fem, 24 * fem, 26 * fem, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Create a container for the back button.
          Container(
            // Set margin for the back button container.
            margin: EdgeInsets.fromLTRB(0, 0, 26 * fem, 0),
            width: 36 * fem,
            height: 36 * fem,
            child: Container(
              // Decorate the back button container as a circle with the primary color.
              decoration: const BoxDecoration(
                color: Constants.primaryColor,
                shape: BoxShape.circle,
              ),
              child: InkWell(
                // Create an InkWell for touch interaction.
                borderRadius: BorderRadius.circular(18.0),
                onTap: () {
                  // Handle the button press here when the back button is tapped.
                },
                child: Center(
                  // Center the icon in the Container.
                  child: IgnorePointer(
                    // Ignore the default touch target size of IconButton.
                    child: Icon(
                      Icons.chevron_left,
                      size: 25 * ffem,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Create a container for the title text.
          Container(
            // Set margin for the title text container.
            margin: EdgeInsets.fromLTRB(0, 3 * fem, 0, 0),
            child: Text(
              'For JEE-Mains',
              style: fontStyles(
                Constants.defaultFont,
                fontSize: 16 * ffem,
                fontWeight: FontWeight.w600,
                height: 1.06 * fem,
                letterSpacing: 0.16 * fem,
                color: const Color(0xff000000),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Generates a search box widget for the application.
  ///
  /// This function creates a search box widget that allows users to input search queries.
  /// The search box is styled with specific margins, height, and width. It includes
  /// hint text to guide the user and suffix icons for additional functionalities like
  /// voice search. The appearance of the search box changes based on the screen orientation.
  ///
  /// Parameters:
  ///   - context: The [BuildContext] used for widget construction.
  ///
  /// Returns:
  ///   A Flutter widget representing the search box.
  Widget getSearchBox(BuildContext context) {
    // Define a function to get a search box widget with context as parameter.
    return Container(
      // Define a container widget to wrap other widgets.
      margin: EdgeInsets.fromLTRB(26 * fem, 21 * fem, 26 * fem, 0),
      // Set margin for the container using EdgeInsets with multiplied factors.

      height: 44,
      // Set a fixed height for the container.

      width: !isScreenPortrait
          ? MediaQuery.of(context).size.width / 2
          : MediaQuery.of(context).size.width,
      // Set the width of the container dynamically based on the screen orientation and width.

      child: TextField(
        // Define a text field widget as a child of the container.
        controller: controller,
        // Set a controller to manage the text input and retrieval in the text field.

        decoration: InputDecoration(
          // Decorate the text field with various properties.
          hintText: 'Search for UPSC Coaching ',
          // Set a hint text to indicate the purpose of the text field.

          hintStyle: fontStyles(
            // Define a style for the hint text using a custom fontStyles function.
            Constants.defaultFont,
            // Set the default font from the Constants class.
            fontSize: 14 * ffem,
            // Set the font size with a multiplied factor.
            fontWeight: FontWeight.w400,
            // Set the font weight to w400.
            color: Constants.textPlaceholderColor,
            // Set the color of the hint text using a predefined color from Constants class.
          ),

          fillColor: Colors.white,
          // Set the background color of the text field to white.

          filled: true,
          // Enable the fillColor property.

          contentPadding: EdgeInsets.fromLTRB(
            // Define padding for the content inside the text field.
            14 * fem,
            10 * fem,
            11 * fem,
            10 * fem,
          ),

          border: OutlineInputBorder(
            // Define a border for the text field using OutlineInputBorder class.
            borderSide: BorderSide(
              // Define the properties of the border side.
              width: 1.5 * fem,
              // Set the width of the border with a multiplied factor.
              color: const Color(0xFFBDBDBD),
              // Set the color of the border using a constant color value.
            ),
            borderRadius: BorderRadius.circular(8 * fem),
            // Set the border radius to create rounded corners with a multiplied factor.
          ),

          enabledBorder: OutlineInputBorder(
            // Define a border for the text field when it is enabled but not focused.
            borderSide: BorderSide(
              // Set the properties for the border side.
              width: 1.5 * fem,
              // Set the width of the border.
              color: const Color(0xFFBDBDBD),
              // Set the color of the border.
            ),
            borderRadius: BorderRadius.circular(8 * fem),
            // Set the border radius to create rounded corners.
          ),

          focusedBorder: OutlineInputBorder(
            // Define a border for the text field when it is focused.
            borderSide: BorderSide(
              // Set the properties for the border side.
              width: 1.5 * fem,
              // Set the width of the border.
              color: Constants.primaryColor,
              // Set the color of the border using a predefined color from Constants class.
            ),
            borderRadius: BorderRadius.circular(8 * fem),
            // Set the border radius to create rounded corners.
          ),

          suffixIcon: IntrinsicWidth(
            // Define a suffix icon with intrinsic width to contain a row of icons.
            child: Container(
              // Wrap the row of icons inside a container.
              padding: EdgeInsets.fromLTRB(
                // Set padding for the container.
                10 * fem,
                0,
                11 * fem,
                0,
              ),

              child: Row(
                // Define a row to contain multiple icons.
                children: [
                  // Create a list of widgets as children of the row.
                  SizedBox(
                    // Define a sized box to contain the search icon.
                    width: 20 * fem,
                    // Set the width of the sized box.
                    height: 20 * fem,
                    // Set the height of the sized box.
                    child: SvgPicture.asset(
                      // Set the SVG picture asset for the search icon.
                      Constants.iconSearch,
                      // Set the icon from Constants class.
                      width: 20 * fem,
                      // Set the width of the icon.
                      height: 20 * fem,
                      // Set the height of the icon.
                    ),
                  ),
                  SizedBox(
                    // Define a sized box to contain the line icon.
                    width: 28 * fem,
                    // Set the width of the sized box.
                    height: 28 * fem,
                    // Set the height of the sized box.
                    child: SvgPicture.asset(
                      // Set the SVG picture asset for the line icon.
                      Constants.iconLine,
                      // Set the icon from Constants class.
                      width: 28 * fem,
                      // Set the width of the icon.
                      height: 28 * fem,
                      // Set the height of the icon.
                    ),
                  ),
                  SizedBox(
                    // Define a sized box to contain the microphone icon.
                    width: 23 * fem,
                    // Set the width of the sized box.
                    height: 23 * fem,
                    // Set the height of the sized box.
                    child: GestureDetector(
                      // Define a gesture detector to handle tap events.
                      onTap: () async {
                        // Define an asynchronous function to handle the onTap event.
                        if (await requestBluetoothPermission()) {
                          // Request Bluetooth permission and proceed if granted.
                          SpeechToText speech = SpeechToText();
                          // Create an instance of the SpeechToText class.
                          bool available = await speech.initialize(
                            // Initialize the speech instance with various callbacks.
                            onStatus: (msg) {
                              // Define a callback to handle status messages.
                              if (msg == "listening") {
                                // Show a snackbar when the speech is listening.
                                showSnackbar(
                                  "Start speaking",
                                );
                              } else if (msg == "stop") {
                                // Show a snackbar when the speech stops listening.
                                showSnackbar(
                                  "Stop speaking",
                                );
                              }
                            },
                            onError: (e) {
                              // Define a callback to handle errors.
                              showSnackbar(
                                "Error recognising audio.",
                                // Show a snackbar with an error message.
                              );
                            },
                            finalTimeout: const Duration(seconds: 5),
                            // Set a timeout duration for the final recognition.
                          );
                          if (available) {
                            // Check if speech recognition is available.
                            speech.listen(
                              // Start listening for speech input.
                              onResult: (result) {
                                // Define a callback to handle recognition results.
                                if (result.recognizedWords.isNotEmpty) {
                                  // Check if recognized words are not empty.
                                  controller.text = result.recognizedWords;
                                  // Set the recognized words as the text in the controller.
                                }
                              },
                            );
                          } else {
                            // Show a snackbar if speech recognition is not available.
                            showSnackbar(
                              "The user has denied the use of speech recognition.",
                            );
                          }
                        }
                      },
                      child: SvgPicture.asset(
                        // Set the SVG picture asset for the microphone icon.
                        Constants.iconMicrophone,
                        // Set the icon from Constants class.
                        width: 23 * fem,
                        // Set the width of the icon.
                        height: 23 * fem,
                        // Set the height of the icon.
                        colorFilter: const ColorFilter.mode(
                          // Apply a color filter to the icon.
                          Constants.primaryColor,
                          // Set the color from Constants class.
                          BlendMode.srcIn,
                          // Set the blend mode to srcIn.
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Returns a widget displaying a set of filters.
  ///
  /// This widget is used to display filters for a specific content,
  /// typically used in the user interface. It includes various filter options
  /// such as sorting and categories.
  ///
  /// Parameters:
  ///   - context: A [BuildContext] used for building the widget.
  ///
  /// Returns:
  ///   A Flutter widget representing the filters to be displayed.
  Widget getFilters(BuildContext context) {
    // Create a Container widget to hold the filters.
    return Container(
      // Set the margin for the Container.
      margin: EdgeInsets.fromLTRB(26 * fem, 17 * fem, 0, 16 * fem),
      // Set the height of the Container.
      height: 29 * fem,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        // Create a SingleChildScrollView to enable horizontal scrolling.
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Create the first filter Container.
            Container(
              // Set padding and decoration for the filter Container.
              padding: EdgeInsets.fromLTRB(
                11 * fem,
                6 * fem,
                6 * fem,
                7 * fem,
              ),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Add the "Filters" text.
                  Text(
                    'Filters',
                    style: fontStyles(
                      Constants.defaultFont,
                      fontSize: 14 * ffem,
                      fontWeight: FontWeight.w400,
                      color: Constants.primaryColor,
                      height: 1.21 * fem,
                      letterSpacing: 0.14 * fem,
                    ),
                  ),
                  // Add an image inside the filter Container.
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.only(left: 4),
                      width: 17 * fem,
                      height: 17 * fem,
                      child: Image.asset(
                        'assets/images/filter_button.png',
                        width: 12 * fem,
                        height: 12 * fem,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Add some horizontal spacing.
            SizedBox(
              width: 8 * fem,
            ),
            CustomDropdownButton(
              [
                SortFilter(
                  "RelevanceRelevance",
                  isChecked: true,
                ),
                SortFilter("Distance"),
                SortFilter("Price"),
                SortFilter("Rating"),
              ],
              key: dropdownKey,
            ),
            // Add some horizontal spacing.
            SizedBox(
              width: 8 * fem,
            ),
            // Create the second filter Container.
            Container(
              // Set padding and decoration for the filter Container.
              padding: EdgeInsets.fromLTRB(
                13 * fem,
                6 * fem,
                10 * fem,
                7 * fem,
              ),
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
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  iconSize: 0,
                  value: "Option 1",
                  onChanged: (newValue) {
                    setState(() {
                      // "" = newValue;
                    });
                  },
                  items:
                      ['Option 1', 'Option 2', 'Option 3'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(15), // Rounded corners
                          border:
                              Border.all(color: Colors.blueAccent, width: 2),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                  selectedItemBuilder: (BuildContext context) {
                    return [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: const EdgeInsets.only(left: 12),
                              width: 9 * fem,
                              height: 9 * fem,
                              child: Image.asset(
                                'assets/images/down_button.png',
                                width: 9 * fem,
                                height: 9 * fem,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ];
                  },
                ),
              ),
            ),
            // Add some horizontal spacing.
            SizedBox(
              width: 8 * fem,
            ),
            // Create a filter Container with a background color.
            Container(
              width: 83 * fem,
              height: MediaQuery.of(context).size.height,
              decoration: ShapeDecoration(
                color: Constants.primaryColor,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1 * fem,
                    color: Constants.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(18 * fem),
                ),
              ),
              child: Center(
                child: Text(
                  '<2Km',
                  style: fontStyles(
                    Constants.defaultFont,
                    fontSize: 14 * ffem,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    height: 1.21 * fem,
                    letterSpacing: 0.14 * fem,
                  ),
                ),
              ),
            ),
            // Add some horizontal spacing.
            SizedBox(
              width: 8 * fem,
            ),
            // Create a filter Container without a background color.
            Container(
              width: 83 * fem,
              height: MediaQuery.of(context).size.height,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1 * fem,
                    color: Constants.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(18 * fem),
                ),
              ),
              child: Center(
                child: Text(
                  'JEE',
                  style: fontStyles(
                    Constants.defaultFont,
                    fontSize: 14 * ffem,
                    fontWeight: FontWeight.w400,
                    color: Constants.primaryColor,
                    height: 1.21 * fem,
                    letterSpacing: 0.14 * fem,
                  ),
                ),
              ),
            ),
            // Add some horizontal spacing.
            SizedBox(
              width: 8 * fem,
            ),
            // Create another filter Container with a margin.
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 26 * fem, 0),
              width: 83 * fem,
              height: MediaQuery.of(context).size.height,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1 * fem,
                    color: Constants.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(18 * fem),
                ),
              ),
              child: Center(
                child: Text(
                  'Offers',
                  style: fontStyles(
                    Constants.defaultFont,
                    fontSize: 14 * ffem,
                    fontWeight: FontWeight.w400,
                    color: Constants.primaryColor,
                    height: 1.21 * fem,
                    letterSpacing: 0.14 * fem,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
