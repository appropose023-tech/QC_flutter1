import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

import 'api_service.dart';
import 'defect_box.dart';

class LiveOverlayScreen extends StatefulWidget {
  @override
Widget build(BuildContext context) {
  if (controller == null || !controller!.value.isInitialized) {
    return const Scaffold(
        body: Center(child: CircularProgressIndicator()));
  }

  return Scaffold(
    body: Center(
      child: AspectRatio(
        aspectRatio: controller!.value.aspectRatio,
        child: Stack(
          children: [
            CameraPreview(controller!),

            // Defect overlay
            LayoutBuilder(
              builder: (context, constraints) {
                double previewW = constraints.maxWidth;
                double previewH = constraints.maxHeight;

                return Stack(
                  children: defects.map((d) {
                    Rect r = d.scaleToPreview(previewW, previewH);

                    return Positioned(
                      left: r.left,
                      top: r.top,
                      width: r.width,
                      height: r.height,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 2),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}
}
