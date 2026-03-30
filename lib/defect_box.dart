import 'package:flutter/material.dart';

class DefectBox {
  final double x, y, w, h;

  DefectBox(this.x, this.y, this.w, this.h);

  // Scale from golden (4032×3024) → camera preview
  Rect scaleToPreview(double previewW, double previewH) {
    const double goldenW = 4032;
    const double goldenH = 3024;

    double scaleX = previewW / goldenW;
    double scaleY = previewH / goldenH;

    return Rect.fromLTWH(
      x * scaleX,
      y * scaleY,
      w * scaleX,
      h * scaleY,
    );
  }
}
