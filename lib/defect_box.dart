import 'dart:ui';

class DefectBox {
  final double x;
  final double y;
  final double w;
  final double h;

  DefectBox({
    required this.x,
    required this.y,
    required this.w,
    required this.h,
  });

  // Backend image resolution
  static const double backendWidth = 3679;
  static const double backendHeight = 1717;

  Rect scaleToPreview(double previewW, double previewH) {
    double sX = previewW / backendWidth;
    double sY = previewH / backendHeight;

    return Rect.fromLTWH(
      x * sX,
      y * sY,
      w * sX,
      h * sY,
    );
  }

  factory DefectBox.fromJson(Map<String, dynamic> json) {
    return DefectBox(
      x: json["x"].toDouble(),
      y: json["y"].toDouble(),
      w: json["w"].toDouble(),
      h: json["h"].toDouble(),
    );
  }
}
