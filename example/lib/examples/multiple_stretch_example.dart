import 'package:flutter/material.dart';
import 'package:stretch_wrap/stretch_wrap.dart';

import '../utils/blueprint_container.dart';
import '../utils/color_box.dart';

class MultipleStretchExample extends StatelessWidget {
  const MultipleStretchExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BlueprintContainer(
      width: 650,
      child: const StretchWrap(
        spacing: 8,
        children: [
          ColorBox(color: Colors.red, width: 60, text: '60'),
          Stretch(child: ColorBox(color: Colors.blue, width: 0, text: '0, stretch 1')),
          Stretch(flex: 3, child: ColorBox(color: Colors.purple, width: 0, text: '0, stretch 3')),
          Stretch(flex: 2, child: ColorBox(color: Colors.green, width: 0, text: '0, stretch 2')),
        ],
      ),
    );
  }
}
