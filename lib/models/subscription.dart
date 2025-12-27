import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; // ✅ REQUIRED for IconData, Icons, Color, Colors

class Subscription {
  final String id;
  final String name;
  final double price;
  final String cycle; // 'monthly' or 'yearly'
  final Timestamp nextDue;
  final IconData icon;
  final Color color;
  final bool isPaid;
  final String category;

  Subscription({
    required this.id,
    required this.name,
    required this.price,
    required this.cycle,
    required this.nextDue,
    required this.icon,
    required this.color,
    required this.isPaid,
    this.category = 'Uncategorized',
  });

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'price': price,
      'cycle': cycle,
      'nextDue': nextDue,
      'category': category,
    };
  }

  factory Subscription.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Subscription(
      id: doc.id,
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      cycle: data['cycle'] ?? 'monthly',
      nextDue: data['nextDue'] ?? Timestamp.now(),
      icon: getIconFromName(data['name'] ?? ''),
      color: _getColorFromName(data['name'] ?? ''),
      isPaid: data['isPaid'] ?? false,
      category: data['category'] ?? 'Uncategorized',
    );
  }

  static IconData getIconFromName(String name) {
    final lower = name.toLowerCase();

    if (lower.contains('spotify')) return Icons.music_note;
    if (lower.contains('youtube')) return Icons.play_arrow;
    if (lower.contains('onedrive')) return Icons.cloud;
    if (lower.contains('netflix')) return Icons.movie;

    return Icons.star;
  }

  static Color getColorFromName(String name) {
    final lower = name.toLowerCase();

    if (lower.contains('spotify')) return Colors.green;
    if (lower.contains('youtube')) return Colors.red;
    if (lower.contains('onedrive')) return Colors.blue;
    if (lower.contains('netflix')) return Colors.redAccent;

    return Colors.grey;
  }

  static Color _getColorFromName(String name) {
    final lower = name.toLowerCase();

    if (lower.contains('spotify')) return Colors.green;
    if (lower.contains('youtube')) return Colors.red;
    if (lower.contains('onedrive')) return Colors.blue;
    return Colors.grey; // Default
  }
}
