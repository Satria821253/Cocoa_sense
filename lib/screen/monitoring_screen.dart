import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cocoa_sense/controllers/monitoring_controller.dart';
import 'package:cocoa_sense/screen/widget/monitoring_widgets.dart';

class MonitoringScreen extends StatelessWidget {
  const MonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MonitoringController(), tag: 'monitoring');

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // AppBar seperti Home
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D7A4F),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.eco,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'COCOA-SENSE',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'MONITORING SISTEM',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {},
                    color: Colors.black87,
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Status Card
                    _buildStatusCard(controller),

                    const SizedBox(height: 24),

                    // Sensor Status List
                    const SectionHeader(
                      title: 'Status Sensor',
                      subtitle: '12 sensor aktif',
                    ),

                    const SizedBox(height: 12),

                    Obx(
                      () => SensorStatusCard(
                        sensorName: 'Sensor pH Tanah A1',
                        location: 'Blok Jonggol - Area A',
                        status: 'Normal',
                        value: controller.phValue.value.toStringAsFixed(1),
                        isActive: true,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Obx(
                      () => SensorStatusCard(
                        sensorName: 'Sensor Cahaya B2',
                        location: 'Blok Jonggol - Area B',
                        status: 'Normal',
                        value: '${controller.sensorCount.value} lux',
                        isActive: true,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const SensorStatusCard(
                      sensorName: 'Sensor Kelembaban C3',
                      location: 'Blok Jonggol - Area C',
                      status: 'Normal',
                      value: '68%',
                      isActive: true,
                    ),

                    const SizedBox(height: 24),

                    // Quick Actions
                    const SectionHeader(
                      title: 'Aksi Cepat',
                      subtitle: 'Kelola monitoring',
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: ActionButton(
                            icon: Icons.refresh,
                            label: 'Refresh Data',
                            onTap: controller.refreshData,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ActionButton(
                            icon: Icons.download_outlined,
                            label: 'Export Data',
                            onTap: controller.exportData,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: ActionButton(
                        icon: Icons.analytics_outlined,
                        label: 'Lihat Grafik Detail',
                        onTap: controller.viewDetailedAnalytics,
                        isPrimary: true,
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

  Widget _buildStatusCard(MonitoringController controller) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Animated Heartbeat Icon
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1500),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 1.0 + (value * 0.15),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.offline_bolt,
                    size: 40,
                    color: Colors.green[600],
                  ),
                ),
              );
            },
            onEnd: () {},
          ),

          const SizedBox(height: 24),

          const Text(
            'Sistem Monitoring Aktif',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Terhubung ke 12 sensor di blok kebun Jonggol. Semua sistem berjalan normal.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),

          const SizedBox(height: 32),

          // Metrics Row
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: MetricCard(
                    label: 'PH TANAH',
                    value: controller.phValue.value.toStringAsFixed(1),
                    unit: 'Ideal',
                    color: Colors.blue,
                    trend: 'stable',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: MetricCard(
                    label: 'INTENSITAS CAHAYA',
                    value: controller.sensorCount.value.toString(),
                    unit: 'lux',
                    color: Colors.orange,
                    trend: 'up',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
