import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:cocoa_sense/controllers/map_controller.dart';
import 'package:cocoa_sense/widget/map_screen_helpers.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MapController(), tag: 'map');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Stack(
          children: [
            // Google Maps
            Obx(
              () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : GoogleMap(
                      onMapCreated: controller.onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: controller.currentPosition.value != null
                            ? LatLng(
                                controller.currentPosition.value!.latitude,
                                controller.currentPosition.value!.longitude,
                              )
                            : MapController.defaultLocation,
                        zoom: controller.currentZoom.value,
                        bearing: controller.currentBearing.value,
                      ),
                      markers: controller.markers,
                      circles: controller.circles,
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      compassEnabled: false,
                      mapType: controller.currentMapType.value,
                      zoomControlsEnabled: false,
                      rotateGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      tiltGesturesEnabled: true,
                      zoomGesturesEnabled: true,
                      onCameraMove: controller.onCameraMove,
                    ),
            ),

            // Header
            buildHeader(),

            // Bottom Sheet
            buildBottomSheet(controller),

            // Floating Buttons
            buildFloatingButtons(controller),
          ],
        ),
      ),
    );
  }
}
