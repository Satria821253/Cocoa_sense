import 'package:get/get.dart';
import 'package:cocoa_sense/controllers/detection_history_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math' as math;

class MonitoringController extends GetxController {
  // Existing Sensor Data
  final phValue = 6.4.obs;
  final sensorCount = 850.obs;
  final isSystemActive = true.obs;
  
  // New Farm Data Inputs
  final totalTrees = 0.obs;
  final totalEstimatedFruits = 0.obs;
  final lastResetDate = Rx<DateTime?>(null);

  // Dependencies
  final DetectionHistoryController _historyController = Get.find<DetectionHistoryController>();

  Timer? _updateTimer;

  @override
  void onInit() {
    super.onInit();
    loadFarmData();
    startDataUpdates();
  }

  @override
  void onClose() {
    _updateTimer?.cancel();
    super.onClose();
  }

  // ===============================
  // FARM DATA PERSISTENCE
  // ===============================
  Future<void> loadFarmData() async {
    final prefs = await SharedPreferences.getInstance();
    totalTrees.value = prefs.getInt('totalTrees') ?? 0;
    totalEstimatedFruits.value = prefs.getInt('totalEstimatedFruits') ?? 0;
    final resetStr = prefs.getString('lastResetDate');
    if (resetStr != null) {
      lastResetDate.value = DateTime.parse(resetStr);
    }
  }

  Future<void> _saveFarmData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalTrees', totalTrees.value);
    await prefs.setInt('totalEstimatedFruits', totalEstimatedFruits.value);
    if (lastResetDate.value != null) {
      await prefs.setString('lastResetDate', lastResetDate.value!.toIso8601String());
    } else {
      await prefs.remove('lastResetDate');
    }
  }

  // ===============================
  // FARM DATA INPUTS
  // ===============================
  // ===============================
  // FARM DATA INPUTS
  // ===============================
  void updateFarmData(int trees, int fruits) async {
    totalTrees.value = trees;
    totalEstimatedFruits.value = fruits;
    await _saveFarmData();
    Get.snackbar(
      'Berhasil',
      'Data kebun diperbarui',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void resetFarmData() async {
    totalTrees.value = 0;
    totalEstimatedFruits.value = 0;
    lastResetDate.value = DateTime.now();
    await _saveFarmData();
    
    Get.snackbar(
      'Reset',
      'Data pohon dan buah telah direset untuk sesi baru',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Validation Check
  bool get canAnalyze => totalEstimatedFruits.value > 0;

  // ===============================
  // BATCH-BASED COMPUTED METRICS
  // ===============================
  List<dynamic> get _batchHistory {
    return _historyController.history.where((e) {
      if (!e.isCocoa) return false;
      if (lastResetDate.value == null) return true;
      return e.timestamp.isAfter(lastResetDate.value!);
    }).toList();
  }

  int get _batchHealthyCount => _batchHistory.where((e) => e.status == 'Sehat').length;
  int get _batchRipeCount => _batchHistory.where((e) => e.ripeness == 'Matang').length;
  int get _batchAnalyzedCount => _batchHistory.length;

  double get harvestPotentialIndex {
    if (totalEstimatedFruits.value == 0) return 0.0;
    
    // Health Score relative to total estimated in current batch
    final healthScore = (_batchHealthyCount / totalEstimatedFruits.value) * 100;
    
    // Ripeness Score relative to total estimated in current batch
    final ripenessScore = (_batchRipeCount / totalEstimatedFruits.value) * 100;
    
    // Weighted Formula: 70% Health + 30% Ripeness
    final score = (healthScore * 0.7) + (ripenessScore * 0.3);
    return score > 100 ? 100.0 : score;
  }

  String get harvestPotentialCategory {
    final index = harvestPotentialIndex;
    if (index > 80) return 'Tinggi';
    if (index >= 50) return 'Sedang';
    return 'Rendah';
  }

  double get healthPercentage {
    if (totalEstimatedFruits.value == 0) return 0.0;
    // (Healthy Fruits / Total Estimated Fruits) * 100 in current batch
    final percentage = (_batchHealthyCount / totalEstimatedFruits.value) * 100;
    return percentage > 100 ? 100.0 : percentage;
  }

  // Scan Progress Metrics (Batch-based)
  int get totalScannedFruits => _batchAnalyzedCount;
  
  int get totalUnscannedFruits {
    if (totalEstimatedFruits.value == 0) return 0;
    final remaining = totalEstimatedFruits.value - totalScannedFruits;
    return remaining > 0 ? remaining : 0;
  }

  double get scannedPercentage {
    if (totalEstimatedFruits.value == 0) return 0.0;
    final percentage = (totalScannedFruits / totalEstimatedFruits.value) * 100;
    return percentage > 100 ? 100.0 : percentage;
  }

  double get unscannedPercentage {
    if (totalEstimatedFruits.value == 0) return 0.0;
    return 100.0 - scannedPercentage;
  }

  String get healthStatusLabel {
    final percentage = healthPercentage;
    if (percentage > 80) return 'Sehat';
    if (percentage >= 50) return 'Cukup';
    return 'Kurang';
  }

  // ===============================
  // EXISTING METHODS
  // ===============================
  void startDataUpdates() {
    _updateTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      phValue.value = 6.4 + (math.Random().nextDouble() - 0.5) * 0.3;
      sensorCount.value = 845 + math.Random().nextInt(15);
    });
  }

  void refreshData() {
    phValue.value = 6.4 + (math.Random().nextDouble() - 0.5) * 0.3;
    sensorCount.value = 845 + math.Random().nextInt(15);
    // Refresh history as well to update metrics
    _historyController.loadHistory();
    
    Get.snackbar(
      'Berhasil',
      'Data berhasil diperbarui',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void exportData() {
    // TODO: Implement export functionality
    Get.snackbar(
      'Export',
      'Fitur export akan segera tersedia',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void viewDetailedAnalytics() {
    // TODO: Navigate to analytics screen
    Get.snackbar(
      'Analytics',
      'Fitur analytics akan segera tersedia',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
