class HomeService {
  HomeService._();

  /// Determine number of grid columns based on available width.
  static int computeCrossAxisCount(double width) {
    if (width >= 1000) return 4;
    if (width >= 800) return 3;
    if (width >= 600) return 2;
    return 1;
  }

  /// Suggested padding for lists/grids based on width.
  /// Returns a value like 3% of width by default.
  static double computePadding(double width) => width * 0.03;

  /// Compute a reasonable childAspectRatio for Grid items.
  /// itemWidth = width / crossAxis, baseHeight is an approximate card height.
  /// The returned value is itemWidth / baseHeight.
  static double computeChildAspectRatio(double width, int crossAxis, {double baseHeight = 320}) {
    if (crossAxis <= 0) crossAxis = 1;
    final itemWidth = width / crossAxis;
    return itemWidth / baseHeight;
  }
}
