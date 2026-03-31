import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'api_service.dart';
import 'defect_box.dart';

class LiveOverlayScreen extends StatefulWidget {
  const LiveOverlayScreen({super.key});

  @override
  State<LiveOverlayScreen> createState() => _LiveOverlayScreenState();
}

class _LiveOverlayScreenState extends State<LiveOverlayScreen> {
  CameraController? controller;
  List<CameraDescription> cameras = [];
  bool isProcessing = false;

  List<DefectBox> defects = [];
  double previewW = 1;
  double previewH = 1;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(
      cameras.first,
      ResolutionPreset.max,
      enableAudio: false,
    );

    await controller!.initialize();

    if (!mounted) return;

    // Start periodic frame capture
    Timer.periodic(const Duration(seconds: 2), (_) => processFrame());

    setState(() {});
  }

  Future<void> processFrame() async {
    if (controller == null || isProcessing || !controller!.value.isInitialized) {
      return;
    }

    isProcessing = true;

    try {
      XFile file = await controller!.takePicture();
      File imgFile = File(file.path);

      // Send to backend
      List<DefectBox> result = await ApiService.uploadImage(imgFile);

      setState(() {
        defects = result;
      });
    } catch (e) {
      print("Frame processing error: $e");
    }

    isProcessing = false;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
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
          previewW = constraints.maxWidth;
          previewH = constraints.maxHeight;

          return Stack(
            children: [
              CameraPreview(controller!),

              // Draw defect boxes
              ...defects.map((d) {
                Rect r = d.scaleToPreview(previewW, previewH);
                return Positioned(
                  left: r.left,
                  top: r.top,
                  child: Container(
                    width: r.width,
                    height: r.height,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 3),
                    ),
                  ),
                );
              }).toList()
            ],
          );
        },
      ),
    );
  }
}
