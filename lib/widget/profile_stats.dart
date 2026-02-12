// lib/widgets/profile_stats.dart

import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final int scanCount;
  final int landCount;
  final String level;

  const ProfileStats({
    Key? key,
    required this.scanCount,
    required this.landCount,
    required this.level,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 20),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(
            value: scanCount.toString(),
            label: 'SCAN',
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey[200],
          ),
          _StatItem(
            value: landCount.toString(),
            label: 'LAHAN',
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey[200],
          ),
          _StatItem(
            value: level,
            label: 'LEVEL',
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey[500],
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}