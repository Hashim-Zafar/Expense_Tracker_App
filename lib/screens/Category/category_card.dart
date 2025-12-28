import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final double budget;
  final double spent;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.name,
    required this.budget,
    required this.spent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final percentSpent = budget > 0 ? (spent / budget) : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF2B2D4F), // top dark indigo
              const Color(0xFF1F213A), // bottom deep navy
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: const Color(0xFF3B3E6E), // subtle border
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Circular progress
            SizedBox(
              width: 52,
              height: 52,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: percentSpent.clamp(0.0, 1.0),
                    strokeWidth: 5,
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      percentSpent >= 1
                          ? const Color(0xFFB18AFF) // purple warning
                          : const Color(0xFF5CFFB0), // mint safe
                    ),
                  ),
                  Text(
                    '${(percentSpent * 100).toInt()}%',
                    style: const TextStyle(
                      color: Color(0xFFE6E6FF), // soft white
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Category info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Color(0xFFE6E6FF),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${spent.toStringAsFixed(2)} of \$${budget.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFFA9AACF), // muted lavender
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Color(0xFFB18AFF), // purple accent
            ),
          ],
        ),
      ),
    );
  }
}
