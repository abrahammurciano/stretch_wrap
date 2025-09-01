import 'package:flutter/material.dart';

/// A container with a blueprint-style width indicator above it.
/// Shows a horizontal line with the width measurement centered on it,
/// similar to architectural blueprints.
class BlueprintContainer extends StatelessWidget {
  final double width;
  final Widget child;
  final Color borderColor;
  final double borderWidth;
  final Color indicatorColor;

  const BlueprintContainer({
    super.key,
    required this.width,
    required this.child,
    this.borderColor = Colors.blue,
    this.borderWidth = 2.0,
    this.indicatorColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizeMarker(width: width, color: borderColor, thickness: borderWidth),
        DecoratedBox(
          decoration: BoxDecoration(border: Border.all(color: borderColor, width: borderWidth)),
          child: SizedBox(
            width: width + (borderWidth * 2),
            child: Padding(padding: EdgeInsets.all(borderWidth), child: child),
          ),
        ),
      ],
    );
  }
}

class SizeMarker extends StatelessWidget {
  final double width;
  final Color color;
  final double thickness;
  final double endHeight;

  const SizeMarker({
    required this.width,
    this.color = Colors.blue,
    this.thickness = 2.0,
    this.endHeight = 8.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width + (thickness * 2),
      height: 24,
      child: Row(
        children: [
          Container(width: thickness, height: endHeight, color: color),
          Expanded(child: Container(height: thickness, color: color)),
          Text(" ${width.toInt()}px ", style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          Expanded(child: Container(height: thickness, color: color)),
          Container(width: thickness, height: endHeight, color: color),
        ],
      ),
    );
  }
}
