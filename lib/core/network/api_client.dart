import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:sportify_frontend/core/constants/api_constants.dart';
import 'package:sportify_frontend/core/storage/token_storage.dart';

class ApiClient {

//--------------------------------------POST-------------------------------------------
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body, {String? token}) async {
    return _withRefresh(() async {
      
      final token = await TokenStorage.getAccessToken();
      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}$endpoint"),
        headers: headers,
        body: jsonEncode(body),
      ).timeout(
        const Duration(seconds: 60), // Timeout de 60 secondes
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );;

      return _handleResponse(response);
    });
  }

//--------------------------------------GET-------------------------------------------
  Future<Map<String, dynamic>> get(String endpoint, {String? token}) async {
    final headers = {
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}$endpoint"),
      headers: headers,
    ).timeout(
        const Duration(seconds: 60), // Timeout de 60 secondes
        onTimeout: () {
          throw Exception('Request timeout');
        },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur ${response.statusCode} : ${response.body}');
    }
  }

//---------------------------------------GET LIST-------------------------------------------
  Future<List<dynamic>> getList(String endpoint,  {String? token}) async {
    return _withRefresh(() async {
      final accessToken = token ?? await TokenStorage.getAccessToken();
      final headers = {if (accessToken != null) 'Authorization': 'Bearer $accessToken'};

      final response = await http.get(
        Uri.parse("${ApiConstants.baseUrl}$endpoint"),
        headers: headers,
      ).timeout(
        const Duration(seconds: 60), // Timeout de 60 secondes
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body) as List;
      } else {
        throw Exception('Erreur ${response.statusCode} : ${response.body}');
      }
    });
  }

//--------------------------------------PUT-------------------------------------------
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body, {String? token}) async {
    return _withRefresh(() async {
      final accessToken = token ?? await TokenStorage.getAccessToken();
      
      final headers = {
        "Content-Type": "application/json",
        if (accessToken != null) "Authorization": "Bearer $accessToken",
      };

      final response = await http.put(
        Uri.parse("${ApiConstants.baseUrl}$endpoint"),
        headers: headers,
        body: jsonEncode(body),
      ).timeout(
        const Duration(seconds: 60), // Timeout de 60 secondes
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      return _handleResponse(response);
    });
  }

//--------------------------------------POST MULTIPART-------------------------------------------
  Future<Map<String, dynamic>> postMultipart(
    String endpoint,
    Map<String, dynamic> body, {
    File? file,
    String fileKey = 'image',
    String jsonKey = 'data',
    String? token
  }) async {
    return _withRefresh(() async {
      final token = await TokenStorage.getAccessToken();
      final uri = Uri.parse("${ApiConstants.baseUrl}$endpoint");
      final request = http.MultipartRequest('POST', uri);

      request.files.add(
        http.MultipartFile.fromString(
          jsonKey,
          jsonEncode(body),
          contentType: MediaType('application', 'json'),
        ),
      );

      if (file != null) {
        final ext = file.path.split('.').last.toLowerCase();
        request.files.add(
          await http.MultipartFile.fromPath(
            fileKey,
            file.path,
            contentType: MediaType('image', ext == 'png' ? 'png' : 'jpeg'),
          ),
        );
      }

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      final response = await request.send().timeout(
        const Duration(seconds: 60), // Timeout de 60 secondes
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );
      final respStr = await response.stream.bytesToString();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(respStr);
      } else {
        throw Exception('Erreur ${response.statusCode} : $respStr');
      }
    });
  }

//--------------------------------------PUT MULTIPART-------------------------------------------
  Future<Map<String, dynamic>> putMultipart(
    String endpoint,
    Map<String, dynamic> body, {
    File? file,
    String fileKey = 'image',
    String jsonKey = 'data',
    String? token,
  }) async {
    return _withRefresh(() async {
      final accessToken = token ?? await TokenStorage.getAccessToken();

      final uri = Uri.parse("${ApiConstants.baseUrl}$endpoint");
      final request = http.MultipartRequest('PUT', uri);

      request.files.add(
        http.MultipartFile.fromString(
          jsonKey,
          jsonEncode(body),
          contentType: MediaType('application', 'json'),
        ),
      );

      if (file != null) {
        final ext = file.path.split('.').last.toLowerCase();

        final mediaType = switch (ext) {
          'png' => MediaType('image', 'png'),
          'jpg' || 'jpeg' => MediaType('image', 'jpeg'),
          'webp' => MediaType('image', 'webp'),
          'heif' || 'heic' => MediaType('image', 'heif'),
          _ => MediaType('application', 'octet-stream'),
        };

        request.files.add(
          await http.MultipartFile.fromPath(
            fileKey,
            file.path,
            contentType: mediaType,
          ),
        );
      }

      if (accessToken != null) {
        request.headers['Authorization'] = 'Bearer $accessToken';
      }

      final response = await request.send().timeout(
        const Duration(seconds: 60), // Timeout de 60 secondes
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(responseBody);
      } else {
        throw Exception('Erreur ${response.statusCode} : $responseBody');
      }
    });
  }

//--------------------------------------DELETE-------------------------------------------
  Future<void> delete(String endpoint, {String? token}) async {
    return _withRefresh(() async {
      final accessToken = token ?? await TokenStorage.getAccessToken();

      final headers = {
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      };

      final response = await http.delete(
        Uri.parse("${ApiConstants.baseUrl}$endpoint"),
        headers: headers,
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Erreur ${response.statusCode} : ${response.body}');
      }
    });
  }

//--------------------------------------WITH REFRESH-------------------------------------------
  Future<T> _withRefresh<T>(Future<T> Function() requestFunc) async {
    try {
      return await requestFunc();
    } catch (e) {
      if (e.toString().contains('403')) {
        final refreshed = await _refreshToken();
        if (refreshed) {
          return await requestFunc(); 
        }
      }
      rethrow;
    }
  }

//--------------------------------------REFRESH TOKEN-------------------------------------------
  Future<bool> _refreshToken() async {
    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken == null) return false;

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/auth/refresh-token"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await TokenStorage.saveTokens(data['accessToken'], data['refreshToken']);
      return true;
    }

    return false;
  }

//--------------------------------------HANDLE RESPONSE-------------------------------------------
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 403) {
      throw Exception('403 Forbidden : token expiré ou permissions insuffisantes');
    } else {
      throw Exception('Erreur ${response.statusCode} : ${response.body}');
    }
  }
}