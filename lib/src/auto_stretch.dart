/// Defines which children should automatically be stretched.
enum AutoStretch {
  /// No automatic stretching - only explicit [Stretch] widgets are stretched to fill the available space.
  explicit,

  /// All children are stretched to fill the available space.
  all,

  /// All children except those in the last run automatically stretch to fill the available space.
  exceptLastRun;

  bool shouldStretch({required bool last}) => switch (this) {
        AutoStretch.explicit => false,
        AutoStretch.all => true,
        AutoStretch.exceptLastRun => !last,
      };
}
