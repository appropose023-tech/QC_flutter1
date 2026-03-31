import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

import 'api_service.dart';
import 'defect_box.dart';

class LiveOverlayScreen extends StatefulWidget {
  @override
  State<LiveOverlayScreen> createState() => _LiveOverlayScreenState();
}

class _LiveOverlayScreenState extends State<LiveOverlayScreen> {
  CameraController? controller;
  List<CameraDescription>? cams;

  List<DefectBox> defects = [];
  bool processing = false;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    cams = await availableCameras();
    controller = CameraController(cams![0], ResolutionPreset.high);
    await controller!.initialize();
    setState(() {});

    Timer.periodic(const Duration(seconds: 2), (_) => autoCapture());
  }

  Future<void> autoCapture() async {
    if (controller == null || !controller!.value.isInitialized) return;
    if (processing) return;

    processing = true;

    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String imgPath = "${tempDir.path}/live.jpg";

      await controller!.takePicture().then((XFile file) async {
        File imgFile = File(file.path);
        imgFile.copySync(imgPath);

        final response = await ApiService().sendToServer(File(imgPath));

        if (response != null && mounted) {
          List data = response["defects"];

          defects = data
              .map((d) => DefectBox(
                    (d["x"] as num).toDouble(),
                    (d["y"] as num).toDouble(),
                    (d["w"] as num).toDouble(),
                    (d["h"] as num).toDouble(),
                  ))
              .toList();

          setState(() {});
        }
      });
    } catch (e) {
      print("Error: $e");
    }

    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double previewW = constraints.maxWidth;
          double previewH = constraints.maxHeight;

          return Stack(
            children: [
              CameraPreview(controller!),

              // Overlay defect rectangles
              ...defects.map((d) {
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
            ],
          );
        },
      ),
    );
  }
}
