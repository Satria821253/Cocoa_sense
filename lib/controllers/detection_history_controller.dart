import 'package:get/get.dart';
import 'package:cocoa_sense/models/detection_result.dart';
import 'package:cocoa_sense/services/detection_history_service.dart';

class DetectionHistoryController extends GetxController {
  final _historyService = DetectionHistoryService();

  final history = <DetectionResult>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      isLoading.value = true;
      final data = await _historyService.getHistory();
      history.value = data;
    } finally {
      isLoading.value = false;
    }
  }

  DetectionResult? get latestDetection =>
      history.isNotEmpty ? history.first : null;

  int get totalAnalyzedFruits => history.where((e) => e.isCocoa).length;
  int get totalHealthyFruits =>
      history.where((e) => e.isCocoa && e.status == 'Sehat').length;
  int get totalUnhealthyFruits =>
      history.where((e) => e.isCocoa && e.status == 'Sakit').length;

  // Ripeness Analytics
  int get totalRipeFruits =>
      history.where((e) => e.isCocoa && e.ripeness == 'Matang').length;
  int get totalSemiRipeFruits =>
      history.where((e) => e.isCocoa && e.ripeness == 'Setengah Matang').length;
  int get totalUnripeFruits =>
      history.where((e) => e.isCocoa && e.ripeness == 'Mentah').length;

  Future<void> saveDetection(DetectionResult result) async {
    try {
      await _historyService.saveDetection(result);
      await loadHistory();

      print('SAVE DETECTION DIPANGGIL');
      print(result.toJson());
      print('JUMLAH RIWAYAT: ${history.length}');
    } catch (e) {
      print('ERROR SAVE DETECTION: $e');
    }
  }

  Future<void> deleteDetection(String id) async {
    await _historyService.deleteDetection(id);
    await loadHistory();
    Get.snackbar(
      'Berhasil',
      'Riwayat dihapus',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> clearHistory() async {
    await _historyService.clearHistory();
    await loadHistory();
    Get.snackbar(
      'Berhasil',
      'Semua riwayat dihapus',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
