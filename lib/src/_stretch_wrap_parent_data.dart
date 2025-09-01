import 'package:flutter/rendering.dart';

import '_render_stretch_wrap.dart';

/// Parent data for use with [RenderStretchWrap].
///
/// Stores flex factor for children wrapped in [Stretch].
class StretchWrapParentData extends ContainerBoxParentData<RenderBox> {
  /// The flex factor to apply to the child.
  ///
  /// `null` indicates the child is not wrapped in a [Stretch] widget.
  double? flex;

  StretchWrapParentData({this.flex});

  static StretchWrapParentData of(RenderBox child) => child.parentData! as StretchWrapParentData;
}
