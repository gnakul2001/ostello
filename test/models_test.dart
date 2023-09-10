// Import required libraries for testing and the specific component under test.
import 'package:flutter_test/flutter_test.dart';
import 'package:ostello/models/centers.dart';

void main() {
  // Group of tests related to the 'Centers' components.
  group("Centers Tests", () {
    // Sub-group of tests specific to the CenterModel.
    group('CenterModel Tests', () {
      // Test to validate the default values of the CenterModel.
      test('Default values are set correctly', () {
        final center = CenterModel();

        // Assert the default values for each property of the CenterModel.
        expect(center.id, null);
        expect(center.centerLocation, "");
        expect(center.centerName, "");
        expect(center.centerRating, 0);
        expect(center.centerDistance, 0);
        expect(center.centerDiscount, 0);
        expect(center.centerTags, []);
        expect(center.bottomTexts, []);
      });

      // Test to validate that provided values are correctly assigned to the CenterModel.
      test('Provided values are set correctly', () {
        final tags = [CenterTag(tagText: "JEE")];
        final center = CenterModel(
          centerLocation: "Mumbai",
          centerName: "UniqueCenter",
          centerRating: 4.5,
          centerDistance: 1000,
          centerDiscount: 10,
          centerTags: tags,
        );

        // Assert the provided values for each property of the CenterModel.
        expect(center.centerLocation, "Mumbai");
        expect(center.centerName, "UniqueCenter");
        expect(center.centerRating, 4.5);
        expect(center.centerDistance, 1000);
        expect(center.centerDiscount, 10);
        expect(center.centerTags, tags);
      });
    });

    // Sub-group of tests specific to the CenterImage model.
    group('CenterImage Tests', () {
      // Test to validate the default values of the CenterImage model.
      test('Default values are set correctly', () {
        final image = CenterImage(url: "sample_url.png");

        // Assert the default values for each property of the CenterImage.
        expect(image.type, "asset");
        expect(image.url, "sample_url.png");
      });

      // Test to validate that provided values can override default values in the CenterImage model.
      test('Provided values override defaults', () {
        final image = CenterImage(url: "sample_url.png", type: "url");

        // Assert the provided values for each property of the CenterImage.
        expect(image.type, "url");
        expect(image.url, "sample_url.png");
      });
    });

    // Sub-group of tests specific to the CenterTag model.
    group('CenterTag Tests', () {
      // Test to validate the default values of the CenterTag model.
      test('Default values are set correctly', () {
        final tag = CenterTag();

        // Assert the default values for each property of the CenterTag.
        expect(tag.tagText, "");
        expect(tag.isHighlighted, false);
      });

      // Test to ensure the tag text is always converted to uppercase.
      test('Tag text is converted to uppercase', () {
        final tag = CenterTag(tagText: "jee");

        // Assert that the tag text is correctly converted to uppercase.
        expect(tag.tagText, "JEE");
      });

      // Test to validate that provided values can override default values in the CenterTag model.
      test('Provided values override defaults', () {
        final tag = CenterTag(tagText: "JEE", isHighlighted: true);

        // Assert the provided values for each property of the CenterTag.
        expect(tag.tagText, "JEE");
        expect(tag.isHighlighted, true);
      });
    });
  });
}
