// Import the required libraries for testing and the specific component under test.
import 'package:flutter_test/flutter_test.dart';
import 'package:ostello/filters/sort_filter.dart';

void main() {
  // Group of tests related to the functionalities of the SortFilter.

  group('SortFilter Tests', () {
    // Test to validate the correct initialization of the SortFilter.
    test('Initialization', () {
      // Create a SortFilter instance with a title and key.
      final filter = SortFilter('Distance', 'distance');

      // Assert that the title and key of the filter are initialized correctly.
      expect(filter.title, 'Distance');
      expect(filter.key, 'distance');
    });

    // Test to ensure the default checked value of the SortFilter is false.
    test('Default Checked Value', () {
      // Create a SortFilter instance without specifying the isChecked parameter.
      final filter = SortFilter('Distance', 'distance');

      // Assert that the default value of isChecked is false.
      expect(filter.isChecked, false);
    });

    // Test to validate the setting of the checked value in the SortFilter.
    test('Set Checked Value', () {
      // Create a SortFilter instance and set isChecked to true.
      final filter = SortFilter('Distance', 'distance', isChecked: true);

      // Assert that isChecked was set to true.
      expect(filter.isChecked, true);
    });
  });
}
