// lib/screens/profile_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:cocoa_sense/controllers/main_controller.dart';
import 'package:cocoa_sense/widget/profile_header_widget.dart';
import 'package:cocoa_sense/widget/profile_menu_list.dart';
import 'package:cocoa_sense/widget/profile_stats.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final controller = Get.find<MainController>();
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;

  Future<void> _pickImage() async {
    debugPrint('📸 Avatar ditekan');

    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    setState(() {
      _profileImage = File(picked.path);
    });
  }

  ImageProvider _profileProvider() {
    if (_profileImage != null) {
      return FileImage(_profileImage!);
    }
    return NetworkImage(controller.imageUrl.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            /// ================= TOP BAR =================
            _buildTopBar(),

            /// ================= CONTENT =================
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    /// 🔥 HEADER INTERAKTIF
                    ProfileHeader(
                      imageProvider: _profileProvider(),
                      onImageTap: _pickImage,
                      name: controller.userName.value,
                      faculty: controller.faculty.value,
                      program: controller.program.value,
                    ),

                    const SizedBox(height: 24),
                    const ProfileStats(
                      scanCount: 42,
                      landCount: 12,
                      level: 'B1',
                    ),
                    const SizedBox(height: 32),
                    const ProfileMenuList(),
                    const SizedBox(height: 24),

                    Text(
                      'COCOA-SENSE V1.0 • IPB UNIVERSITY 2026',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[400],
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
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
                child: const Icon(Icons.eco, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'COCOA-SENSE',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'PROFIL AKUN',
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
          ),
        ],
      ),
    );
  }
}
