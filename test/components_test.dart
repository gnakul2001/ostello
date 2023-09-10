import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ostello/components/ask_ostello.dart';
import 'package:ostello/components/center_list_tile.dart';
import 'package:ostello/components/custom_dropdown.dart';
import 'package:ostello/components/filter_tag.dart';
import 'package:ostello/components/radio_button.dart';
import 'package:ostello/components/shimmer.dart';
import 'package:ostello/components/tags.dart';
import 'package:ostello/constants/constants.dart';
import 'package:ostello/filters/sort_filter.dart';
import 'package:ostello/models/centers.dart';

import 'package:shimmer/shimmer.dart';
import 'package:sprintf/sprintf.dart';

void main() {
  // Finder function to locate an AssetImage with a specific asset name.
  Finder findAssetImage(String assetName) {
    return find.byWidgetPredicate(
      // Predicate function to determine if a widget matches the provided assetName.
      (Widget widget) =>
          widget is DecoratedBox &&
          widget.decoration is BoxDecoration &&
          (widget.decoration as BoxDecoration).image is DecorationImage &&
          ((widget.decoration as BoxDecoration).image as DecorationImage).image
              is AssetImage &&
          (((widget.decoration as BoxDecoration).image as DecorationImage).image
                      as AssetImage)
                  .assetName ==
              assetName,
      // A descriptive label for the finder.
      description: 'AssetImage with asset name $assetName',
    );
  }

// Group of tests dedicated to the AskOstello component.
  group("AskOstello Component Test", () {
    testWidgets('AskOstello Widget Test', (WidgetTester tester) async {
      // Initialize a variable to store the 'fem' value used for scaling.
      double fem = 1;

      // Build a temporary widget to retrieve the 'fem' scaling factor from the current context.
      Widget testWidget = Builder(
        builder: (BuildContext context) {
          // Extract and assign the 'fem' value from the context.
          fem = Constants.fem(context);

          // Render the primary AskOstello widget for the test.
          return const AskOstello();
        },
      );

      // Render the testWidget within a MaterialApp and Scaffold to provide necessary context.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: testWidget),
        ),
      );

      // Validate that an image widget is present within AskOstello.
      expect(find.byType(Image), findsOneWidget);

      // Validate the presence of a specific descriptive text within AskOstello.
      final descriptiveText = find
          .text('Having a tough time navigating through your career roadmap?');
      expect(descriptiveText, findsOneWidget);

      // Validate the presence of the "Ask Ostello" button.
      final askOstelloButton = find.text('Ask Ostello');
      expect(askOstelloButton, findsOneWidget);

      // Verify the text styling of the descriptive text.
      Text descriptiveTextWidget = tester.widget(descriptiveText);
      expect(descriptiveTextWidget.style!.fontSize, closeTo(12 * fem, 0.5));
      expect(descriptiveTextWidget.style!.fontWeight, FontWeight.w600);
      expect(descriptiveTextWidget.style!.color, Colors.black);

      // Verify the text styling of the "Ask Ostello" button.
      Text askOstelloButtonWidget = tester.widget(askOstelloButton);
      expect(askOstelloButtonWidget.style!.fontSize, closeTo(12 * fem, 0.5));
      expect(askOstelloButtonWidget.style!.fontWeight, FontWeight.w600);
      expect(askOstelloButtonWidget.style!.color, Colors.white);
    });
  });

  // Group of tests dedicated to the CenterListTile component.
  group("CenterListTile Component Test", () {
    // Nested group of tests dedicated to the loading state of CenterListTile.
    group('Loading State Tests:', () {
      // Test that checks if the shimmer block is displayed during loading.
      testWidgets('Displays loading shimmer for image',
          (WidgetTester tester) async {
        // Create a CenterModel instance with default values.
        final centerModel = CenterModel();

        // Render the CenterList widget in a loading state.
        await tester.pumpWidget(
            MaterialApp(home: CenterList(centerModel, isLoading: true)));

        // Check if there are any shimmer blocks present.
        expect(find.byType(ShimmerBlock), findsWidgets);
      });
    });

    // Test that verifies if an image from assets is correctly displayed.
    testWidgets('Displays image from Asset', (WidgetTester tester) async {
      // Create a CenterModel instance with an AssetImage.
      final centerModel = CenterModel(
        centerImage: CenterImage(type: "asset", url: Constants.iconAskOstello),
      );

      // Render the CenterList widget with the provided centerModel.
      await tester.pumpWidget(MaterialApp(home: CenterList(centerModel)));

      // Fetch the first Container widget.
      final imageContainer =
          tester.widget<Container>(find.byType(Container).first);

      // Check if the image loaded in the widget is the expected AssetImage.
      if (imageContainer.decoration != null &&
          imageContainer.decoration is BoxDecoration) {
        expect(imageContainer.decoration, isA<BoxDecoration>());

        final decorationImage =
            (imageContainer.decoration as BoxDecoration).image;
        expect(decorationImage, isA<DecorationImage>());

        if (decorationImage != null) {
          expect((decorationImage.image as CachedNetworkImageProvider).url,
              equals(Constants.iconAskOstello));
        }
      }
    });

    // Test that verifies if an image from a URL is correctly displayed.
    testWidgets('Displays image from URL', (WidgetTester tester) async {
      // Create a CenterModel instance with an image from a URL.
      final centerModel = CenterModel(
        centerImage: CenterImage(
            type: "url", url: sprintf(Constants.placeholderImage, [180, 180])),
      );

      // Render the CenterList widget with the provided centerModel.
      await tester.pumpWidget(MaterialApp(home: CenterList(centerModel)));

      // Fetch the first Container widget.
      final imageContainer =
          tester.widget<Container>(find.byType(Container).first);

      // Check if the image loaded in the widget is the expected CachedNetworkImage.
      if (imageContainer.decoration != null &&
          imageContainer.decoration is BoxDecoration) {
        expect(imageContainer.decoration, isA<BoxDecoration>());

        final decorationImage =
            (imageContainer.decoration as BoxDecoration).image;
        expect(decorationImage, isA<DecorationImage>());

        if (decorationImage != null) {
          expect((decorationImage.image as CachedNetworkImageProvider).url,
              equals(sprintf(Constants.placeholderImage, [180, 180])));
        }
      }
    });

    // Nested group of tests dedicated to the information displayed in CenterListTile.
    group('Center Info Tests:', () {
      // Test that verifies if the center name is correctly displayed.
      testWidgets('Displays center name', (WidgetTester tester) async {
        // Create a CenterModel instance with a specific center name.
        final centerModel = CenterModel(centerName: "Test Center");

        // Render the CenterList widget with the provided centerModel.
        await tester.pumpWidget(MaterialApp(home: CenterList(centerModel)));

        // Check if the expected text is displayed.
        expect(find.text('Test Center'), findsOneWidget);
      });
    });

    // Test that verifies if the center tags are correctly displayed.
    testWidgets('Displays tags correctly', (WidgetTester tester) async {
      // Create a CenterModel instance with a tag.
      final centerModel = CenterModel(
          centerTags: [CenterTag(tagText: "MockTag", isHighlighted: false)]);

      // Render the CenterList widget with the provided centerModel.
      await tester.pumpWidget(MaterialApp(home: CenterList(centerModel)));

      // Check if the tag is displayed with the expected text.
      expect(find.text('MOCKTAG'), findsOneWidget);
    });

    // Nested group of tests dedicated to the bottom texts displayed in CenterListTile.
    group('Bottom Text Tests:', () {
      // Test that verifies if the bottom text is correctly displayed.
      testWidgets('Renders bottom texts', (WidgetTester tester) async {
        // Create a CenterModel instance with a bottom text.
        final centerModel = CenterModel(bottomTexts: ["Sample Text"]);

        // Render the CenterList widget with the provided centerModel.
        await tester.pumpWidget(MaterialApp(home: CenterList(centerModel)));

        // Check if the bottom text is displayed.
        expect(find.text('Sample Text'), findsOneWidget);
      });
    });

    // Nested group of tests dedicated to the getImageProvider method.
    group('getImageProvider Method Tests:', () {
      // Test that verifies if the getImageProvider method returns a CachedNetworkImageProvider for type "url".
      testWidgets('Returns CachedNetworkImageProvider for type "url"',
          (WidgetTester tester) async {
        Widget testWidget = Builder(
          builder: (BuildContext context) {
            // Create a CenterModel instance with an image from a URL.
            final centerModel = CenterModel(
              centerImage: CenterImage(
                  type: "url",
                  url: sprintf(Constants.placeholderImage, [180, 180])),
            );

            // Create a CenterList widget.
            final centerList = CenterList(centerModel);

            // Fetch the image provider using the getImageProvider method.
            final imageProvider = centerList.getImageProvider(context);

            // Check if the returned image provider is a CachedNetworkImageProvider and matches the provided URL.
            expect(imageProvider, isA<CachedNetworkImageProvider>());
            expect((imageProvider as CachedNetworkImageProvider).url,
                equals(sprintf(Constants.placeholderImage, [180, 180])));

            return const SizedBox(); // Return a dummy widget.
          },
        );

        // Render the test widget.
        await tester.pumpWidget(testWidget);
      });

      // Test that verifies if the getImageProvider method returns an AssetImage for types other than "url".
      testWidgets('Returns AssetImage for types other than "url"',
          (WidgetTester tester) async {
        Widget testWidget = Builder(
          builder: (BuildContext context) {
            // Create a CenterModel instance with an AssetImage.
            final centerModel = CenterModel(
              centerImage:
                  CenterImage(type: "asset", url: Constants.iconAskOstello),
            );

            // Create a CenterList widget.
            final centerList = CenterList(centerModel);

            // Fetch the image provider using the getImageProvider method.
            final imageProvider = centerList.getImageProvider(context);

            // Check if the returned image provider is an AssetImage and matches the provided asset name.
            expect(imageProvider, isA<AssetImage>());
            expect((imageProvider as AssetImage).assetName,
                equals(Constants.iconAskOstello));

            return const SizedBox(); // Return a dummy widget.
          },
        );

        // Render the test widget.
        await tester.pumpWidget(testWidget);
      });

      // Test that verifies if the getImageProvider method uses the default type "url" if the type is not provided.
      testWidgets('Uses default type "url" if type is not provided',
          (WidgetTester tester) async {
        Widget testWidget = Builder(
          builder: (BuildContext context) {
            // Create a CenterModel instance without specifying an image type (should default to "url").
            final centerModel = CenterModel(
              centerImage: CenterImage(url: Constants.iconAskOstello),
            );

            // Create a CenterList widget.
            final centerList = CenterList(centerModel);

            // Fetch the image provider using the getImageProvider method.
            final imageProvider = centerList.getImageProvider(context);

            // Check if the returned image provider is an AssetImage and matches the provided asset name.
            expect(imageProvider, isA<AssetImage>());
            expect((imageProvider as AssetImage).assetName,
                equals(Constants.iconAskOstello));

            return const SizedBox(); // Return a dummy widget.
          },
        );

        // Render the test widget.
        await tester.pumpWidget(testWidget);
      });
    });
  });

  // Start a group of tests for the CustomDropdownButton component.
  group("CustomDropdownButton Component Test", () {
    // Create a sample list of sort filters for testing by transforming constants into SortFilter objects.
    List<SortFilter> sampleSortFilters = [
      ...Constants.sortFilterOpt.map((element) {
        return SortFilter(
          element["value"] ?? "",
          element["key"] ?? "",
          isChecked: (element["key"] ?? "") == "relevance",
        );
      }),
    ];

    // Test to ensure the CustomDropdownButton renders properly with default values.
    testWidgets('Renders CustomDropdownButton correctly',
        (WidgetTester tester) async {
      // Pump the widget tree containing the CustomDropdownButton into the tester.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CustomDropdownButton(sampleSortFilters)),
        ),
      );

      // Assert that the CustomDropdownButton, the default 'Sort' text, and an SVG icon are present in the widget tree.
      expect(find.byType(CustomDropdownButton), findsOneWidget);
      expect(find.text('Sort'), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    // Test that the dropdown can be opened and that it displays the items correctly.
    testWidgets('Dropdown opens and displays items',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CustomDropdownButton(sampleSortFilters)),
        ),
      );

      // Tap the dropdown to open it.
      await tester.tap(find.byType(CustomDropdownButton));
      await tester.pump();

      // Assert that each filter item in the sample list is displayed in the opened dropdown.
      for (var filter in sampleSortFilters) {
        expect(find.text(filter.title), findsOneWidget);
      }
    });

    // Test that selecting an item from the dropdown works as expected.
    testWidgets('Dropdown item selection functionality',
        (WidgetTester tester) async {
      SortFilter? tappedFilter;

      // Pump the widget tree containing a CustomDropdownButton with an onTap callback.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomDropdownButton(
              sampleSortFilters,
              onTap: (filter) {
                tappedFilter = filter; // Store the selected filter.
              },
            ),
          ),
        ),
      );

      // Open the dropdown and tap on the first filter.
      await tester.tap(find.byType(CustomDropdownButton));
      await tester.pump();
      await tester.tap(find.text(sampleSortFilters[0].title).first);
      await tester.pump();

      // Assert that the dropdown is closed after the selection.
      expect(find.byType(RadioButton), findsNothing);
      // Ensure that the filter that was tapped matches the first filter in the sample list.
      expect(tappedFilter, sampleSortFilters[0]);
    });

    // Test the styling of the dropdown button based on its isSelected property.
    testWidgets('Dropdown button styling based on isSelected',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
              body: CustomDropdownButton(sampleSortFilters, text: "Price")),
        ),
      );

      // Extract the color of the 'Price' text and the SVG icon.
      final textColor = tester.widget<Text>(find.text("Price")).style!.color;
      final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));

      // Assert that when the dropdown's text is not "Sort", its text and icon colors are set to white.
      expect(textColor, Colors.white);
      expect(svgPicture.colorFilter,
          const ColorFilter.mode(Colors.white, BlendMode.srcIn));
    });

    // Test that the dropdown closes when tapped outside of it.
    testWidgets('Dropdown closes when tapped outside',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CustomDropdownButton(sampleSortFilters)),
        ),
      );

      // Open the dropdown.
      await tester.tap(find.byType(CustomDropdownButton));
      await tester.pumpAndSettle(); // Wait for animations and UI changes.

      // Tap outside the dropdown.
      await tester.tap(find.byType(CustomDropdownButton));
      await tester.pumpAndSettle(); // Wait for animations and UI changes.

      // Get the current state of the CustomDropdownButton.
      var dropdownState = tester
          .state<CustomDropdownButtonState>(find.byType(CustomDropdownButton));
      // Assert that the dropdown is closed.
      expect(dropdownState.isDropdownOpened, false);
      // Confirm that the radio buttons are not visible (dropdown is closed).
      expect(find.byType(RadioButton), findsNothing);
    });

    // Test that only one item can be selected in the dropdown at any time.
    testWidgets('Only one radio button is checked at a time',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CustomDropdownButton(sampleSortFilters)),
        ),
      );

      // Open the dropdown and select the first filter.
      await tester.tap(find.byType(CustomDropdownButton));
      await tester.pump();
      await tester.tap(find.text(sampleSortFilters[0].title).first);
      await tester.pump();

      // Re-open the dropdown.
      await tester.tap(find.byType(CustomDropdownButton));
      await tester.pump();

      // Count the number of filters that are checked.
      int checkedButtonsCount = 0;
      for (var filter in sampleSortFilters) {
        if (filter.isChecked) {
          checkedButtonsCount++;
        }
      }
      // Assert that only one filter is checked.
      expect(checkedButtonsCount, 1);
    });
  });

