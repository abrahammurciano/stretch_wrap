import 'package:flutter/material.dart';
import 'package:stretch_wrap/stretch_wrap.dart';

import '../utils/color_box.dart';

class MixedContentExample extends StatelessWidget {
  const MixedContentExample({super.key});

  @override
  Widget build(BuildContext context) {
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
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
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
