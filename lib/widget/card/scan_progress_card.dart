import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cocoa_sense/controllers/monitoring_controller.dart';

class ScanProgressCard extends StatelessWidget {
  const ScanProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final MonitoringController controller = Get.find<MonitoringController>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.pie_chart,
                  color: Color(0xFF2D7A4F),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'PROGRES PINDAI',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            final double progress = controller.totalEstimatedFruits.value == 0
                ? 0.0
                : controller.scannedPercentage / 100;

            return Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 12,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2D7A4F)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        'Sudah Dipindai',
                        '${controller.totalScannedFruits} Buah',
                        '${controller.scannedPercentage.toStringAsFixed(1)}%',
                        const Color(0xFF2D7A4F),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey[300],
                    ),
                    Expanded(
                      child: _buildStatItem(
                        'Belum Dipindai',
                        '${controller.totalUnscannedFruits} Buah',
                        '${controller.unscannedPercentage.toStringAsFixed(1)}%',
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String subValue, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          subValue,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
