class HomeService {
  HomeService._();

  /// Determine number of grid columns based on available width.
 static int computeCrossAxisCount(double width) {
  if (width >= 1000) return 4;
  if (width >= 800) return 3;
  return 2; 
}


  /// Suggested padding for lists/grids based on width.
  static double computePadding(double width) => width * 0.03;

  /// The returned value is itemWidth / baseHeight.
  static double computeChildAspectRatio(double width, int crossAxis, {double baseHeight = 280}) {
    if (crossAxis <= 0) crossAxis = 1;
    final itemWidth = (width / crossAxis) - 24;
    return itemWidth / baseHeight;
  }
}