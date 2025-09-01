/// Cross-axis alignment options for [StretchWrap].
///
/// This enum controls how children within a run are aligned relative to each
/// other in the cross axis (vertically).
enum CrossRunAlignment {
  /// Place the children at the start of the cross axis.
  ///
  /// For a horizontal axis (the typical case), this is the top of the run.
  start,

  /// Place the children at the center of the cross axis.
  ///
  /// For a horizontal axis (the typical case), this is the middle of the run.
  center,

  /// Place the children at the end of the cross axis.
  ///
  /// For a horizontal axis (the typical case), this is the bottom of the run.
  end,

  /// Stretch the children to fill the cross axis.
  ///
  /// For a horizontal axis (the typical case), this makes all children
  /// in the run the same height as the tallest child in that run.
  stretch,
}
