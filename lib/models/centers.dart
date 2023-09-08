import 'package:ostello/utils.dart';

class CenterModel {
  CenterImage? centerImage;
  String centerLocation;
  String centerName;
  String centerRating = "";
  String centerDistance = "";
  List<CenterTag>? centerTags;
  List<String>? bottomTexts;

  CenterModel({
    this.centerImage,
    this.centerLocation = "",
    this.centerName = "",
    double centerRating = 0,
    int centerDistance = 0,
    List<CenterTag>? centerTags,
    List<String>? bottomTexts,
  }) {
    this.centerRating = formatDouble(centerRating);
    this.centerDistance = reduceLargeNumber(centerDistance / 1000.0);
    this.centerTags = centerTags ?? [];
    this.bottomTexts = bottomTexts ?? [];
  }
}

class CenterImage {
  String type;
  final String url;

  CenterImage({
    this.type = "asset",
    required this.url,
  });
}

class CenterTag {
  String tagText = "";
  bool isHighlighted;

  CenterTag({
    String tagText = "",
    this.isHighlighted = false,
  }) {
    this.tagText = tagText.toUpperCase();
  }
}
