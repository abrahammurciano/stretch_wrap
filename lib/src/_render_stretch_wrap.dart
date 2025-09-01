import 'package:flutter/rendering.dart';

import '_run.dart';
import '_stretch_wrap_parent_data.dart';
import 'alignment.dart' show RunAlignment;
import 'auto_stretch.dart' show AutoStretch;

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
  RenderStretchWrap({
    required double spacing,
    required double runSpacing,
    required RunAlignment alignment,
    required AutoStretch autoStretch,
  })  : _spacing = spacing,
        _runSpacing = runSpacing,
        _alignment = alignment,
        _autoStretch = autoStretch;

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

  RunAlignment _alignment;
  RunAlignment get alignment => _alignment;
  set alignment(RunAlignment value) {
    if (_alignment == value) return;
    _alignment = value;
    markNeedsLayout();
  }

  AutoStretch _autoStretch;
  AutoStretch get autoStretch => _autoStretch;
  set autoStretch(AutoStretch value) {
    if (_autoStretch == value) return;
    _autoStretch = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! StretchWrapParentData) {
      child.parentData = StretchWrapParentData();
    }
  }

  @override
  void performLayout() {
    final runs = _computeRuns(constraints);
    double y = 0.0;
    for (int i = 0; i < runs.length; ++i) {
      final run = runs[i];
      _layoutRun(run, y, i == runs.length - 1);
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

  List<Run> _computeRuns(BoxConstraints constraints) {
    final List<Run> runs = [];
    Run run = Run(maxWidth: constraints.maxWidth, spacing: spacing);
    for (RenderBox? child = firstChild; child != null; child = _parentData(child).nextSibling) {
      child.layout(BoxConstraints(maxWidth: constraints.maxWidth), parentUsesSize: true);
      if (!run.fits(child)) {
        runs.add(run);
        run = Run(maxWidth: constraints.maxWidth, spacing: spacing);
      }
      run.add(child, autoStretch: autoStretch != AutoStretch.explicit);
    }
    if (run.children.isNotEmpty) {
      runs.add(run);
    }
    if (autoStretch == AutoStretch.exceptLastRun) {
      runs.last.updateFlex(autoStretch: false);
    }
    return runs;
  }

  void _layoutRun(Run run, double y, bool isLastRun) {
    if (run.hasStretchChildren) {
      _stretchRun(run, y, autoStretch.shouldStretch(last: isLastRun));
    } else {
      _alignRun(run, y);
    }
  }

  void _stretchRun(Run run, double y, bool autoStretch) {
    if (!run.hasStretchChildren) {
      return;
    }
    final pixelsPerFlex = run.pixelsPerFlex;
    double x = 0.0;
    for (final child in run.children) {
      final parentData = _parentData(child);
      final flex = parentData.flex ?? (autoStretch ? 1.0 : 0.0);
      double width = run.sizes[child]!.width;
      if (flex > 0) {
        width += pixelsPerFlex * flex;
        child.layout(BoxConstraints.tightFor(width: width), parentUsesSize: true);
      }
      parentData.offset = Offset(x, y);
      x += width + spacing;
    }
    run.updateHeight();
  }

  void _alignRun(Run run, double y) {
    final remainingSpace = run.maxWidth - run.width;
    final effectiveSpacing = switch (alignment) {
      RunAlignment.spaceBetween when run.children.length > 1 => spacing + remainingSpace / (run.children.length - 1),
      RunAlignment.spaceAround => spacing + remainingSpace / run.children.length,
      _ => spacing,
    };

    double x = switch (alignment) {
      RunAlignment.start => 0.0,
      RunAlignment.end => remainingSpace,
      RunAlignment.center => remainingSpace / 2,
      RunAlignment.spaceBetween => 0.0,
      RunAlignment.spaceAround => (remainingSpace / run.children.length) / 2,
    };

    for (final child in run.children) {
      _parentData(child).offset = Offset(x, y);
      x += run.sizes[child]!.width + effectiveSpacing;
    }
  }

  StretchWrapParentData _parentData(RenderBox child) => child.parentData! as StretchWrapParentData;
}
