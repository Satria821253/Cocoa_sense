class DetectionResult {
  final String id;
  final bool isCocoa;
  final String objectDetected;
  final String imagePath;
  final String status;
  final double confidence;
  final String? disease;
  final String ripeness;
  final String quality;
  final List<String> recommendations;
  final DateTime timestamp;

  DetectionResult({
    required this.id,
    required this.isCocoa,
    required this.objectDetected,
    required this.imagePath,
    required this.status,
    required this.confidence,
    this.disease,
    required this.ripeness,
    required this.quality,
    required this.recommendations,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'isCocoa': isCocoa,
    'objectDetected': objectDetected,
    'imagePath': imagePath,
    'status': status,
    'confidence': confidence,
    'disease': disease,
    'ripeness': ripeness,
    'quality': quality,
    'recommendations': recommendations,
    'timestamp': timestamp.toIso8601String(),
  };

  factory DetectionResult.fromJson(Map<String, dynamic> json) {
    return DetectionResult(
      id: json['id'] ?? '',
      isCocoa: json['isCocoa'] ?? false,
      objectDetected: json['objectDetected'] ?? '',
      imagePath: json['imagePath'] ?? '',
      status: json['status'] ?? 'Tidak diketahui',
      confidence: (json['confidence'] ?? 0).toDouble(),
      disease: json['disease'],
      ripeness: json['ripeness'] ?? '-',
      quality: json['quality'] ?? '-',
      recommendations: (json['recommendations'] as List?)?.cast<String>() ?? [],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
