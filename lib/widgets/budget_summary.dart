import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/circular_progress_ring.dart';

class BudgetSummary extends StatelessWidget {
  final double totalAmount;
  final double maxAmount;
  const BudgetSummary({
    super.key,
    required this.totalAmount,
    required this.maxAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircularProgressRing(
          totalAmount: totalAmount,
          maxAmount: maxAmount,
          size: 300,
          currency: '\$',
        ),
        const SizedBox(height: 16),
        Text(
          'This month bills',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[400],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
