// Class to represent a sorting filter option.
class SortFilter {
  // Display title of the sorting filter.
  final String title;

  // Unique key identifier for the sorting filter.
  // This could be used for comparison or to determine which filter is selected.
  final String key;

  // Boolean flag to indicate if the filter is currently selected/checked in the UI.
  bool isChecked;

  SortFilter(
    this.title,
    this.key, {
    // Default value for isChecked is set to false, indicating it's not selected initially.
    this.isChecked = false,
  });
}
