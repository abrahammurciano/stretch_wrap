import 'dart:math' show max;

import 'package:flutter/rendering.dart' show RenderBox, Size;
import 'package:stretch_wrap/src/_stretch_wrap_parent_data.dart' show StretchWrapParentData;

/// Represents a single run of children within a [RenderStretchWrap].
class Run {
  /// The children in this run.
  final List<RenderBox> children = [];

  /// A cache of child sizes.
  final Map<RenderBox, Size> sizes = {};

  /// The total flex factor of all children in this run. It is updated as children are added.
  double flex = 0.0;

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

  /// Returns whether this run has any children that should be stretched.
  bool get hasStretchChildren => flex > 0;

  double get pixelsPerFlex => hasStretchChildren ? (maxWidth - width) / flex : 0.0;

  /// Adds the given child to this run.
  void add(RenderBox child, {bool autoStretch = false}) {
    children.add(child);
    sizes[child] = child.size;
    width += child.size.width + (children.length > 1 ? spacing : 0);
    height = max(height, child.size.height);
  }

  void updateHeight() {
    height = children.fold(0.0, (maxHeight, child) => max(maxHeight, child.size.height));
  }

  void updateFlex({required bool autoStretch}) {
    final infiniteFlex = children.any((child) => StretchWrapParentData.of(child).flex?.isInfinite == true);
    double totalFlex = 0.0;
    for (final child in children) {
      final parentData = StretchWrapParentData.of(child);
      if (infiniteFlex) {
        parentData.flex = parentData.flex?.isInfinite == true ? 1.0 : 0.0;
      } else {
        parentData.flex ??= (autoStretch ? 1.0 : 0.0);
      }
      totalFlex += parentData.flex ?? 0.0;
    }
    flex = totalFlex;
  }
}
