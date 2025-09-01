import 'package:flutter/material.dart';
import 'package:stretch_wrap/stretch_wrap.dart';

import '../utils/blueprint_container.dart';
import '../utils/color_box.dart';

class AlignmentAndAutoStretchExample extends StatelessWidget {
  const AlignmentAndAutoStretchExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('RunAlignment.start (default)'),
        const SizedBox(height: 8),
        BlueprintContainer(
          width: 650,
          child: const StretchWrap(
            spacing: 8,
            alignment: RunAlignment.start,
            children: [
              ColorBox(color: Colors.pink, width: 500, text: '500'),
              ColorBox(color: Colors.red, width: 100, text: '100'),
              ColorBox(color: Colors.green, width: 100, text: '100'),
              ColorBox(color: Colors.orange, width: 100, text: '100'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('RunAlignment.center'),
        const SizedBox(height: 8),
        BlueprintContainer(
          width: 650,
          child: const StretchWrap(
            spacing: 8,
            alignment: RunAlignment.center,
            children: [
              ColorBox(color: Colors.pink, width: 500, text: '500'),
              ColorBox(color: Colors.red, width: 100, text: '100'),
              ColorBox(color: Colors.green, width: 100, text: '100'),
              ColorBox(color: Colors.orange, width: 100, text: '100'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('RunAlignment.end'),
        const SizedBox(height: 8),
        BlueprintContainer(
          width: 650,
          child: const StretchWrap(
            spacing: 8,
            alignment: RunAlignment.end,
            children: [
              ColorBox(color: Colors.pink, width: 500, text: '500'),
              ColorBox(color: Colors.red, width: 100, text: '100'),
              ColorBox(color: Colors.green, width: 100, text: '100'),
              ColorBox(color: Colors.orange, width: 100, text: '100'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('RunAlignment.spaceBetween'),
        const SizedBox(height: 8),
        BlueprintContainer(
          width: 650,
          child: const StretchWrap(
            spacing: 8,
            alignment: RunAlignment.spaceBetween,
            children: [
              ColorBox(color: Colors.pink, width: 500, text: '500'),
              ColorBox(color: Colors.red, width: 100, text: '100'),
              ColorBox(color: Colors.green, width: 100, text: '100'),
              ColorBox(color: Colors.orange, width: 100, text: '100'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('RunAlignment.spaceAround'),
        const SizedBox(height: 8),
        BlueprintContainer(
          width: 650,
          child: const StretchWrap(
            spacing: 8,
            alignment: RunAlignment.spaceAround,
            children: [
              ColorBox(color: Colors.pink, width: 500, text: '500'),
              ColorBox(color: Colors.red, width: 100, text: '100'),
              ColorBox(color: Colors.green, width: 100, text: '100'),
              ColorBox(color: Colors.orange, width: 100, text: '100'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text('AutoStretch.explicit (default - only explicit Stretch widgets)'),
        const SizedBox(height: 8),
        BlueprintContainer(
          width: 450,
          child: const StretchWrap(
            spacing: 8,
            autoStretch: AutoStretch.explicit,
            children: [
              ColorBox(color: Colors.pink, width: 200, text: '200'),
              ColorBox(color: Colors.red, width: 100, text: '100'),
              Stretch(child: ColorBox(color: Colors.blue, width: 10, text: 'stretch')),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('AutoStretch.all (all children stretch)'),
        const SizedBox(height: 8),
        BlueprintContainer(
          width: 450,
          child: const StretchWrap(
            spacing: 8,
            autoStretch: AutoStretch.all,
            children: [
              ColorBox(color: Colors.pink, width: 200, text: '200'),
              ColorBox(color: Colors.red, width: 100, text: '100'),
              ColorBox(color: Colors.green, width: 50, text: '50'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('AutoStretch.exceptLastRun (all runs except last stretch)'),
        const SizedBox(height: 8),
        BlueprintContainer(
          width: 650,
          child: const StretchWrap(
            spacing: 8,
            runSpacing: 8,
            autoStretch: AutoStretch.exceptLastRun,
            children: [
              ColorBox(color: Colors.pink, width: 500, text: '500 - stretches'),
              ColorBox(color: Colors.red, width: 100, text: '100 - stretches'),
              ColorBox(color: Colors.green, width: 100, text: '100 - stretches'),
              ColorBox(color: Colors.orange, width: 100, text: '100 - no stretch'),
              ColorBox(color: Colors.purple, width: 80, text: '80 - no stretch'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('AutoStretch.exceptLastRun + RunAlignment.center (last run centered)'),
        const SizedBox(height: 8),
        BlueprintContainer(
          width: 650,
          child: const StretchWrap(
            spacing: 8,
            runSpacing: 8,
            alignment: RunAlignment.center,
            autoStretch: AutoStretch.exceptLastRun,
            children: [
              ColorBox(color: Colors.pink, width: 500, text: '500 - stretches'),
              ColorBox(color: Colors.red, width: 100, text: '100 - stretches'),
              ColorBox(color: Colors.green, width: 100, text: '100 - stretches'),
              ColorBox(color: Colors.orange, width: 100, text: '100 - centered'),
              ColorBox(color: Colors.purple, width: 80, text: '80 - centered'),
            ],
          ),
        ),
      ],
    );
  }
}
