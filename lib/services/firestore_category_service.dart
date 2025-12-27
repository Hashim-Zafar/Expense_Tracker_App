import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/category.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;

  Future<void> addCategory({
    required String name,
    required double budget,
    IconData icon = Icons.category,
  }) async {
    if (_user == null) return;

    await _firestore
        .collection('users')
        .doc(_user!.uid)
        .collection('categories')
        .add({
          'name': name,
          'budget': budget,
          'spent': 0,
          'icon': icon.codePoint,
        });
  }

  Stream<List<Category>> getCategories() {
    if (_user == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(_user!.uid)
        .collection('categories')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList(),
        );
  }

  Future<Category?> getCategoryByName(String name) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('categories')
        .where('name', isEqualTo: name)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return Category.fromFirestore(snapshot.docs.first);
  }

  // Update the spent amount
  Future<void> updateCategorySpent(String categoryId, double spent) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('categories')
        .doc(categoryId)
        .update({'spent': spent});
  }
}

// Get a single category by name
