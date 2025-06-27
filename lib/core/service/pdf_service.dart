import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:diaguard1/core/service/auth.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

class PdfService {
  final AuthService _authService = AuthService();
  String get baseUrl => _authService.baseUrl;
  AuthService get authService => _authService;

  Future<List<Map<String, dynamic>>> fetchPdfs() async {
    final token = await _authService.getToken();
    final response = await http.get(
      Uri.parse('${_authService.baseUrl}/users/pdfs'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['data'] != null) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
      return [];
    } else {
      throw Exception('Failed to fetch PDFs');
    }
  }

  Future<void> deletePdf(String publicId) async {
    final token = await _authService.getToken();
    final response = await http.delete(
      Uri.parse('${_authService.baseUrl}/users/pdfs/$publicId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete PDF');
    }
  }

  Future<void> uploadPdf({String? path, List<int>? bytes, String? fileName}) async {
    final token = await _authService.getToken();
    final uri = Uri.parse('${_authService.baseUrl}/users/upload-pdf');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token';

    if (kIsWeb) {
      if (bytes == null || fileName == null) {
        throw Exception('No file bytes or file name provided for web upload');
      }
      request.files.add(
        http.MultipartFile.fromBytes(
          'pdf',
          bytes,
          filename: fileName,
          contentType: MediaType('application', 'pdf'),
        ),
      );
    } else {
      if (path == null) {
        throw Exception('No file path provided for mobile upload');
      }
      request.files.add(
        await http.MultipartFile.fromPath(
          'pdf',
          path,
          contentType: MediaType('application', 'pdf'),
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final responseJson = jsonDecode(response.body);
    if (!(response.statusCode >= 200 && response.statusCode < 300 && responseJson['success'] == true)) {
      print('Upload failed: \\${response.statusCode} - \\${response.body}');
      throw Exception('Failed to upload PDF: \\${response.body}');
    }
  }

  /// For doctors: fetch all PDFs uploaded by a specific patient
  Future<List<Map<String, dynamic>>> fetchPatientPdfs(String patientId) async {
    final token = await _authService.getToken();
    final response = await http.get(
      Uri.parse('${_authService.baseUrl}/users/patients/$patientId/pdfs'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['data'] != null) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
      return [];
    } else {
      throw Exception('Failed to fetch patient PDFs');
    }
  }

  /// For both patients and doctors: get the download URL for a PDF
  String getDownloadUrl(String publicId) {
    return '${_authService.baseUrl}/users/pdfs/$publicId/download';
  }
} 