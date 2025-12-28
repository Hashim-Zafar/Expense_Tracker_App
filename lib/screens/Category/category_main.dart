import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/services/firestore_category_service.dart';
import 'package:flutter/material.dart';
import 'category_card.dart';

class CategoryPage extends StatelessWidget {
  CategoryPage({super.key});

  final CategoryService _categoryService = CategoryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2B2D4F), // dark indigo
              Color(0xFF1F213A), // deep navy
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ───────── Header ─────────
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Spending & Budgets',
                        style: TextStyle(
                          color: Color(0xFFE6E6FF),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Color(0xFFE6E6FF)),
                      onPressed: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // ───────── Budget Summary ─────────
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 32,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFB18AFF), // purple
                          Color(0xFF5CFFB0), // mint
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.45),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: const [
                        Text(
                          '\$120',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Budget spent',
                          style: TextStyle(color: Color(0xFFE6E6FF)),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'of',
                          style: TextStyle(color: Color(0xFFE6E6FF)),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '\$500',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'total Budget',
                          style: TextStyle(color: Color(0xFFE6E6FF)),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ───────── Category List ─────────
                Expanded(
                  child: StreamBuilder<List<Category>>(
                    stream: _categoryService.getCategories(),
                    builder: (context, snapshot) {
                      final categories = snapshot.data ?? [];

                      if (categories.isEmpty) {
                        return const Center(
                          child: Text(
                            'No categories yet',
                            style: TextStyle(color: Color(0xFFA9AACF)),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: CategoryCard(
                              name: category.name,
                              budget: category.budget,
                              spent: category.spent,
                              onTap: () {
                                Navigator.pop(context, category.name);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // ───────── New Category Button ─────────
                GestureDetector(
                  onTap: () async {
                    final nameController = TextEditingController();
                    final budgetController = TextEditingController();

                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: const Color(0xFF2B2D4F),
                          title: const Text(
                            'New Category',
                            style: TextStyle(color: Color(0xFFE6E6FF)),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: nameController,
                                style: const TextStyle(color: Color(0xFFE6E6FF)),
                                decoration: const InputDecoration(
                                  hintText: 'Category name',
                                  hintStyle: TextStyle(color: Color(0xFFA9AACF)),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: budgetController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Color(0xFFE6E6FF)),
                                decoration: const InputDecoration(
                                  hintText: 'Budget',
                                  hintStyle: TextStyle(color: Color(0xFFA9AACF)),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Color(0xFFA9AACF)),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final name = nameController.text.trim();
                                final budget = double.tryParse(
                                  budgetController.text.trim(),
                                );
                                if (name.isEmpty || budget == null) return;

                                await _categoryService.addCategory(
                                  name: name,
                                  budget: budget,
                                );
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFB18AFF),
                              ),
                              child: const Text('Add'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFB18AFF),
                          Color(0xFF5CFFB0),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        '+ New category',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
