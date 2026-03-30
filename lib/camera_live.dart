import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'models.dart';

class CameraLive extends StatefulWidget {
  const CameraLive({super.key});

  @override
  State<CameraLive> createState() => _CameraLiveState();
}

class _CameraLiveState extends State<CameraLive> {
  CameraController? controller;
  bool loading = false;
  InspectionResult? result;
  Size? imageSize;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future initCamera() async {
    final cams = await availableCameras();
    controller = CameraController(cams.first, ResolutionPreset.high);
    await controller!.initialize();
    setState(() {});
  }

  Future scan() async {
    if (controller == null || loading) return;

    setState(() {
      loading = true;
      result = null;
    });

    final image = await controller!.takePicture();
    final file = File(image.path);

    final decoded = await decodeImageFromList(await file.readAsBytes());

    imageSize = Size(decoded.width.toDouble(), decoded.height.toDouble());

    final api = ApiService();
    final res = await api.inspect(file);

    setState(() {
      result = res;
      loading = false;
    });
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
      body: Stack(
        children: [
          CameraPreview(controller!),

          if (result != null)
            CustomPaint(
              painter: BoxPainter(result!.defects, imageSize),
              size: Size.infinite,
            ),

          if (loading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scan,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class BoxPainter extends CustomPainter {
  final List<PCBDefect> defects;
  final Size? imageSize;

  BoxPainter(this.defects, this.imageSize);

  @override
  void paint(Canvas canvas, Size size) {
    if (imageSize == null) return;

    final scaleX = size.width / imageSize!.width;
    final scaleY = size.height / imageSize!.height;

    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    int i = 1;

    for (var d in defects) {
      final rect = Rect.fromLTWH(
        d.x * scaleX,
        d.y * scaleY,
        d.w * scaleX,
        d.h * scaleY,
      );

      canvas.drawRect(rect, paint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: "Defect $i",
          style: const TextStyle(color: Colors.red, fontSize: 14),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(canvas, Offset(rect.left, rect.top - 16));

      i++;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
