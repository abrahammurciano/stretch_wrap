import 'package:flutter/rendering.dart';

import '_run.dart';
import '_stretch_wrap_parent_data.dart';

/// Renders children in multiple runs with flex-based space distribution within each run.
///
/// Core layout behavior:
/// - Children are positioned horizontally until they exceed constraints
/// - New run starts when next child would exceed maximum width
/// - Within each run, remaining space is distributed among [Stretch] children
/// - Vertical size determined by sum of run heights plus [runSpacing]
///
/// Performance considerations:
/// - Initial layout pass determines run composition
/// - Second pass only performed on runs containing [Stretch] children
/// - Child layout calls minimized through size caching
class RenderStretchWrap extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, StretchWrapParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, StretchWrapParentData> {
  RenderStretchWrap({required double spacing, required double runSpacing})
      : _spacing = spacing,
        _runSpacing = runSpacing;

  double _spacing;
  double get spacing => _spacing;
  set spacing(double value) {
    if (_spacing == value) return;
    _spacing = value;
    markNeedsLayout();
  }

  double _runSpacing;
  double get runSpacing => _runSpacing;
  set runSpacing(double value) {
    if (_runSpacing == value) return;
    _runSpacing = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! StretchWrapParentData) {
      child.parentData = StretchWrapParentData();
    }
  }

  List<Run> _computeRuns(BoxConstraints constraints) {
    final List<Run> runs = [];
    Run run = Run(maxWidth: constraints.maxWidth, spacing: spacing);
    for (RenderBox? child = firstChild;
        child != null;
        child = (child.parentData! as StretchWrapParentData).nextSibling) {
      child.layout(BoxConstraints(maxWidth: constraints.maxWidth), parentUsesSize: true);
      if (!run.fits(child)) {
        runs.add(run);
        run = Run(maxWidth: constraints.maxWidth, spacing: spacing);
      }
      run.add(child);
    }
    if (run.children.isNotEmpty) {
      runs.add(run);
    }
    return runs;
  }

  @override
  void performLayout() {
    final runs = _computeRuns(constraints);
    double y = 0.0;
    for (final run in runs) {
      double x = 0.0;
      double extraPerFlex = run.flex > 0 ? (run.maxWidth - run.width) / run.flex : 0.0;

      for (final child in run.children) {
        final childParentData = child.parentData! as StretchWrapParentData;

        double width = run.sizes[child]!.width;
        if (childParentData.flex != null) {
          width += extraPerFlex * childParentData.flex!;
          child.layout(BoxConstraints.tightFor(width: width), parentUsesSize: true);
        }

        childParentData.offset = Offset(x, y);
        x += width + spacing;
      }
      y += run.height + runSpacing;
    }
    size = constraints.constrainDimensions(double.infinity, y - runSpacing);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
