import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiAIService {
  static const String _apiKey = 'AIzaSyCHbHL3BoHB6AOGWtkTWQo2vr15tzDU3SU';

  late final GenerativeModel _model;

  GeminiAIService() {
    _model = GenerativeModel(
      model: 'models/gemini-2.5-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.3,
        topP: 0.9,
        maxOutputTokens: 2048,
      ),
    );
  }

  /// ===============================
  /// MAIN DETECTION METHOD
  /// ===============================
  Future<Map<String, dynamic>> detectCocoa(String imagePath) async {
    try {
      _log('Memulai analisis kakao');

      // ===============================
      // VALIDATION
      // ===============================
      if (imagePath.isEmpty) {
        throw Exception('Path gambar kosong');
      }

      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        throw Exception('File gambar tidak ditemukan');
      }

      final imageBytes = await imageFile.readAsBytes();
      if (imageBytes.isEmpty) {
        throw Exception('File gambar kosong');
      }

      if (imageBytes.length > 4 * 1024 * 1024) {
        throw Exception('Ukuran gambar > 4MB');
      }

      final mimeType = _detectMimeType(imagePath);

      // ===============================
      // PROMPT (STRICT JSON)
      // ===============================
      final prompt = '''
Kamu adalah sistem AI analisis buah kakao berbasis visual.

ATURAN WAJIB:
- Output HARUS JSON VALID
- TANPA markdown
- TANPA penjelasan
- TANPA teks tambahan
- TANPA emoji

FORMAT WAJIB:

{
  "status": "Sehat" | "Sakit",
  "confidence": 0-100,
  "disease": string | null,
  "ripeness": "Mentah" | "Setengah Matang" | "Matang",
  "quality": "Premium" | "Grade A" | "Grade B" | "Perlu Perhatian",
  "recommendations": ["...", "...", "..."]
}

Analisis berdasarkan:
- Warna kulit buah
- Kondisi permukaan
- Tanda penyakit atau hama
- Tingkat kematangan
''';

      final content = [
        Content.multi([TextPart(prompt), DataPart(mimeType, imageBytes)]),
      ];

      // ===============================
      // REQUEST
      // ===============================
      _log('Mengirim request ke Gemini');

      final response = await _model
          .generateContent(content)
          .timeout(const Duration(seconds: 30));

      final rawText = _extractText(response);
      _log('Response diterima');

      if (rawText.isEmpty) {
        throw Exception('Response kosong dari AI');
      }

      _log('Raw response:\n$rawText');

      // ===============================
      // PARSE JSON
      // ===============================
      final jsonString = _extractJson(rawText);
      final result = json.decode(jsonString) as Map<String, dynamic>;

      // ===============================
      // SANITIZE RESULT
      // ===============================
      return _sanitizeResult(result);
    } on TimeoutException {
      return _errorResponse('Timeout koneksi ke AI');
    } on SocketException {
      return _errorResponse('Tidak ada koneksi internet');
    } on FormatException catch (e) {
      return _errorResponse('Format JSON tidak valid: $e');
    } catch (e) {
      return _errorResponse('Gagal analisis: $e');
    }
  }

  /// ===============================
  /// HELPER METHODS
  /// ===============================

  String _detectMimeType(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }

  String _extractText(GenerateContentResponse response) {
    if (response.text != null) {
      return response.text!;
    }

    return response.candidates
        .expand((c) => c.content.parts)
        .whereType<TextPart>()
        .map((e) => e.text)
        .join();
  }

  String _extractJson(String text) {
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');

    if (start == -1 || end == -1 || end <= start) {
      throw const FormatException('JSON tidak ditemukan');
    }

    return text
        .substring(start, end + 1)
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();
  }

  Map<String, dynamic> _sanitizeResult(Map<String, dynamic> result) {
    result.putIfAbsent('status', () => 'Tidak Diketahui');
    result.putIfAbsent('confidence', () => 0);
    result.putIfAbsent('disease', () => null);
    result.putIfAbsent('ripeness', () => '-');
    result.putIfAbsent('quality', () => '-');
    result.putIfAbsent('recommendations', () => []);

    result['confidence'] = (result['confidence'] as num)
        .clamp(0, 100)
        .toDouble();

    if (result['recommendations'] is! List) {
      result['recommendations'] = [];
    }

    return result;
  }

  Map<String, dynamic> _errorResponse(String message) {
    return {
      'status': 'Error',
      'confidence': 0.0,
      'disease': message,
      'ripeness': '-',
      'quality': '-',
      'recommendations': [
        'Pastikan foto jelas',
        'Gunakan pencahayaan cukup',
        'Coba ulangi analisis',
      ],
    };
  }

  void _log(String message) {
    // ignore: avoid_print
    print('🤖 [GeminiAI] $message');
  }
}
