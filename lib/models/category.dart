import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String name;
  final double budget;
  final double spent;
  final IconData icon;

  Category({
    required this.id,
    required this.name,
    required this.budget,
    required this.spent,
    required this.icon,
  });

  factory Category.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Category(
      id: doc.id,
      name: data['name'] ?? '',
      budget: (data['budget'] ?? 0).toDouble(),
      spent: (data['spent'] ?? 0).toDouble(),
      icon: IconData(
        data['icon'] ?? Icons.category.codePoint,
        fontFamily: 'MaterialIcons',
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'budget': budget,
      'spent': spent,
      'icon': icon.codePoint,
    };
  }
}
