import 'package:flutter/material.dart';
import 'package:stretch_wrap/stretch_wrap.dart';

import '../utils/blueprint_container.dart';
import '../utils/color_box.dart';

class CrossAxisAlignmentExample extends StatelessWidget {
  const CrossAxisAlignmentExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExample(
          'Cross Axis Alignment - start',
          WrapCrossAlignment.start,
          [
            ColorBox(color: Colors.red, width: 200, height: 30, text: '200w 30h'),
            ColorBox(color: Colors.blue, width: 250, height: 60, text: '250w 60h'),
            ColorBox(color: Colors.green, width: 120, height: 40, text: '120w 40h'),
            ColorBox(color: Colors.orange, width: 200, height: 20, text: '200w 20h'),
          ],
        ),
        const SizedBox(height: 24),
        _buildExample(
          'Cross Axis Alignment - center',
          WrapCrossAlignment.center,
          [
            ColorBox(color: Colors.indigo, width: 200, height: 45, text: '200w 45h'),
            Stretch(
              flex: 1,
              child: ColorBox(color: Colors.pink, width: 0, height: 25, text: 'Flex 1, 0w 25h'),
            ),
            Stretch(
              flex: 2,
              child: ColorBox(color: Colors.teal, width: 0, height: 65, text: 'Flex 2, 0w 65h'),
            ),
            ColorBox(color: Colors.lime, width: 100, height: 30, text: '100w 30h'),
          ],
        ),
        const SizedBox(height: 24),
        _buildExample(
          'Cross Axis Alignment - end',
          WrapCrossAlignment.end,
          [
            ColorBox(color: Colors.purple, width: 150, height: 50, text: '150w 50h'),
            Stretch(
              child: ColorBox(color: Colors.cyan, width: 0, height: 70, text: 'Stretch\n0w 70h'),
            ),
            ColorBox(color: Colors.amber, width: 200, height: 35, text: '200w 35h'),
          ],
        ),
      ],
    );
  }

  Widget _buildExample(String title, WrapCrossAlignment alignment, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ),
        BlueprintContainer(
          width: 650,
          child: StretchWrap(
            spacing: 8,
            runSpacing: 10,
            crossAxisAlignment: alignment,
            children: children,
          ),
        ),
      ],
    );
  }
}