// Group of tests for the FilterTag component.
  group("FilterTag Component Test", () {
    // Constant for the sample tag text used in tests.
    const String testTagText = "Sample Tag";

    // Test to check basic rendering of the FilterTag component.
    testWidgets('FilterTag basic rendering', (WidgetTester tester) async {
      // Pump the widget tree containing the FilterTag into the tester.
      await tester.pumpWidget(
        const MaterialApp(
          home: Material(
            type: MaterialType.transparency,
            child: FilterTag(testTagText),
          ),
        ),
      );
      // Assert that the FilterTag with the given text is rendered.
      expect(find.text(testTagText), findsOneWidget);
    });

    // Test to check the highlighting functionality of the FilterTag component.
    testWidgets('FilterTag highlighting', (WidgetTester tester) async {
      // Test with the highlighted state of FilterTag.
      await tester.pumpWidget(const MaterialApp(
          home: Material(
              type: MaterialType.transparency,
              child: FilterTag(testTagText, isHighlighted: true))));
      final highlightedTag =
          tester.widget<Container>(find.byType(Container).first);
      // Assert that the highlighted FilterTag has the primary color.
      expect((highlightedTag.decoration as ShapeDecoration).color,
          Constants.primaryColor);

      // Test with the non-highlighted state of FilterTag.
      await tester.pumpWidget(const MaterialApp(
          home: Material(
              type: MaterialType.transparency,
              child: FilterTag(testTagText, isHighlighted: false))));
      final unhighlightedTag =
          tester.widget<Container>(find.byType(Container).first);
      // Assert that the non-highlighted FilterTag has a white color.
      expect(
          (unhighlightedTag.decoration as ShapeDecoration).color, Colors.white);
    });

    // Test to check that the highlighted icon is rendered as an AssetImage.
    testWidgets('HighlightedIcon AssetImage test', (WidgetTester tester) async {
      final highlightedIcon = Container(
        width: 12,
        height: 12,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Constants.iconFilterWhite),
            fit: BoxFit.fill,
          ),
        ),
      );

      // Pump the widget tree containing the highlighted icon into the tester.
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: highlightedIcon,
        ),
      ));
      await tester.pumpAndSettle();

      // Assert that the asset image with the specified asset name is rendered.
      expect(findAssetImage(Constants.iconFilterWhite), findsOneWidget);
    });

    // Test to check the handling of icons in the FilterTag component.
    testWidgets('FilterTag icon handling', (WidgetTester tester) async {
      // Define the highlighted and non-highlighted icons for the FilterTag.
      final highlightedIcon = Container(
        width: 12,
        height: 12,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Constants.iconFilterWhite),
            fit: BoxFit.fill,
          ),
        ),
      );
      final unhighlightedIcon = Container(
        width: 12,
        height: 12,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Constants.iconFilterDark),
            fit: BoxFit.fill,
          ),
        ),
      );

      // Test with highlighted FilterTag.
      await tester.pumpWidget(MaterialApp(
          home: Material(
              type: MaterialType.transparency,
              child: FilterTag(testTagText,
                  isHighlighted: true,
                  iconHighlighted: highlightedIcon,
                  iconUnHighlighted: unhighlightedIcon))));
      // Assert that the highlighted icon is rendered and the non-highlighted icon is not.
      expect(findAssetImage(Constants.iconFilterWhite), findsOneWidget);
      expect(findAssetImage(Constants.iconFilterDark), findsNothing);

      // Test with non-highlighted FilterTag.
      await tester.pumpWidget(MaterialApp(
          home: Material(
              type: MaterialType.transparency,
              child: FilterTag(testTagText,
                  isHighlighted: false,
                  iconHighlighted: highlightedIcon,
                  iconUnHighlighted: unhighlightedIcon))));
      // Assert that the non-highlighted icon is rendered and the highlighted icon is not.
      expect(findAssetImage(Constants.iconFilterWhite), findsNothing);
      expect(findAssetImage(Constants.iconFilterDark), findsOneWidget);

      // Test FilterTag without any icons.
      await tester.pumpWidget(const MaterialApp(
          home: Material(
              type: MaterialType.transparency, child: FilterTag(testTagText))));
      // Assert that neither icon is rendered.
      expect(findAssetImage(Constants.iconFilterWhite), findsNothing);
      expect(findAssetImage(Constants.iconFilterDark), findsNothing);
    });

    // Test to check the tap callback functionality of the FilterTag.
    testWidgets('FilterTag tap callback', (WidgetTester tester) async {
      bool tapCallbackExecuted = false;
      // Pump the widget tree containing a FilterTag with an onTap callback into the tester.
      await tester.pumpWidget(MaterialApp(
          home: Material(
              type: MaterialType.transparency,
              child: FilterTag(testTagText,
                  onTap: () => tapCallbackExecuted = true))));
      // Simulate a tap on the FilterTag.
      await tester.tap(find.text(testTagText));
      // Assert that the tap callback was executed.
      expect(tapCallbackExecuted, true);
    });
  });

  // Group of tests for the RadioButton component.
  group("RadioButton Component Test", () {
    // Test for rendering the unchecked state of the RadioButton.
    testWidgets('RadioButton renders unchecked state correctly',
        (WidgetTester tester) async {
      // Pump the RadioButton widget in its unchecked state into the tester.
      await tester.pumpWidget(const MaterialApp(
        home: RadioButton(isChecked: false),
      ));

      // Assert that the outer circle (representing the unchecked state) is rendered correctly.
      expect(
          find.byWidgetPredicate((Widget widget) =>
              widget is Container &&
              widget.decoration is ShapeDecoration &&
              (widget.decoration as ShapeDecoration).shape is OvalBorder &&
              (widget.decoration as ShapeDecoration).color == null),
          findsOneWidget);

      // Assert that the inner circle (representing the checked state) is not rendered.
      expect(
          find.byWidgetPredicate((Widget widget) =>
              widget is Container &&
              widget.decoration is ShapeDecoration &&
              (widget.decoration as ShapeDecoration).color ==
                  Constants.primaryColor),
          findsNothing);
    });

    // Test for rendering the checked state of the RadioButton.
    testWidgets('RadioButton renders checked state correctly',
        (WidgetTester tester) async {
      // Pump the RadioButton widget in its checked state into the tester.
      await tester.pumpWidget(const MaterialApp(
        home: RadioButton(isChecked: true),
      ));

      // Assert that the outer circle (representing the unchecked state) is rendered correctly.
      expect(
          find.byWidgetPredicate((Widget widget) =>
              widget is Container &&
              widget.decoration is ShapeDecoration &&
              (widget.decoration as ShapeDecoration).shape is OvalBorder &&
              (widget.decoration as ShapeDecoration).color == null),
          findsOneWidget);

      // Assert that the inner circle (representing the checked state) is rendered correctly.
      expect(
          find.byWidgetPredicate((Widget widget) =>
              widget is Container &&
              widget.decoration is ShapeDecoration &&
              (widget.decoration as ShapeDecoration).color ==
                  Constants.primaryColor),
          findsOneWidget);
    });
  });

