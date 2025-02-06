import 'dart:math';

import 'package:flutter/rendering.dart';

import '_stretch_wrap_parent_data.dart';

/// Represents a single run of children within a [RenderStretchWrap].
class Run {
  /// The children in this run.
  final List<RenderBox> children = [];

  /// A cache of child sizes.
  final Map<RenderBox, Size> sizes = {};

  /// The total flex factor of all children in this run. It is updated as children are added.
  int flex = 0;

  /// The height of this run. It is updated as children are added.
  double height = 0.0;

  /// The total occupied width of this run. It is updated as children are added.
  double width = 0.0;

  /// The maximum allowable width for this run.
  final double maxWidth;

  /// The horizontal space between adjacent children.
  final double spacing;

  /// Creates a new run with the given maximum width and spacing.
  Run({required this.maxWidth, required this.spacing});

  /// Checks if the given child can be added to this run without exceeding the maximum width.
  bool fits(RenderBox child) => children.isEmpty || width + spacing + child.size.width <= maxWidth;

  /// Adds the given child to this run.
  void add(RenderBox child) {
    children.add(child);
    sizes[child] = child.size;
    width += child.size.width + (children.length > 1 ? spacing : 0);
    height = max(height, child.size.height);
    flex += (child.parentData as StretchWrapParentData).flex ?? 0;
  }
}
