import 'package:flutter/material.dart';
import 'package:stretch_wrap/stretch_wrap.dart';

import '../utils/color_box.dart';

class MultipleRowsExample extends StatelessWidget {
  const MultipleRowsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const StretchWrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ColorBox(color: Colors.pinkAccent, width: 400, text: '400'),
        ColorBox(color: Colors.red, width: 200, text: '200'),
        Stretch(child: ColorBox(color: Colors.blue, width: 100, text: '100, stretch 1')),
        ColorBox(color: Colors.green, width: 300, text: '300'),
        ColorBox(color: Colors.yellow, width: 200, text: '200'),
        Stretch(flex: 1, child: ColorBox(color: Colors.purple, width: 100, text: '100, stretch 1')),
        ColorBox(color: Colors.orange, width: 150, text: '150'),
        Stretch(child: ColorBox(color: Colors.teal, width: 0, text: '0, stretch 1')),
      ],
    );
  }
}
