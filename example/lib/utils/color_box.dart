import 'package:flutter/material.dart';

class ColorBox extends StatelessWidget {
  final Color color;
  final double width;
  final double height;
  final String text;

  const ColorBox({super.key, required this.color, required this.width, this.height = 50, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white),
        ),
      ),
    );
  }
}
