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

    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            Colors.blueAccent, // you can assign a different color per category
        child: Text(name[0].toUpperCase()), // first letter
      ),
      title: Text(name, style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        '\$${spent.toStringAsFixed(2)} spent of \$${budget.toStringAsFixed(2)}',
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: SizedBox(
        width: 80,
        child: LinearProgressIndicator(
          value: percentSpent,
          backgroundColor: Colors.grey[800],
          color: Colors.greenAccent,
        ),
      ),
      onTap: onTap,
    );
  }
}
