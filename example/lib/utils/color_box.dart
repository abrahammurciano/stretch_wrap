import 'package:flutter/material.dart';

class ColorBox extends StatelessWidget {
  final Color color;
  final double width;
  final String text;

  const ColorBox({super.key, required this.color, required this.width, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white),
        ),
      ),
    );
  }
}
