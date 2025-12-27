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
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
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
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      // future settings page
                    },
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // ───────── Budget Summary ─────────
              Center(
                child: Column(
                  children: const [
                    Text(
                      '\$120',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text('Budget spent', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 6),
                    Text('of', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 6),
                    Text(
                      '\$500',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text('total Budget', style: TextStyle(color: Colors.grey)),
                  ],
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
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];

                        return CategoryCard(
                          name: category.name,
                          budget: category.budget,
                          spent: category.spent,
                          onTap: () {
                            Navigator.pop(context, category.name);
                          },
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
                        backgroundColor: const Color(0xFF1C1C1C),
                        title: const Text(
                          'New Category',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: nameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Category name',
                                hintStyle: TextStyle(color: Colors.grey[500]),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: budgetController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Budget',
                                hintStyle: TextStyle(color: Colors.grey[500]),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
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
                            child: const Text('Add'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900]?.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Center(
                    child: Text(
                      '+ New category',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
