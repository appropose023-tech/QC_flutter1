import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'defect_box.dart';

class ApiService {
  static const String url = "http://YOUR_SERVER/api/process";

  static Future<List<DefectBox>> uploadImage(File file) async {
    var req = http.MultipartRequest("POST", Uri.parse(url));
    req.files.add(await http.MultipartFile.fromPath("image", file.path));

    final res = await req.send();

    if (res.statusCode != 200) {
      print("API error: ${res.statusCode}");
      return [];
    }

    final body = await res.stream.bytesToString();

    final decoded = jsonDecode(body);

    return (decoded["defects"] as List)
        .map((d) => DefectBox.fromJson(d))
        .toList();
  }
}
