import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart' as cam;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class CameraController extends GetxController {
  cam.CameraController? cameraController;
  final ImagePicker _picker = ImagePicker();
  final isFlashOn = false.obs;
  final isCameraInitialized = false.obs;
  final capturedImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    initCamera();
  }

  Future<void> initCamera() async {
    print('🎥 [Camera] Mulai inisialisasi kamera...');
    try {
      // Request camera permission
      print('🎥 [Camera] Meminta permission kamera...');
      final status = await Permission.camera.request();
      print('🎥 [Camera] Status permission: $status');

      if (!status.isGranted) {
        print('❌ [Camera] Permission kamera ditolak');
        isCameraInitialized.value = false;
        Get.snackbar(
          'Error',
          'Izin kamera diperlukan untuk menggunakan fitur ini',
        );
        return;
      }

      print('🎥 [Camera] Mengambil daftar kamera...');
      final cameras = await cam.availableCameras();
      print('🎥 [Camera] Jumlah kamera ditemukan: ${cameras.length}');

      if (cameras.isEmpty) {
        print('❌ [Camera] Tidak ada kamera tersedia');
        isCameraInitialized.value = false;
        return;
      }

      print('🎥 [Camera] Membuat CameraController...');
      cameraController = cam.CameraController(
        cameras.first,
        cam.ResolutionPreset.high,
        enableAudio: false,
      );

      print('🎥 [Camera] Menginisialisasi kamera...');
      await cameraController!.initialize();
      print('✅ [Camera] Kamera berhasil diinisialisasi');
      isCameraInitialized.value = true;
      print('✅ [Camera] isCameraInitialized = true');
    } catch (e) {
      print('❌ [Camera] Error inisialisasi: $e');
      isCameraInitialized.value = false;
      Get.snackbar('Error', 'Gagal inisialisasi kamera: $e');
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        capturedImage.value = File(image.path);
        Get.toNamed('/photo-result', arguments: image.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memilih gambar: $e');
    }
  }

  Future<void> capturePhoto(BuildContext context, double scanAreaSize) async {
    if (cameraController == null || !cameraController!.value.isInitialized)
      return;

    try {
      final image = await cameraController!.takePicture();

      final croppedPath = await _cropToScanArea(
        file: image,
        screenSize: MediaQuery.of(context).size,
        scanAreaSize: scanAreaSize,
      );

      capturedImage.value = File(croppedPath);
      Get.toNamed('/photo-result', arguments: croppedPath);
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil foto: $e');
    }
  }

  //FUNGSI UNTUK CROP UKURAN FOTO SESUAI DENGAN SCAN
  Future<String> _cropToScanArea({
    required cam.XFile file,
    required Size screenSize,
    required double scanAreaSize,
  }) async {
    final Uint8List bytes = await file.readAsBytes();
    final img.Image original = img.decodeImage(bytes)!;

    final previewSize = cameraController!.value.previewSize!;

    final previewRatio = previewSize.height / previewSize.width;
    final screenRatio = screenSize.height / screenSize.width;

    double scaleX, scaleY, offsetX = 0, offsetY = 0;

    if (screenRatio > previewRatio) {
      scaleX = original.width / screenSize.width;
      scaleY = scaleX;
      offsetY = (original.height - screenSize.height * scaleY) / 2;
    } else {
      scaleY = original.height / screenSize.height;
      scaleX = scaleY;
      offsetX = (original.width - screenSize.width * scaleX) / 2;
    }

    final left = ((screenSize.width - scanAreaSize) / 2 * scaleX + offsetX)
        .round();
    final top = ((screenSize.height - scanAreaSize) / 2 * scaleY + offsetY)
        .round();
    final size = (scanAreaSize * scaleX).round();

    final cropped = img.copyCrop(
      original,
      x: left,
      y: top,
      width: size,
      height: size,
    );

    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/scan_result_${DateTime.now().millisecondsSinceEpoch}.jpg';

    await File(path).writeAsBytes(img.encodeJpg(cropped, quality: 95));
    return path;
  }

  Future<void> toggleFlash() async {
    if (cameraController == null) return;

    try {
      isFlashOn.value = !isFlashOn.value;
      await cameraController!.setFlashMode(
        isFlashOn.value ? cam.FlashMode.torch : cam.FlashMode.off,
      );
    } catch (e) {
      Get.snackbar('Error', 'Gagal toggle flash: $e');
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}
