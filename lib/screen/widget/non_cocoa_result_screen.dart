import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widget/card/recommendation_card.dart';

class NonCocoaResultScreen extends StatelessWidget {
  final String imagePath;
  final Map<String, dynamic> result;

  const NonCocoaResultScreen({
    super.key,
    required this.imagePath,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final List recommendations = result['recommendations'] ?? const [];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D7A4F),
        title: const Text(
          'Hasil Analisis AI',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image
            Container(
              width: double.infinity,
              height: 250,
              color: Colors.black,
              child: Image.file(File(imagePath), fit: BoxFit.contain),
            ),

            const SizedBox(height: 16),

            // Info Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange, width: 2),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 64,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Bukan Buah Kakao',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      result['object_detected'] ?? 'Objek tidak dikenali',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            RecommendationCard(recommendations: recommendations),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton.icon(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.refresh),
                label: const Text('Scan Ulang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
