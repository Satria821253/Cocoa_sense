import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cocoa_sense/controllers/map_controller.dart';
import 'package:cocoa_sense/widget/card/gps_tracker_card.dart';
import 'package:cocoa_sense/widget/card/location_info_card.dart';
import 'package:cocoa_sense/widget/compas_widgate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildHeader() {
  return Positioned(
    top: 0,
    left: 0,
    right: 0,
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
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
                child: const Icon(Icons.eco, color: Colors.white, size: 24),
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
                    'PETA KEBUN',
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
  );
}

Widget buildBottomSheet(MapController controller) {
  return DraggableScrollableSheet(
    initialChildSize: 0.35,
    minChildSize: 0.15,
    maxChildSize: 0.8,
    builder: (context, scrollController) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Obx(
          () => ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const LocationInfoCard(),
              const SizedBox(height: 16),
              if (controller.currentPosition.value != null)
                GpsTrackerCard(
                  kebunName: 'Kebun Blok C - JPB',
                  location: 'Jonggol',
                  latitude: controller.currentPosition.value!.latitude
                      .toStringAsFixed(6),
                  longitude: controller.currentPosition.value!.longitude
                      .toStringAsFixed(6),
                  accuracy:
                      'TINGGI (±${controller.currentPosition.value!.accuracy.toStringAsFixed(1)}M)',
                  bearing: controller.currentPosition.value!.heading
                      .toStringAsFixed(1),
                  speed: (controller.currentPosition.value!.speed * 3.6)
                      .toStringAsFixed(1),
                ),
              const SizedBox(height: 16),
              const Text(
                'AKSI CEPAT',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: buildQuickActionCard(
                      icon: controller.currentMapType.value == MapType.normal
                          ? Icons.satellite_alt
                          : Icons.map,
                      label: controller.currentMapType.value == MapType.normal
                          ? 'Satelit'
                          : 'Peta',
                      color: Colors.orange,
                      onTap: controller.toggleMapType,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: buildQuickActionCard(
                      icon: Icons.share_location,
                      label: 'Bagikan',
                      color: Colors.purple,
                      onTap: () => shareLocation(controller),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              buildQuickActionCard(
                icon: Icons.map,
                label: 'Buka di Google Maps',
                color: const Color(0xFF2D7A4F),
                onTap: () => openInGoogleMaps(controller),
                fullWidth: true,
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget buildFloatingButtons(MapController controller) {
  return Positioned(
    right: 16,
    bottom: 250,
    child: Obx(
      () => Column(
        children: [
          if (controller.currentPosition.value != null)
            CompassWidget(bearing: controller.currentBearing.value),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'location',
            mini: true,
            onPressed: controller.goToCurrentLocation,
            backgroundColor: Colors.white,
            child: const Icon(Icons.my_location, color: Color(0xFF2D7A4F)),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'zoom_in',
            mini: true,
            onPressed: () =>
                controller.mapController?.animateCamera(CameraUpdate.zoomIn()),
            backgroundColor: Colors.white,
            child: const Icon(Icons.add, color: Color(0xFF2D7A4F)),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'zoom_out',
            mini: true,
            onPressed: () =>
                controller.mapController?.animateCamera(CameraUpdate.zoomOut()),
            backgroundColor: Colors.white,
            child: const Icon(Icons.remove, color: Color(0xFF2D7A4F)),
          ),
        ],
      ),
    ),
  );
}

Widget buildQuickActionCard({
  required IconData icon,
  required String label,
  required Color color,
  required VoidCallback onTap,
  bool fullWidth = false,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: fullWidth
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
    ),
  );
}

Future<void> shareLocation(MapController controller) async {
  if (controller.currentPosition.value != null) {
    final lat = controller.currentPosition.value!.latitude;
    final lng = controller.currentPosition.value!.longitude;
    final message =
        '''
📍 Lokasi Kebun Cocoa-Sense

Kebun Blok C - JPB
Jonggol

Koordinat:
Latitude: $lat
Longitude: $lng

Google Maps: https://maps.google.com/?q=$lat,$lng
      ''';
    await Share.share(message, subject: 'Lokasi Kebun Kakao');
  } else {
    Get.snackbar('Error', 'Lokasi belum tersedia');
  }
}

Future<void> openInGoogleMaps(MapController controller) async {
  if (controller.currentPosition.value != null) {
    final lat = controller.currentPosition.value!.latitude;
    final lng = controller.currentPosition.value!.longitude;

    final Uri googleMapsUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    final Uri googleMapsApp = Uri.parse('comgooglemaps://?q=$lat,$lng');

    try {
      if (await canLaunchUrl(googleMapsApp)) {
        await launchUrl(googleMapsApp, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(googleMapsUri)) {
        await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Tidak dapat membuka Google Maps';
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  } else {
    Get.snackbar('Error', 'Lokasi belum tersedia');
  }
}
