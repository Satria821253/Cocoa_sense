import 'package:cocoa_sense/widget/card/feature_card.dart';
import 'package:cocoa_sense/widget/card/info_card.dart';
import 'package:cocoa_sense/widget/card/sensor_realtime_card.dart';
import 'package:cocoa_sense/widget/card/recent_detection_card.dart';
import 'package:cocoa_sense/widget/card/scan_progress_card.dart';
import 'package:cocoa_sense/widget/garden_status.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cocoa_sense/controllers/monitoring_controller.dart';
import 'package:cocoa_sense/widget/dialogs/input_data_farm_dialog.dart';
import 'package:cocoa_sense/screen/detection_history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is available (it should be init in main or lazily here)
    final controller = Get.put(MonitoringController(), permanent: true);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
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
                              'BERANDA',
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
                const SizedBox(height: 24),

                // Garden Status Card (Connected to Real Data)
                GestureDetector(
                  onTap: () => FarmDataDialog.show(context, controller),
                  child: Stack(
                    children: [
                      Obx(
                        () => GardenStatusCard(
                          gardenName: 'Kebun Jonggol Blok C',
                          pohon: controller.totalTrees.value > 0
                              ? controller.totalTrees.value
                              : 0,
                          buah: controller.totalEstimatedFruits.value > 0
                              ? '~${controller.totalEstimatedFruits.value}'
                              : 'Set Data',
                          kesehatan:
                              '${controller.healthPercentage.toStringAsFixed(1)}%',
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Scan Progress Card
                const ScanProgressCard(),
                const SizedBox(height: 24),

                // Info Cards Row (Harvest Potential & Category)
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => InfoCard(
                          label: 'POTENSI PANEN',
                          value: controller.harvestPotentialIndex
                              .toStringAsFixed(1),
                          unit: '%',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Obx(
                        () => InfoCard(
                          label: 'KATEGORI',
                          value: controller.harvestPotentialCategory,
                          unit: '',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Deteksi AI Card
                const FeatureCard(
                  icon: Icons.camera_alt,
                  title: 'Deteksi AI',
                  subtitle: 'Scan buah kakao\nsekarang',
                ),
                const SizedBox(height: 20),

                // Sensor Section Header
                Row(
                  children: [
                    const Icon(
                      Icons.show_chart,
                      size: 20,
                      color: Color(0xFF2D7A4F),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'SENSOR KEBUN REAL-TIME',
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

                // Sensor Temperature Card
                SensorRealtimeCard(
                  sensorType: 'Suhu Udara',
                  currentValue: 28.4,
                  unit: '°C',
                  icon: Icons.thermostat,
                  chartData: const [
                    27.5,
                    27.8,
                    28.0,
                    28.2,
                    28.5,
                    28.3,
                    28.4,
                    28.6,
                    28.4,
                  ],
                ),
                const SizedBox(height: 20),

                // Recent Detection Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.history,
                                size: 20,
                                color: Color(0xFF2D7A4F),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'DETEKSI TERKINI',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const DetectionHistoryScreen());
                            },
                            child: const Text(
                              'Lihat Semua',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D7A4F),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Recent Detection Card
                      const RecentDetectionCard(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
