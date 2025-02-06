import 'package:flutter/widgets.dart';

import '_render_stretch_wrap.dart';

/// A widget that displays its children in multiple runs (rows) and distributes remaining space
/// in each run among [Stretch] children according to their flex factors.
///
/// Unlike [Wrap], which simply places children in rows, [StretchWrap] implements flex-based
/// space distribution within each row. After initial child layout determines row composition,
/// any remaining horizontal space in each row is distributed among that row's [Stretch]
/// children proportionally to their flex factors.
///
/// The layout algorithm:
/// 1. Children are sized and positioned into rows based on available width
/// 2. For each row containing [Stretch] children:
///    * Remaining space = (maxWidth - usedWidth - totalSpacing)
///    * Each [Stretch] child's width += (remainingSpace * flex / totalFlex)
///
/// Example:
/// ```dart
/// StretchWrap(
///   spacing: 8,
///   runSpacing: 16,
///   children: [
///     Container(width: 100),
///     Stretch(child: Container()), // Gets portion of remaining space
///     Container(width: 80),
///     Stretch(flex: 2, child: Container()), // Gets 2x portion
///   ],
/// )
/// ```
class StretchWrap extends MultiChildRenderObjectWidget {
  const StretchWrap({super.key, required super.children, this.spacing = 0.0, this.runSpacing = 0.0});

  /// Horizontal space between adjacent children within a run.
  final double spacing;

  /// Vertical space between runs.
  final double runSpacing;

  @override
  RenderStretchWrap createRenderObject(BuildContext context) {
    return RenderStretchWrap(spacing: spacing, runSpacing: runSpacing);
  }

  @override
  void updateRenderObject(BuildContext context, RenderStretchWrap renderObject) {
    renderObject
      ..spacing = spacing
      ..runSpacing = runSpacing;
  }
}
