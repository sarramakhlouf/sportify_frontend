import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:sportify_frontend/core/constants/api_constants.dart';

class ApiClient {
  // POST simple JSON
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final headers = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}$endpoint"),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Erreur ${response.statusCode} : ${response.body}');
    }
  }

  // GET
  Future<Map<String, dynamic>> get(
    String endpoint, {
    String? token,
  }) async {
    final headers = {
      if (token != null) "Authorization": "Bearer $token",
    };

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}$endpoint"),
      headers: headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Erreur ${response.statusCode} : ${response.body}');
    }
  }

  // POST multipart (avec JSON + image)
  Future<Map<String, dynamic>> postMultipart(
    String endpoint,
    Map<String, dynamic> body, {
    File? file,
    String fileKey = 'image',
    String jsonKey = 'data',
    String? token,
  }) async {
    final uri = Uri.parse("${ApiConstants.baseUrl}$endpoint");
    final request = http.MultipartRequest('POST', uri);

    // JSON
    /*request.files.add(
      http.MultipartFile.fromString(
        jsonKey,
        jsonEncode(body),
        contentType: MediaType('application', 'json'),
      ),
    );*/

    request.fields[jsonKey] = jsonEncode(body);

    // Image
    if (file != null) {
      final ext = file.path.split('.').last.toLowerCase();
      request.files.add(
        await http.MultipartFile.fromPath(
          fileKey,
          file.path,
          contentType: MediaType(
            'image',
            ext == 'png' ? 'png' : 'jpeg',
          ),
        ),
      );
    }

    // Token
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(respStr);
    } else if (response.statusCode == 403) {
      throw Exception(
          '403 Forbidden : Vérifie le token ou les permissions de l’utilisateur');
    } else {
      throw Exception('Erreur ${response.statusCode} : $respStr');
    }
    }
}
