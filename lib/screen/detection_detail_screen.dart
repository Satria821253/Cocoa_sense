import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cocoa_sense/models/detection_result.dart';

class DetectionDetailScreen extends StatelessWidget {
  const DetectionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DetectionResult item = Get.arguments as DetectionResult;
    final bool isHealthy = item.status == 'Sehat';
    final bool isError = item.status == 'Error';
    final bool isNotCocoa = item.status == 'Bukan Kakao';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D7A4F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Detail Deteksi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image Preview
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.black,
              child: Image.file(
                File(item.imagePath),
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Icon(Icons.image_not_supported, size: 80),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Status Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isError
                      ? Colors.red.shade50
                      : (isHealthy
                            ? Colors.green.shade50
                            : Colors.orange.shade50),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isError
                        ? Colors.red
                        : (isHealthy ? Colors.green : Colors.orange),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      isError
                          ? Icons.error_outline
                          : (isHealthy
                                ? Icons.check_circle_outline
                                : Icons.warning_amber),
                      size: 56,
                      color: isError
                          ? Colors.red
                          : (isHealthy ? Colors.green : Colors.orange),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.status,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isError
                            ? Colors.red.shade900
                            : (isHealthy
                                  ? Colors.green.shade900
                                  : Colors.orange.shade900),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Confidence: ${item.confidence.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd MMMM yyyy, HH:mm').format(item.timestamp),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ================= CONTENT =================

            // 1. ERROR
            if (isError) ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 48,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item.disease ?? 'Terjadi kesalahan',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ]
            // 2. BUKAN KAKAO
            else if (isNotCocoa) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.orange),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Objek terdeteksi bukan buah kakao. Informasi detail dan rekomendasi tidak tersedia.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.orange.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]
            // 3. NORMAL (KAKAO)
            else ...[
              _buildDetailCard('Informasi Detail', [
                _DetailRow('Penyakit', item.disease ?? 'Tidak terdeteksi'),
                _DetailRow('Kematangan', item.ripeness),
                _DetailRow('Kualitas', item.quality),
                _DetailRow('ID Deteksi', item.id),
              ]),
              const SizedBox(height: 16),
              _buildRecommendationCard(item.recommendations),
            ],

            const SizedBox(height: 16),

            // Action Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Kembali ke Riwayat'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF2D7A4F),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, List<_DetailRow> details) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D7A4F),
              ),
            ),
            const SizedBox(height: 16),
            ...details.map(
              (detail) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        detail.label,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        detail.value,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(List<String> recommendations) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Color(0xFF2D7A4F)),
                SizedBox(width: 8),
                Text(
                  'Rekomendasi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D7A4F),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (recommendations.isEmpty)
              const Text('Tidak ada rekomendasi')
            else
              ...recommendations.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D7A4F).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D7A4F),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: const TextStyle(fontSize: 14, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow {
  final String label;
  final String value;

  _DetailRow(this.label, this.value);
}

class BotomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);

    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height - 30,
    );

    path.quadraticBezierTo(
      size.width * 3 / 4,
      size.height - 60,
      size.width,
      size.height - 30,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
