import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:diaguard1/core/service/pdf_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class PatientPdfsScreen extends StatefulWidget {
  final String patientId;
  final String patientName;
  const PatientPdfsScreen({Key? key, required this.patientId, required this.patientName}) : super(key: key);

  @override
  State<PatientPdfsScreen> createState() => _PatientPdfsScreenState();
}

class _PatientPdfsScreenState extends State<PatientPdfsScreen> {
  final PdfService _pdfService = PdfService();
  bool _isLoading = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _pdfs = [];

  @override
  void initState() {
    super.initState();
    _fetchPdfs();
  }

  Future<void> _fetchPdfs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final pdfs = await _pdfService.fetchPatientPdfs(widget.patientId);
      setState(() {
        _pdfs = pdfs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading PDFs: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadPdfWeb(String publicId, String filename) async {
    final token = await _pdfService.authService.getToken();
    final signedUrlEndpoint = '${_pdfService.baseUrl}/users/pdfs/$publicId/signed-url';
    final response = await http.get(
      Uri.parse(signedUrlEndpoint),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final signedUrl = jsonDecode(response.body)['url'];
      final fileResponse = await http.get(Uri.parse(signedUrl));
      if (fileResponse.statusCode == 200) {
        final blob = html.Blob([fileResponse.bodyBytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', filename)
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download PDF: ${fileResponse.body}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get signed URL: ${response.body}')),
      );
    }
  }

  Future<void> _downloadPdfCrossPlatform(String publicId, String filename) async {
    try {
      final token = await _pdfService.authService.getToken();
      final signedUrlEndpoint = '${_pdfService.baseUrl}/users/pdfs/$publicId/signed-url';
      final response = await http.get(
        Uri.parse(signedUrlEndpoint),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final signedUrl = jsonDecode(response.body)['url'];
        if (kIsWeb) {
          await _downloadPdfWeb(publicId, filename);
        } else {
          final fileResponse = await http.get(Uri.parse(signedUrl));
          if (fileResponse.statusCode == 200) {
            final bytes = fileResponse.bodyBytes;
            final dir = await getTemporaryDirectory();
            final file = File('${dir.path}/$filename');
            await file.writeAsBytes(bytes);
            await OpenFile.open(file.path);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to download PDF: ${fileResponse.body}')),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get signed URL: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ملفات ${widget.patientName} الطبية')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
              : Column(
                  children: [
                    Expanded(
                      child: _pdfs.isEmpty
                          ? const Center(child: Text('لا توجد ملفات PDF لهذا المريض.'))
                          : ListView.builder(
                              itemCount: _pdfs.length,
                              itemBuilder: (context, index) {
                                final pdf = _pdfs[index];
                                return ListTile(
                                  leading: const Icon(Icons.picture_as_pdf),
                                  title: Text(pdf['filename'] ?? 'PDF'),
                                  subtitle: Text(pdf['uploadedAt'] ?? ''),
                                  onTap: () {
                                    final publicId = pdf['cloudinaryPublicId'];
                                    final filename = pdf['filename'] ?? 'file.pdf';
                                    if (publicId == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Cannot download: PDF ID is missing.')),
                                      );
                                      return;
                                    }
                                    _downloadPdfCrossPlatform(publicId, filename);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
  }
} 