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
      width: 550,
      child: StretchWrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final tag in tags)
            Stretch(
              child: Card(
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(tag),
                ),
              ),
            ),
          const Stretch(flex: 100, child: SizedBox.shrink()),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Add Tag'),
          ),
        ],
      ),
    );
  }
}
