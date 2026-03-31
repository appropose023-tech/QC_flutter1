import 'package:flutter/material.dart';
import 'live_overlay_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    home: LiveOverlayScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
