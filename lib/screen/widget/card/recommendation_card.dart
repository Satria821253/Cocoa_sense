import 'package:flutter/material.dart';

class RecommendationCard extends StatelessWidget {
  final List<dynamic> recommendations;

  const RecommendationCard({super.key, required this.recommendations});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Color(0xFF2D7A4F)),
                SizedBox(width: 8),
                Text(
                  'Rekomendasi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D7A4F),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (recommendations.isEmpty)
              const Text('Tidak ada rekomendasi')
            else
              ...recommendations.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text('${entry.key + 1}. ${entry.value}'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
