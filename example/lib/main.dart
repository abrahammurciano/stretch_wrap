import 'package:flutter/material.dart';

import 'examples/basic_example.dart';
import 'examples/mixed_content_example.dart';
import 'examples/multiple_rows_example.dart';
import 'examples/multiple_stretch_example.dart';
import 'examples/tag_list_example.dart';
import 'utils/example_card.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StretchWrap Examples',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ExamplesScreen(),
    );
  }
}

class ExamplesScreen extends StatelessWidget {
  const ExamplesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StretchWrap Examples')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ExampleCard(
            title: 'Basic Usage',
            description: 'Single stretched child between fixed-width children',
            child: BasicExample(),
          ),
          SizedBox(height: 16),
          ExampleCard(
            title: 'Multiple Stretched Children',
            description: 'Shows how flex values affect space distribution',
            child: MultipleStretchExample(),
          ),
          SizedBox(height: 16),
          ExampleCard(
            title: 'Multiple Rows',
            description: 'Demonstrates wrapping behavior with runSpacing',
            child: MultipleRowsExample(),
          ),
          SizedBox(height: 16),
          ExampleCard(
            title: 'Mixed Content',
            description: 'Mix of text, buttons, and other widgets',
            child: MixedContentExample(),
          ),
          SizedBox(height: 16),
          ExampleCard(
            title: 'Real-world Example',
            description: 'Tag list with "Add Tag" button, where each tag is stretched so all rows are of equal width',
            child: TagListExample(),
          ),
        ],
      ),
    );
  }
}
