/// Defines how children should be aligned within each run when there's remaining space and no children are stretched within that run.
enum RunAlignment {
  /// Align children to the start (left in LTR, right in RTL).
  start,

  /// Center children within the run.
  center,

  /// Align children to the end (right in LTR, left in RTL).
  end,

  /// Distribute children evenly with space between them.
  /// The first child is aligned to the start and the last child to the end,
  /// with equal space distributed between all children.
  spaceBetween,

  /// Distribute children evenly with space around them.
  /// Each child gets equal space on both sides, with half-space at the edges.
  spaceAround,
}
