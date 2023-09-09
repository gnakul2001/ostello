// Class to represent a coaching center's data model.
class CenterModel {
  // Image related to the center.
  CenterImage? centerImage;

  // Geographical location of the center.
  String? centerLocation;

  // Name of the coaching center.
  String? centerName;

  // Rating for the coaching center out of 5.
  double centerRating;

  // Distance of the center from a center location.
  int centerDistance;

  // Discount percentage or value offered by the center.
  double centerDiscount;

  // List of tags associated with the center.
  List<CenterTag>? centerTags;

  // Additional textual details related to the center.
  List<String>? bottomTexts;

  CenterModel({
    this.centerImage,
    this.centerLocation = "",
    this.centerName = "",
    this.centerRating = 0,
    this.centerDistance = 0,
    this.centerDiscount = 0,
    List<CenterTag>? centerTags,
    List<String>? bottomTexts,
  }) {
    this.centerTags = centerTags ?? [];
    this.bottomTexts = bottomTexts ?? [];
  }
}

// Class representing the image details of a coaching center.
class CenterImage {
  // Type of image, it could be an 'asset' or 'url' image.
  String type;

  // The URL or path of the image.
  final String url;

  CenterImage({
    this.type = "asset",
    required this.url,
  });
}

// Class representing a tag associated with a coaching center.
class CenterTag {
  // Text of the tag.
  String tagText = "";

  // Boolean to check if the tag is highlighted in the UI.
  bool isHighlighted;

  CenterTag({
    String tagText = "",
    this.isHighlighted = false,
  }) {
    // Convert tag text to uppercase for standard presentation.
    this.tagText = tagText.toUpperCase();
  }
}
