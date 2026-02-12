// lib/widgets/profile_menu_list.dart

import 'package:cocoa_sense/widget/dialogs/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'profile_menu_item.dart';
import 'package:get/get.dart';

class ProfileMenuList extends StatelessWidget {
  const ProfileMenuList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Text(
              'PENGATURAN AKUN',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.grey[400],
                letterSpacing: 0.8,
              ),
            ),
          ),
          ProfileMenuItem(
            icon: Icons.person_outline,
            iconColor: Colors.blue[600]!,
            iconBackgroundColor: Colors.blue[50]!,
            title: 'Detail Biodata',
            onTap: () {
              // Navigate to biodata detail
            },
          ),
          const Divider(height: 1, indent: 68),
          ProfileMenuItem(
            icon: Icons.school_outlined,
            iconColor: Colors.amber[700]!,
            iconBackgroundColor: Colors.amber[50]!,
            title: 'Pencapaian Mahasiswa',
            onTap: () {
              // Navigate to achievements
            },
          ),
          const Divider(height: 1, indent: 68),
          ProfileMenuItem(
            icon: Icons.history_outlined,
            iconColor: Colors.grey[700]!,
            iconBackgroundColor: Colors.grey[100]!,
            title: 'Riwayat Deteksi',
            onTap: () {
              print('🕐 History button tapped!');
              Get.toNamed('/history');
            },
          ),
          const Divider(height: 1, indent: 68),
          ProfileMenuItem(
            icon: Icons.settings_outlined,
            iconColor: Colors.grey[700]!,
            iconBackgroundColor: Colors.grey[100]!,
            title: 'Pengaturan Aplikasi',
            onTap: () {
              // Navigate to app settings
            },
          ),
          const Divider(height: 1, indent: 68),
          ProfileMenuItem(
            icon: Icons.logout,
            iconColor: Colors.red[600]!,
            iconBackgroundColor: Colors.red[50]!,
            title: 'Keluar Sesi',
            titleColor: Colors.red[600]!,
            showArrow: false,
            onTap: () {
              debugPrint("📌 [ProfileMenu] Menu logout ditekan");
              LogoutDialog.show(context);
            },
          ),
        ],
      ),
    );
  }
}
