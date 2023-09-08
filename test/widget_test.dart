// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:ostello/components/ask_ostello.dart';
import 'package:ostello/components/shimmer.dart';
import 'package:ostello/components/tags.dart';
import 'package:ostello/constants/constants.dart';
import 'package:ostello/dio_client.dart';
import 'package:ostello/models/centers.dart';

import 'package:shimmer/shimmer.dart';

void main() {
  setUpAll(() {
    // Create a constant for the method channel associated with 'path_provider'.
    const channel = MethodChannel('plugins.flutter.io/path_provider');

    // Set a mock handler for method calls on the specified channel.
    // This prevents actual method calls to the platform and returns a dummy value instead.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return ".";
    });
  });

  testWidgets('ShimmerBlock Widget Test', (WidgetTester tester) async {
    // Initialize a test container widget with a unique key to be used as the child of ShimmerBlock.
    final testChild = Container(key: const Key('testChild'));

    // Render the ShimmerBlock widget within a MaterialApp for context dependencies and pass the testChild as its child.
    await tester.pumpWidget(
      MaterialApp(
        home: ShimmerBlock(child: testChild),
      ),
    );

    // Assert that the Shimmer effect (Shimmer widget) is correctly present in the widget tree.
    expect(find.byType(Shimmer), findsOneWidget);

    // Assert that the testChild (identified by its unique key) is correctly rendered within the ShimmerBlock.
    expect(find.byKey(const Key('testChild')), findsOneWidget);
  });

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

  testWidgets('Tags Widget Test', (WidgetTester tester) async {
    // The text that will be used for the tag widget.
    const tagText = 'Sample Tag';

    // Initialize a variable to capture the 'fem' value for scaling.
    double fem = 1;

    // Construct a widget to derive the 'fem' scaling factor from the current context.
    // This widget is for the non-highlighted version of the tag.
    Widget testWidgetUnHighlighted = Builder(
      builder: (BuildContext context) {
        // Extract the 'fem' value from the provided context.
        fem = Constants.fem(context);

        // Instantiate and return the non-highlighted tag widget.
        return const MaterialApp(home: Tag(tagText, isHighlighted: false));
      },
    );

    // Construct a widget for the highlighted version of the tag.
    Widget testWidgetHighlighted = Builder(
      builder: (BuildContext context) {
        // The 'fem' value is re-used from the previous context extraction.
        fem = Constants.fem(context);

        // Instantiate and return the highlighted tag widget.
        return const MaterialApp(home: Tag(tagText, isHighlighted: true));
      },
    );

    // Render the non-highlighted tag widget.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: testWidgetUnHighlighted),
      ),
    );

    // Validate that the non-highlighted version of the tag is displayed.
    expect(find.text(tagText), findsOneWidget);
    final nonHighlightedTag = tester.widget<Container>(find.byType(Container));
    final nonHighlightedDecoration =
        nonHighlightedTag.decoration as BoxDecoration;
    expect(nonHighlightedDecoration.color, Colors.transparent);
    expect(nonHighlightedDecoration.border!.top.color, Constants.primaryColor);
    expect(
        nonHighlightedDecoration.borderRadius
            ?.resolve(TextDirection.ltr)
            .topLeft
            .x,
        closeTo(4 * fem, 0.5));

    // Render the highlighted tag widget.
    await tester.pumpWidget(
      MaterialApp(home: testWidgetHighlighted),
    );
    // Validate that the highlighted version of the tag is displayed.
    expect(find.text(tagText), findsOneWidget);
    final highlightedTag = tester.widget<Container>(find.byType(Container));
    final highlightedDecoration = highlightedTag.decoration as BoxDecoration;
    expect(highlightedDecoration.color, Constants.primaryColor);
    expect(highlightedDecoration.border!.top.color, Constants.primaryColor);
    expect(
        highlightedDecoration.borderRadius
            ?.resolve(TextDirection.ltr)
            .topLeft
            .x,
        closeTo(4 * fem, 0.5));
  });

  // Commence the testing group for various components related to Centers.
  group("Centers Tests", () {
    // Define the testing group specifically for the CenterModel component.
    group('CenterModel Tests', () {
      // Test to validate the default values assigned during the instantiation of CenterModel.
      test('Default values test', () {
        final center = CenterModel();

        expect(center.centerLocation, "");
        expect(center.centerName, "");
        expect(center.centerRating, "0");
        expect(center.centerDistance, "0 ");
        expect(center.centerTags, []);
        expect(center.bottomTexts, []);
      });

      // Test to validate the processing of parameters post-construction of the CenterModel.
      test('Post-construction processing test', () {
        final center = CenterModel(centerRating: 4.5, centerDistance: 1200);

        expect(center.centerRating, "4.5");
        // Confirm the transformation of the distance value post-construction.
        expect(center.centerDistance,
            "1.2 "); // This assumes the reduceLargeNumber function transforms 1200 to 1.2.
      });
    });

    // Define the testing group specifically for the CenterImage component.
    group('CenterImage Tests', () {
      // Test to validate the properties of CenterImage upon instantiation.
      test('Properties test', () {
        final centerImage = CenterImage(url: 'test_url');

        expect(centerImage.type,
            "asset"); // Confirm the default type is set to "asset".
        expect(centerImage.url, "test_url"); // Validate the URL assignment.
      });
    });

    // Define the testing group specifically for the CenterTag component.
    group('CenterTag Tests', () {
      // Test to validate the properties and transformations within the CenterTag component.
      test('Properties and transformation test', () {
        final centerTag = CenterTag(tagText: 'testTag');

        expect(centerTag.tagText,
            "TESTTAG"); // Confirm the text transformation to uppercase.
        expect(centerTag.isHighlighted,
            false); // Validate the default highlighted state.
      });
    });
  });

  // Initiate a group of tests dedicated to the DioClient functionalities.
  group('DioClient Tests', () {
    // Instantiate the Dio object to be used for testing.
    final dio = Dio();
    // Create an instance of DioAdapter to mock Dio's behavior.
    final dioAdapter = DioAdapter(dio: dio);
    // Instantiate the DioClient with caching disabled for testing purposes.
    final dioClient = DioClient(dio: dio, enableCache: false);

    // Test the behavior of the GET method in the DioClient.
    test('GET method test', () async {
      const testUrl = 'https://testapi.com/get';
      const mockResponseData = {'key': 'value'};

      // Setup a mock GET request for the given URL.
      dioAdapter.onGet(
        testUrl,
        (request) => request.reply(200, mockResponseData),
        headers: {},
      );

      // Invoke the GET method on the DioClient and check if the response matches the mock data.
      final response = await dioClient.get(testUrl);
      expect(response.data, mockResponseData);
    });

    // Test the behavior of the POST method in the DioClient.
    test('POST method test', () async {
      const testUrl = 'https://testapi.com/post';
      const mockRequestData = {'key': 'value'};
      const mockResponseData = {'success': true};

      // Setup a mock POST request for the given URL.
      dioAdapter.onPost(
        testUrl,
        (request) => request.reply(200, mockResponseData),
        headers: {},
        data: mockRequestData,
      );

      // Invoke the POST method on the DioClient and check if the response matches the mock data.
      final response = await dioClient.post(testUrl, data: mockRequestData);
      expect(response.data, mockResponseData);
    });

    // Test the caching behavior of the DioClient.
    test('Cache test', () async {
      const testUrl = 'https://testapi.com/cache';
      const mockResponseData = {'key': 'value'};

      // Setup a mock GET request for the given URL to test caching.
      dioAdapter.onGet(
        testUrl,
        (request) => request.reply(200, mockResponseData),
        headers: {},
      );

      // Invoke the GET method twice on the DioClient and check if the responses are consistent (testing caching).
      final firstResponse = await dioClient.get(testUrl);
      expect(firstResponse.data, mockResponseData);
      final secondResponse = await dioClient.get(testUrl);
      expect(secondResponse.data, mockResponseData);
    });

    // Test the error-handling behavior of the DioClient.
    test('Error handling test', () async {
      const testUrl = 'https://testapi.com/error';
      const errorMessage = 'An error occurred!';

      // Setup a mock GET request for the given URL to throw a specific error.
      dioAdapter.onGet(
        testUrl,
        (request) => request.throws(
            500,
            DioException(
                message: errorMessage,
                requestOptions: RequestOptions(path: testUrl))),
        headers: {},
      );

      // Invoke the GET method on the DioClient and check if the expected error is thrown.
      try {
        await dioClient.get(testUrl);
      } catch (e) {
        expect(e, isInstanceOf<DioException>());
      }
    });
  });
}
