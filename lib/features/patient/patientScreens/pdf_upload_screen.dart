import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:diaguard1/core/service/pdf_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:universal_html/html.dart' as html;

class PdfUploadScreen extends StatefulWidget {
  const PdfUploadScreen({Key? key}) : super(key: key);

  @override
  State<PdfUploadScreen> createState() => _PdfUploadScreenState();
}

class _PdfUploadScreenState extends State<PdfUploadScreen> {
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
      final pdfs = await _pdfService.fetchPdfs();
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

  Future<void> _pickAndUploadPdf() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      try {
        if (kIsWeb) {
          await _pdfService.uploadPdf(
            bytes: result.files.single.bytes,
            fileName: result.files.single.name,
          );
        } else {
          await _pdfService.uploadPdf(
            path: result.files.single.path,
          );
        }
        await _fetchPdfs();
      } catch (e) {
        setState(() {
          _errorMessage = 'Error uploading PDF: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> deletePdf(String publicId) async {
  final token = await _pdfService.authService.getToken();
  final response = await http.delete(
    Uri.parse('${_pdfService.baseUrl}/users/pdfs/$publicId'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode != 200) {
    print('Delete failed: ${response.statusCode} - ${response.body}');
    throw Exception('Failed to delete PDF: ${response.body}');
  }
  }

  Future<void> _downloadPdfWeb(String signedUrl, String filename) async {
    final response = await http.get(Uri.parse(signedUrl));
    if (response.statusCode == 200) {
      final blob = html.Blob([response.bodyBytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download PDF: ${response.body}')),
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
          await _downloadPdfWeb(signedUrl, filename);
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

  void _openPdfUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medical Test PDFs')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Upload PDF'),
                        onPressed: _pickAndUploadPdf,
                      ),
                    ),
                    Expanded(
                      child: _pdfs.isEmpty
                          ? const Center(child: Text('No PDFs uploaded yet.'))
                          : ListView.builder(
                              itemCount: _pdfs.length,
                              itemBuilder: (context, index) {
                                final pdf = _pdfs[index];
                                print(pdf); // Debug: print the PDF object to console
                                return ListTile(
                                  leading: const Icon(Icons.picture_as_pdf),
                                  title: Text(pdf['filename'] ?? 'PDF'),
                                  subtitle: Text(pdf['uploadedAt'] ?? ''),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      try {
                                        await deletePdf(pdf['cloudinaryPublicId']);
                                        await _fetchPdfs(); // Refresh the list after deletion
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error deleting PDF: $e')),
                                        );
                                      }
                                    },
                                  ),
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