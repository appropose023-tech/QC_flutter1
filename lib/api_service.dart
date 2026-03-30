import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://104.154.76.47:8000";

  Future<Map<String, dynamic>?> sendToServer(File imageFile) async {
    final uri = Uri.parse("$baseUrl/inspect/");

    final request = http.MultipartRequest("POST", uri);
    request.files.add(await http.MultipartFile.fromPath("file", imageFile.path));

    final response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return json.decode(respStr);
    }

    print("Server error: $respStr");
    return null;
  }
}
