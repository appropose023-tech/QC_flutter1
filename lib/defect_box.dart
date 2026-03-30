import 'package:flutter/material.dart';
import 'dart:ui';

class DefectBox {
  final double x, y, w, h;

  DefectBox({required this.x, required this.y, required this.w, required this.h});

  // BACKEND image resolution (your actual PCB image)
  static const double backendWidth = 3679;
  static const double backendHeight = 1717;

  // Convert backend-coordinates → camera-preview coordinates
  Rect scaleToPreview(double previewWidth, double previewHeight) {
    double scaleX = previewWidth / backendWidth;
    double scaleY = previewHeight / backendHeight;

    return Rect.fromLTWH(
      x * scaleX,
      y * scaleY,
      w * scaleX,
      h * scaleY,
    );
  }
}
