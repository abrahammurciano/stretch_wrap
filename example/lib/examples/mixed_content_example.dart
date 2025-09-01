import 'package:flutter/material.dart';
import 'package:stretch_wrap/stretch_wrap.dart';

import '../utils/blueprint_container.dart';
import '../utils/color_box.dart';

class MixedContentExample extends StatelessWidget {
  const MixedContentExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlueprintContainer(width: 650, child: _buildStretchWrap()),
        const SizedBox(height: 16),
        BlueprintContainer(width: 1000, child: _buildStretchWrap()),
      ],
    );
  }

  StretchWrap _buildStretchWrap() {
    return StretchWrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ElevatedButton(onPressed: () {}, child: const Text('Button')),
        const Stretch(
          child: SizedBox(
            width: 200,
            child: TextField(decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Search')),
          ),
        ),
        const ColorBox(color: Colors.amber, width: 80, text: '80'),
        const Stretch(
          flex: 2,
          child: SizedBox(
            width: 400,
            child: TextField(decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Notes')),
          ),
        ),
      ],
    );
  }
}
