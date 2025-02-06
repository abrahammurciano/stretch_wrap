import 'package:flutter/widgets.dart';

import '_stretch_wrap_parent_data.dart';
import 'stretch_wrap.dart';

/// Marks a child of [StretchWrap] to expand to fill remaining space within its
/// run.
///
/// The [flex] factor determines what proportion of remaining horizontal space
/// the child receives relative to other [Stretch] children in the same run.
///
/// Note: Flex distribution occurs independently within each run. The same
/// flex factor may result in different final widths in different runs.
class Stretch extends ParentDataWidget<StretchWrapParentData> {
  const Stretch({super.key, this.flex = 1, required super.child});

  /// The proportion of remaining space the child should receive.
  final int flex;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is StretchWrapParentData);
    final parentData = renderObject.parentData! as StretchWrapParentData;

    if (parentData.flex != flex) {
      parentData.flex = flex;
      final targetObject = renderObject.parent;
      if (targetObject is RenderObject) {
        targetObject.markNeedsLayout();
      }
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => StretchWrap;
}
