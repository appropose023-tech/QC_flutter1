import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'models.dart';

class ApiService {
  final String url = "http://104.154.76.47:8000/inspect";

  Future<InspectionResult?> inspect(File image) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse(url));

      request.files.add(
        await http.MultipartFile.fromPath('file', image.path),
      );

      var response = await request.send();
      var body = await response.stream.bytesToString();

      final json = jsonDecode(body);
      return InspectionResult.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
