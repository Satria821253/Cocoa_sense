import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class GpsTrackerCard extends StatelessWidget {
  final String kebunName;
  final String location;
  final String latitude;
  final String longitude;
  final String accuracy;
  final String? bearing;
  final String? speed;

  const GpsTrackerCard({
    super.key,
    required this.kebunName,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    this.bearing,
    this.speed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF2D7A4F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.gps_fixed,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GPS Tracker Kebun',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          'AKURASI: ',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'TINGGI (+3M)',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF2D7A4F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Kebun Info
          _buildInfoRow(
            label: 'NAMA\nKEBUN',
            value: kebunName,
            showCopy: false,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            label: 'LOCATION',
            value: location,
            showCopy: false,
          ),
          
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade200, thickness: 1),
          const SizedBox(height: 16),

          // Coordinates
          _buildInfoRow(
            label: 'LATITUDE',
            value: latitude,
            showCopy: true,
            onCopy: () => _copyToClipboard(context, latitude, 'Latitude'),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            label: 'LONGITUDE',
            value: longitude,
            showCopy: true,
            onCopy: () => _copyToClipboard(context, longitude, 'Longitude'),
          ),

          // Real-time data
          if (bearing != null) ...[
            const SizedBox(height: 16),
            _buildInfoRow(
              label: 'ARAH',
              value: '${bearing}° ${_getCompassDirection(double.tryParse(bearing!) ?? 0)}',
              showCopy: false,
            ),
          ],
          if (speed != null) ...[
            const SizedBox(height: 16),
            _buildInfoRow(
              label: 'KECEPATAN',
              value: '$speed km/h',
              showCopy: false,
            ),
          ],

          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _shareLocation(context),
                  icon: const Icon(Icons.share, size: 18),
                  label: const Text('Bagikan'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2D7A4F),
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _openInGoogleMaps(context),
                  icon: const Icon(Icons.map, size: 18),
                  label: const Text('Buka'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D7A4F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required bool showCopy,
    VoidCallback? onCopy,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (showCopy)
                InkWell(
                  onTap: onCopy,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.copy,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label berhasil disalin'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF2D7A4F),
      ),
    );
  }

  String _getCompassDirection(double bearing) {
    if (bearing >= 337.5 || bearing < 22.5) return 'Utara';
    if (bearing >= 22.5 && bearing < 67.5) return 'Timur Laut';
    if (bearing >= 67.5 && bearing < 112.5) return 'Timur';
    if (bearing >= 112.5 && bearing < 157.5) return 'Tenggara';
    if (bearing >= 157.5 && bearing < 202.5) return 'Selatan';
    if (bearing >= 202.5 && bearing < 247.5) return 'Barat Daya';
    if (bearing >= 247.5 && bearing < 292.5) return 'Barat';
    if (bearing >= 292.5 && bearing < 337.5) return 'Barat Laut';
    return '';
  }

  void _shareLocation(BuildContext context) async {
    final message = '''
📍 Lokasi Kebun Cocoa-Sense

$kebunName
$location

Koordinat:
Latitude: $latitude
Longitude: $longitude

Google Maps: https://maps.google.com/?q=$latitude,$longitude
    ''';
    
    await Share.share(message, subject: 'Lokasi Kebun Kakao');
  }

  void _openInGoogleMaps(BuildContext context) async {
    final Uri googleMapsUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    final Uri googleMapsApp = Uri.parse('comgooglemaps://?q=$latitude,$longitude');
    
    try {
      if (await canLaunchUrl(googleMapsApp)) {
        await launchUrl(googleMapsApp, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(googleMapsUri)) {
        await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Tidak dapat membuka Google Maps';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}