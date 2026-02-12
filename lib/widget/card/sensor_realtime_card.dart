import 'package:flutter/material.dart';

class SensorRealtimeCard extends StatelessWidget {
  final String sensorType;
  final double currentValue;
  final String unit;
  final IconData icon;
  final List<double> chartData;

  const SensorRealtimeCard({
    super.key,
    required this.sensorType,
    required this.currentValue,
    required this.unit,
    required this.icon,
    required this.chartData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sensorType.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentValue.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        unit,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.red.shade400,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Chart
          SizedBox(
            height: 80,
            child: CustomPaint(
              painter: LineChartPainter(
                data: chartData,
                color: Colors.red.shade300,
              ),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;

  LineChartPainter({
    required this.data,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final backgroundPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(0.2),
          color.withOpacity(0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final backgroundPath = Path();

    // Find min and max values for scaling
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final minValue = data.reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;

    // Calculate points
    final stepX = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final normalizedValue = range != 0 
          ? (data[i] - minValue) / range 
          : 0.5;
      final y = size.height - (normalizedValue * size.height * 0.7) - (size.height * 0.15);

      if (i == 0) {
        path.moveTo(x, y);
        backgroundPath.moveTo(x, size.height);
        backgroundPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        backgroundPath.lineTo(x, y);
      }
    }

    // Complete background path
    backgroundPath.lineTo(size.width, size.height);
    backgroundPath.close();

    // Draw background first
    canvas.drawPath(backgroundPath, backgroundPaint);
    
    // Draw line on top
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}