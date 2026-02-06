import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:cocoa_sense/controllers/camera_controller.dart' as cam_ctrl;

class CameraScanScreen extends StatefulWidget {
  const CameraScanScreen({super.key});

  @override
  State<CameraScanScreen> createState() => _CameraScanScreenState();
}

class _CameraScanScreenState extends State<CameraScanScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late cam_ctrl.CameraController controller;

  @override
  void initState() {
    super.initState();
    // Use lazyPut with tag to avoid multiple instances
    if (!Get.isRegistered<cam_ctrl.CameraController>(tag: 'camera')) {
      Get.lazyPut(() => cam_ctrl.CameraController(), tag: 'camera');
    }
    controller = Get.find<cam_ctrl.CameraController>(tag: 'camera');

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    // Clean up camera controller when screen is disposed
    if (Get.isRegistered<cam_ctrl.CameraController>(tag: 'camera')) {
      Get.delete<cam_ctrl.CameraController>(tag: 'camera');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scanAreaSize = size.width * 0.7;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          Obx(() {
            if (!controller.isCameraInitialized.value ||
                controller.cameraController == null) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.green),
                ),
              );
            }

            return SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CameraPreview(controller.cameraController!),
            );
          }),

          // Dark Overlay with Cut-out
          CustomPaint(
            size: Size(size.width, size.height),
            painter: ScannerOverlayPainter(
              scanAreaSize: scanAreaSize,
              borderColor: Colors.green,
            ),
          ),

          // Animated Scanning Line
          Positioned.fill(
            child: Center(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(scanAreaSize, scanAreaSize),
                    painter: ScanningLinePainter(
                      progress: _animation.value,
                      scanAreaSize: scanAreaSize,
                    ),
                  );
                },
              ),
            ),
          ),

          // Close Button (Top Left)
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Get.back(),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Instruction Text
          Positioned(
            left: 0,
            right: 0,
            top: size.height * 0.5 + scanAreaSize / 2 + 40,
            child: Column(
              children: [
                const Text(
                  'Align cocoa pod within the frame',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Point camera for accurate scanning',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Bottom Controls
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Gallery Button
                    _BottomControlButton(
                      icon: Icons.photo_library_outlined,
                      onTap: controller.pickImageFromGallery,
                    ),

                    // Capture Button
                    GestureDetector(
                      onTap: () =>
                          controller.capturePhoto(context, scanAreaSize),
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: Center(
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Flash Button
                    Obx(
                      () => _BottomControlButton(
                        icon: controller.isFlashOn.value
                            ? Icons.flash_on
                            : Icons.flash_off,
                        onTap: controller.toggleFlash,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Scanner Overlay Painter (Dark overlay with transparent square)
class ScannerOverlayPainter extends CustomPainter {
  final double scanAreaSize;
  final Color borderColor;

  ScannerOverlayPainter({
    required this.scanAreaSize,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double scanAreaLeft = (size.width - scanAreaSize) / 2;
    final double scanAreaTop = (size.height - scanAreaSize) / 2;

    // Draw dark overlay
    final paint = Paint()..color = Colors.black.withOpacity(0.7);
    canvas.drawPath(
      Path()
        ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              scanAreaLeft,
              scanAreaTop,
              scanAreaSize,
              scanAreaSize,
            ),
            const Radius.circular(20),
          ),
        )
        ..fillType = PathFillType.evenOdd,
      paint,
    );

    // Draw corner borders
    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLength = 30.0;
    const borderRadius = 20.0;

    // Top-left corner
    canvas.drawPath(
      Path()
        ..moveTo(scanAreaLeft + borderRadius, scanAreaTop)
        ..lineTo(scanAreaLeft + cornerLength, scanAreaTop)
        ..moveTo(scanAreaLeft, scanAreaTop + borderRadius)
        ..lineTo(scanAreaLeft, scanAreaTop + cornerLength),
      borderPaint,
    );

    // Top-right corner
    canvas.drawPath(
      Path()
        ..moveTo(scanAreaLeft + scanAreaSize - borderRadius, scanAreaTop)
        ..lineTo(scanAreaLeft + scanAreaSize - cornerLength, scanAreaTop)
        ..moveTo(scanAreaLeft + scanAreaSize, scanAreaTop + borderRadius)
        ..lineTo(scanAreaLeft + scanAreaSize, scanAreaTop + cornerLength),
      borderPaint,
    );

    // Bottom-left corner
    canvas.drawPath(
      Path()
        ..moveTo(scanAreaLeft + borderRadius, scanAreaTop + scanAreaSize)
        ..lineTo(scanAreaLeft + cornerLength, scanAreaTop + scanAreaSize)
        ..moveTo(scanAreaLeft, scanAreaTop + scanAreaSize - borderRadius)
        ..lineTo(scanAreaLeft, scanAreaTop + scanAreaSize - cornerLength),
      borderPaint,
    );

    // Bottom-right corner
    canvas.drawPath(
      Path()
        ..moveTo(
          scanAreaLeft + scanAreaSize - borderRadius,
          scanAreaTop + scanAreaSize,
        )
        ..lineTo(
          scanAreaLeft + scanAreaSize - cornerLength,
          scanAreaTop + scanAreaSize,
        )
        ..moveTo(
          scanAreaLeft + scanAreaSize,
          scanAreaTop + scanAreaSize - borderRadius,
        )
        ..lineTo(
          scanAreaLeft + scanAreaSize,
          scanAreaTop + scanAreaSize - cornerLength,
        ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Scanning Line Painter (Animated line)
class ScanningLinePainter extends CustomPainter {
  final double progress;
  final double scanAreaSize;

  ScanningLinePainter({required this.progress, required this.scanAreaSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.green.withOpacity(0.0),
          Colors.green.withOpacity(0.8),
          Colors.green.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, scanAreaSize, 2))
      ..strokeWidth = 2;

    final y = progress * (scanAreaSize - 40) + 20;

    canvas.drawLine(Offset(20, y), Offset(scanAreaSize - 20, y), paint);
  }

  @override
  bool shouldRepaint(covariant ScanningLinePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// Bottom Control Button Widget
class _BottomControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _BottomControlButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
