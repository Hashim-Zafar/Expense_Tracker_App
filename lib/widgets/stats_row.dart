import 'package:flutter/material.dart';

class StatsRow extends StatelessWidget {
  final int activeCount;
  final double highest;
  final double lowest;

  const StatsRow({
    super.key,
    required this.activeCount,
    required this.highest,
    required this.lowest,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatCard('Active subs', activeCount.toString(), const Color(0xFF5CFFB0)), // 10% accent
        _buildStatCard(
          'Highest subs',
          '\$${highest.toStringAsFixed(2)}',
          const Color(0xFFB18AFF), // 30% secondary
        ),
        _buildStatCard(
          'Lowest subs',
          '\$${lowest.toStringAsFixed(2)}',
          const Color(0xFF2B2D4F), // 60% surface
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF2B2D4F).withOpacity(0.4), // 60% base
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
