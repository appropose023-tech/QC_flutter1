import 'package:flutter/material.dart';
import 'live_overlay.dart';

void main() {
  runApp(const PCBApp());
}

class PCBApp extends StatelessWidget {
  const PCBApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PCB Inspector",
      debugShowCheckedModeBanner: false,
      home: LiveOverlayScreen(),
    );
  }
}
