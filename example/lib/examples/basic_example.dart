import 'package:flutter/material.dart';
import 'package:stretch_wrap/stretch_wrap.dart';

import '../utils/blueprint_container.dart';
import '../utils/color_box.dart';

class BasicExample extends StatelessWidget {
  const BasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BlueprintContainer(
      width: 400,
      child: const StretchWrap(
        spacing: 8,
        children: [
          ColorBox(color: Colors.red, width: 100, text: '100'),
          Stretch(child: ColorBox(color: Colors.blue, width: 0, text: '0, stretch')),
          ColorBox(color: Colors.green, width: 80, text: '80'),
        ],
      ),
    );
  }
}
