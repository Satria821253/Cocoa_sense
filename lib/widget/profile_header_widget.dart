// lib/screens/widget/profile_header_widget.dart

import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String faculty;
  final String program;
  final ImageProvider imageProvider;
  final VoidCallback onImageTap;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.faculty,
    required this.program,
    required this.imageProvider,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onImageTap,
          child: Stack(
            children: [
              CircleAvatar(radius: 56, backgroundImage: imageProvider),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2D7A4F),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(faculty, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        Text(program, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
      ],
    );
  }
}