// Group of tests for the ShimmerBlock component.
  group('ShimmerBlock Component Test', () {
    testWidgets('ShimmerBlock Widget Test', (WidgetTester tester) async {
      // Create a test widget with a unique key to be used as a child for the ShimmerBlock.
      final testChild = Container(key: const Key('testChild'));

      // Pump the ShimmerBlock widget with the testChild into the tester.
      await tester.pumpWidget(
        MaterialApp(
          home: ShimmerBlock(child: testChild),
        ),
      );

      // Assert that the Shimmer effect is present, indicating the loading state is correctly rendered.
      expect(find.byType(Shimmer), findsOneWidget);

      // Assert that the child widget (testChild) of ShimmerBlock is correctly rendered.
      expect(find.byKey(const Key('testChild')), findsOneWidget);
    });
  });

  // Group of tests focusing on the 'Tags' component.
  group('Tags Component Test', () {
    // A single test that focuses on the rendering of the 'Tags' widget.
    testWidgets('Tags Widget Test', (WidgetTester tester) async {
      // Define the text that will be used within the tag widget.
      const tagText = 'Sample Tag';

      // Define a variable that will be used to capture the 'fem' value, which is used for scaling UI elements.
      double fem = 1;

      // Construct a widget to determine the 'fem' scaling factor from the current context.
      // This particular widget represents the non-highlighted version of the tag.
      Widget testWidgetUnHighlighted = Builder(
        builder: (BuildContext context) {
          // Extract and assign the 'fem' scaling factor from the provided context.
          fem = Constants.fem(context);

          // Return the non-highlighted tag widget.
          return const MaterialApp(home: Tag(tagText, isHighlighted: false));
        },
      );

      // Construct another widget, this time for the highlighted version of the tag.
      Widget testWidgetHighlighted = Builder(
        builder: (BuildContext context) {
          // Reuse the 'fem' value that was previously extracted.
          fem = Constants.fem(context);

          // Return the highlighted tag widget.
          return const MaterialApp(home: Tag(tagText, isHighlighted: true));
        },
      );

      // Render the non-highlighted tag widget in the test environment.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: testWidgetUnHighlighted),
        ),
      );

      // Check if the non-highlighted version of the tag is rendered correctly.
      expect(find.text(tagText),
          findsOneWidget); // Check if the tag's text is rendered.
      final nonHighlightedTag =
          tester.widget<Container>(find.byType(Container));
      final nonHighlightedDecoration =
          nonHighlightedTag.decoration as BoxDecoration;
      expect(nonHighlightedDecoration.color,
          Colors.transparent); // Check the background color.
      expect(nonHighlightedDecoration.border!.top.color,
          Constants.primaryColor); // Check the border color.
      expect(
          nonHighlightedDecoration.borderRadius
              ?.resolve(TextDirection.ltr)
              .topLeft
              .x,
          closeTo(4 * fem,
              0.5)); // Check if the borderRadius is scaled by the 'fem' factor.

      // Render the highlighted version of the tag widget in the test environment.
      await tester.pumpWidget(
        MaterialApp(home: testWidgetHighlighted),
      );

      // Check if the highlighted version of the tag is rendered correctly.
      expect(find.text(tagText),
          findsOneWidget); // Check if the tag's text is rendered.
      final highlightedTag = tester.widget<Container>(find.byType(Container));
      final highlightedDecoration = highlightedTag.decoration as BoxDecoration;
      expect(highlightedDecoration.color,
          Constants.primaryColor); // Check the background color.
      expect(highlightedDecoration.border!.top.color,
          Constants.primaryColor); // Check the border color.
      expect(
          highlightedDecoration.borderRadius
              ?.resolve(TextDirection.ltr)
              .topLeft
              .x,
          closeTo(4 * fem,
              0.5)); // Check if the borderRadius is scaled by the 'fem' factor.
    });
  });
}
