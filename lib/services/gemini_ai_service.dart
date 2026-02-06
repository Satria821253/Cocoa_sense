import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiAIService {
  static const String _apiKey = 'AIzaSyANwWMI8kashkndsA4pGz_5H1sCIlYyO0s';

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
Kamu adalah sistem AI vision untuk analisis buah kakao.

TUGAS UTAMA:
1. Tentukan apakah objek pada gambar adalah BUAH KAKAO.
2. JIKA BUKAN BUAH KAKAO:
   - is_cocoa = false
   - status, ripeness, quality, disease = null
   - confidence = 0
   - recommendations berisi pesan bahwa objek bukan buah kakao
3. JIKA BUAH KAKAO:
   - lakukan analisis penyakit, kematangan, dan kualitas

ATURAN OUTPUT:
- HARUS JSON VALID
- TANPA markdown
- TANPA teks tambahan
- TANPA emoji

FORMAT WAJIB:

{
  "is_cocoa": true | false,
  "object_detected": "buah kakao" | "bukan buah kakao" | "tidak jelas",
  "status": "Sehat" | "Sakit" | null,
  "confidence": 0-100,
  "disease": string | null,
  "ripeness": "Mentah" | "Setengah Matang" | "Matang" | null,
  "quality": "Premium" | "Grade A" | "Grade B" | "Perlu Perhatian" null,
  "recommendations": []
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

  double _safeConfidence(dynamic value) {
    if (value is num) {
      return value.clamp(0, 100).toDouble();
    }
    return 0.0;
  }

  String? _safeNullableString(dynamic value) {
    if (value is String && value.trim().isNotEmpty) {
      return value;
    }
    return null;
  }

  String? _safeEnum(
    dynamic value, {
    required List<String> allowed,
    String? fallback,
  }) {
    if (value is String && allowed.contains(value)) {
      return value;
    }
    return fallback;
  }

  List<String> _safeList(dynamic value, {List<String>? fallback}) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return fallback ?? [];
  }

  Map<String, dynamic> _sanitizeResult(Map<String, dynamic> result) {
    // ===============================
    // VALIDATE CORE FLAG
    // ===============================
    final bool isCocoa = result['is_cocoa'] == true;

    // ===============================
    // NON-COCOA OBJECT
    // ===============================
    if (!isCocoa) {
      return {
        'is_cocoa': false,
        'object_detected': result['object_detected'] ?? 'bukan buah kakao',
        'status': null,
        'confidence': 0.0,
        'disease': null,
        'ripeness': null,
        'quality': null,
        'recommendations': _safeList(
          result['recommendations'],
          fallback: [
            'Objek pada gambar bukan buah kakao',
            'Silakan unggah foto buah kakao yang terlihat jelas',
            'Pastikan buah kakao terlihat utuh dan fokus',
          ],
        ),
      };
    }

    // ===============================
    // COCOA OBJECT
    // ===============================
    return {
      'is_cocoa': true,
      'object_detected': result['object_detected'] ?? 'buah kakao',
      'status': _safeEnum(
        result['status'],
        allowed: ['Sehat', 'Sakit'],
        fallback: 'Tidak Diketahui',
      ),
      'confidence': _safeConfidence(result['confidence']),
      'disease': _safeNullableString(result['disease']),
      'ripeness': _safeEnum(
        result['ripeness'],
        allowed: ['Mentah', 'Setengah Matang', 'Matang'],
        fallback: null,
      ),
      'quality': _safeEnum(
        result['quality'],
        allowed: ['Premium', 'Grade A', 'Grade B', 'Perlu Perhatian'],
        fallback: null,
      ),
      'recommendations': _safeList(result['recommendations']),
    };
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
