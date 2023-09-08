// Importing necessary Flutter packages.
import 'package:flutter/material.dart';
// Importing the Shimmer package which provides the shimmer effect.
import 'package:shimmer/shimmer.dart';

// A custom widget named ShimmerBlock that provides a shimmer effect to its child.
class ShimmerBlock extends StatelessWidget {
  // The child widget to which the shimmer effect will be applied.
  final Widget child;

  // Constructor for the ShimmerBlock widget.
  // It requires a child widget to be passed when this widget is instantiated.
  const ShimmerBlock({
    super.key, // Initializing the key for the widget (if any).
    required this.child, // This child is required to be passed.
  });

  // Overriding the build method to provide our widget implementation.
  @override
  Widget build(BuildContext context) {
    // Returning a Shimmer widget that applies shimmer effect to its child.
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, // The primary/base color for the shimmer.
      highlightColor: Colors.grey[100]!, // The highlight color for the shimmer.
      child: child, // The child widget to which the shimmer effect is applied.
    );
  }
}
