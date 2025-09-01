import 'package:flutter/widgets.dart' show BuildContext, MultiChildRenderObjectWidget, Wrap;

import '_render_stretch_wrap.dart' show RenderStretchWrap;
import 'alignment.dart' show RunAlignment;
import 'auto_stretch.dart' show AutoStretch;
import 'cross_run_alignment.dart' show CrossRunAlignment;

/// A widget that displays its children in multiple runs (rows) and distributes remaining space
/// in each run among [Stretch] children according to their flex factors.
///
/// Unlike [Wrap], which simply places children in rows, [StretchWrap] implements flex-based
/// space distribution within each row. After initial child layout determines row composition,
/// any remaining horizontal space in each row is distributed among that row's [Stretch]
/// children proportionally to their flex factors.
///
/// The [alignment] parameter controls how runs handle remaining space when they don't
/// contain stretch children or when auto-stretching is disabled:
/// - [RunAlignment.start] (default): Aligns children to the start
/// - [RunAlignment.center]: Centers children within the run
/// - [RunAlignment.end]: Aligns children to the end
/// - [RunAlignment.spaceBetween]: Distributes children evenly with space between them
/// - [RunAlignment.spaceAround]: Distributes children evenly with space around them
///
/// The [autoStretch] parameter determines which runs automatically treat their children
/// as if wrapped in [Stretch]:
/// - [AutoStretch.explicit] (default): Only explicit [Stretch] widgets are stretched
/// - [AutoStretch.all]: All runs automatically stretch their children
/// - [AutoStretch.exceptLastRun]: All runs except the last one automatically stretch
///
/// The layout algorithm:
/// 1. Children are sized and positioned into rows based on available width
/// 2. For each row:
///    * If auto-stretching is enabled for this run, treat all children as stretched
///    * If the run contains [Stretch] children or auto-stretched children:
///      remainingSpace = (maxWidth - usedWidth - totalSpacing)
///      Each stretched child's width += (remainingSpace * flex / totalFlex)
///    * Otherwise, align children according to [alignment]
///
/// Example:
/// ```dart
/// StretchWrap(
///   spacing: 8,
///   runSpacing: 16,
///   alignment: RunAlignment.center,
///   autoStretch: AutoStretch.explicit,
///   children: [
///     Container(width: 100),
///     Stretch(child: Container()), // Gets portion of remaining space
///     Container(width: 80),
///     Stretch(flex: 2, child: Container()), // Gets 2x portion
///   ],
/// )
/// ```
class StretchWrap extends MultiChildRenderObjectWidget {
  const StretchWrap({
    super.key,
    required super.children,
    this.spacing = 0.0,
    this.runSpacing = 0.0,
    this.alignment = RunAlignment.start,
    this.crossRunAlignment = CrossRunAlignment.center,
    this.autoStretch = AutoStretch.explicit,
  });

  /// Horizontal space between adjacent children within a run.
  final double spacing;

  /// Vertical space between runs.
  final double runSpacing;

  /// How children should be aligned within their run when there's remaining space and no children are stretched within that run.
  final RunAlignment alignment;

  /// How children within a run should be aligned relative to each other in the cross axis.
  final CrossRunAlignment crossRunAlignment;

  /// Which children should automatically be stretched.
  final AutoStretch autoStretch;

  @override
  RenderStretchWrap createRenderObject(BuildContext context) {
    return RenderStretchWrap(
      spacing: spacing,
      runSpacing: runSpacing,
      alignment: alignment,
      crossRunAlignment: crossRunAlignment,
      autoStretch: autoStretch,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderStretchWrap renderObject) {
    renderObject
      ..spacing = spacing
      ..runSpacing = runSpacing
      ..alignment = alignment
      ..crossRunAlignment = crossRunAlignment
      ..autoStretch = autoStretch;
  }
}
