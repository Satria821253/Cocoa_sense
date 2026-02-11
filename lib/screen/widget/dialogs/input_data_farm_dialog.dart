import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/monitoring_controller.dart';

class FarmDataDialog {
  static void show(BuildContext context, MonitoringController controller) {
    final treesController = TextEditingController(
      text: controller.totalTrees.value.toString(),
    );

    final fruitsController = TextEditingController(
      text: controller.totalEstimatedFruits.value.toString(),
    );

    if (controller.totalEstimatedFruits.value > 0) {
      Get.dialog(
        Dialog(
          backgroundColor: const Color(0xFFF2F4F3),
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: const Color(0xFFF2F4F3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  offset: const Offset(3, 3),
                  blurRadius: 6,
                ),
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-1, -1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Kelola Data Kebun",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D7A4F),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Pilih untuk mengatur ulang data atau mengubah jumlah pohon dan estimasi buah.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black87, height: 1.4),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                          _showResetConfirmation(controller);
                        },
                        child: _neumorphicButton(
                          text: "Reset",
                          isPrimary: false,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                          _showInputFormDialog(
                            context,
                            controller,
                            treesController,
                            fruitsController,
                          );
                        },
                        child: _neumorphicButton(text: "Edit", isPrimary: true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      _showInputFormDialog(
        context,
        controller,
        treesController,
        fruitsController,
      );
    }
  }

  // ================= RESET CONFIRMATION =================
  static void _showResetConfirmation(MonitoringController controller) {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFFF2F4F3),
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: const Color(0xFFF2F4F3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                offset: const Offset(3, 3),
                blurRadius: 6,
              ),
              const BoxShadow(
                color: Colors.white,
                offset: Offset(-1, -1),
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Konfirmasi Reset",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D7A4F),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Apakah Anda yakin ingin menghapus seluruh data kebun?\n\nTindakan ini tidak dapat dibatalkan.",
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.4, color: Colors.black87),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: _neumorphicButton(text: "Tidak", isPrimary: false),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.resetFarmData();
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.red.shade500,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Ya, Reset",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= INPUT FORM =================

  static void _showInputFormDialog(
    BuildContext context,
    MonitoringController controller,
    TextEditingController treesController,
    TextEditingController fruitsController,
  ) {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFFF2F4F3),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: const Color(0xFFF2F4F3),
            boxShadow: [
              // Shadow gelap bawah kanan
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(4, 4),
                blurRadius: 8,
              ),
              // Shadow terang atas kiri
              BoxShadow(
                color: Colors.white.withOpacity(0.06),
                offset: Offset(-1, -1),
                blurRadius: 3,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Input Data Kebun",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D7A4F),
                ),
              ),
              const SizedBox(height: 28),

              _neumorphicTextField(
                controller: treesController,
                label: "Total Pohon",
                icon: Icons.park,
              ),

              const SizedBox(height: 20),

              _neumorphicTextField(
                controller: fruitsController,
                label: "Total Estimasi Buah",
                icon: Icons.eco,
              ),

              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: _neumorphicButton(text: "Batal", isPrimary: false),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        final trees = int.tryParse(treesController.text) ?? 0;
                        final fruits = int.tryParse(fruitsController.text) ?? 0;

                        controller.updateFarmData(trees, fruits);
                        Get.back();
                      },
                      child: _neumorphicButton(text: "Simpan", isPrimary: true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///Helper untuk function glass Textfield
  static Widget _neumorphicTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFF2F4F3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(4, 4),
            blurRadius: 8,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-4, -4),
            blurRadius: 8,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          icon: Icon(icon, color: const Color(0xFF2D7A4F)),
          labelText: label,
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black.withOpacity(0.05)),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black.withOpacity(0.05)),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF2D7A4F), width: 1.2),
          ),
          labelStyle: const TextStyle(color: Color(0xFF2D7A4F)),
        ),
      ),
    );
  }

  ///Helper button Neumorphic
  static Widget _neumorphicButton({
    required String text,
    required bool isPrimary,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isPrimary ? const Color(0xFF2D7A4F) : const Color(0xFFF2F4F3),
        boxShadow: isPrimary
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  offset: const Offset(4, 4),
                  blurRadius: 8,
                ),
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 8,
                ),
              ],
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: isPrimary ? Colors.white : const Color(0xFF2D7A4F),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
