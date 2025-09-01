import 'package:flutter/material.dart';
import 'package:stretch_wrap/stretch_wrap.dart';

import '../utils/blueprint_container.dart';

class TagListExample extends StatelessWidget {
  const TagListExample({super.key});

  @override
  Widget build(BuildContext context) {
    final tags = [
      'Flutter',
      'Dart',
      'Mobile',
      'Web',
      'Desktop',
      'Cross-platform',
      'UI',
      'Development',
      'Programming',
      'Coding',
      'Software',
      'Engineering',
      'Computer',
      'Science',
      'Technology',
      'Open-source',
      'Community',
      'Learning',
      'Education',
      'Career',
      'Job',
      'Opportunity',
      'Remote',
      'Work',
    ];

    return BlueprintContainer(
      width: 1000,
      child: StretchWrap(
        spacing: 8,
        runSpacing: 8,
        autoStretch: AutoStretch.all,
        alignment: RunAlignment.spaceBetween,
        children: [
          for (final tag in tags)
            Card(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(tag),
              ),
            ),
          const Stretch(flex: double.infinity, child: SizedBox.shrink()),
          FilledButton(
            onPressed: () {},
            child: const Text('Add Tag'),
          ),
        ],
      ),
    );
  }
}
