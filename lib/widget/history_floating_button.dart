import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class HistoryFloatingButton extends StatelessWidget {
  const HistoryFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          print('🕐 History button tapped!');
          Get.toNamed('/history');
        },
        borderRadius: BorderRadius.circular(35),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: const Color(0xFF2D7A4F),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2D7A4F).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Lottie.asset(
              'assets/animations/History.json',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
