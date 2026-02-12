import 'package:flutter/material.dart';
import 'dart:math' as math;

class CompassWidget extends StatelessWidget {
  final double bearing;

  const CompassWidget({
    super.key,
    required this.bearing,
  });

  String _getCompassDirection(double bearing) {
    if (bearing >= 337.5 || bearing < 22.5) return 'U'; // Utara
    if (bearing >= 22.5 && bearing < 67.5) return 'TL'; // Timur Laut
    if (bearing >= 67.5 && bearing < 112.5) return 'T'; // Timur
    if (bearing >= 112.5 && bearing < 157.5) return 'TG'; // Tenggara
    if (bearing >= 157.5 && bearing < 202.5) return 'S'; // Selatan
    if (bearing >= 202.5 && bearing < 247.5) return 'BD'; // Barat Daya
    if (bearing >= 247.5 && bearing < 292.5) return 'B'; // Barat
    if (bearing >= 292.5 && bearing < 337.5) return 'BL'; // Barat Laut
    return 'U';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Compass Circle
          CustomPaint(
            size: const Size(60, 60),
            painter: CompassPainter(bearing: bearing),
          ),
          
          // Direction Arrow
          Transform.rotate(
            angle: -bearing * math.pi / 180,
            child: const Icon(
              Icons.navigation,
              color: Color(0xFF2D7A4F),
              size: 24,
            ),
          ),
          
          // Direction Label at bottom
          Positioned(
            bottom: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF2D7A4F),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _getCompassDirection(bearing),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CompassPainter extends CustomPainter {
  final double bearing;

  CompassPainter({required this.bearing});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;

    // Draw cardinal points (N, S, E, W)
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw circle
    canvas.drawCircle(center, radius, paint);

    // Draw tick marks
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45 - 90) * math.pi / 180;
      final startX = center.dx + (radius - 5) * math.cos(angle);
      final startY = center.dy + (radius - 5) * math.sin(angle);
      final endX = center.dx + radius * math.cos(angle);
      final endY = center.dy + radius * math.sin(angle);

      final tickPaint = Paint()
        ..color = i % 2 == 0 ? Colors.grey.shade400 : Colors.grey.shade300
        ..strokeWidth = i % 2 == 0 ? 2 : 1;

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        tickPaint,
      );
    }

    // Draw North indicator
    final northAngle = -90 * math.pi / 180;
    final northX = center.dx + (radius - 8) * math.cos(northAngle);
    final northY = center.dy + (radius - 8) * math.sin(northAngle);

    final northPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(northX, northY), 3, northPaint);
  }

  @override
  bool shouldRepaint(CompassPainter oldDelegate) {
    return bearing != oldDelegate.bearing;
  }
}