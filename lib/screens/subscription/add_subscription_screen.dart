import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/subscription.dart';
import 'package:flutter/services.dart';
import 'package:expense_tracker/services/firestore_service.dart';
import 'package:expense_tracker/services/firestore_category_service.dart';
import '../Category/category_main.dart';
import 'package:expense_tracker/models/category.dart';

class AddSubscriptionScreen extends StatefulWidget {
  const AddSubscriptionScreen({super.key});

  @override
  State<AddSubscriptionScreen> createState() => _AddSubscriptionScreenState();
}

class _AddSubscriptionScreenState extends State<AddSubscriptionScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final CategoryService _categoryService = CategoryService();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 30));

  String? _selectedCategory;

  double _price = 5.99;
  IconData _icon = Icons.star;
  Color _color = Colors.grey;

  void _updateVisuals(String name) {
    setState(() {
      _icon = Subscription.getIconFromName(name);
      _color = Subscription.getColorFromName(name);
    });
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF80FFB5),
            onPrimary: Colors.black,
            surface: Color(0xFF1C1B33),
            onSurface: Colors.white,
          ),
          dialogBackgroundColor: const Color(0xFF101025),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _showAddCategoryDialog() async {
    final TextEditingController _catCtrl = TextEditingController();
    final TextEditingController _budgetCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF101025),
        title: const Text('Add New Category', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _catCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Category name',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _budgetCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Budget',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF9C8FFF))),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = _catCtrl.text.trim();
              final budget = double.tryParse(_budgetCtrl.text.trim());
              if (name.isEmpty || budget == null) return;

              await _categoryService.addCategory(name: name, budget: budget);

              setState(() => _selectedCategory = name);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF80FFB5),
            ),
            child: const Text('Add', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Future<void> _addSubscription() async {
    if (_nameCtrl.text.trim().isEmpty) return;

    final selectedCategory = _selectedCategory ?? 'Uncategorized';

    await _firestoreService.addSubscription(
      Subscription(
        id: '',
        name: _nameCtrl.text.trim(),
        price: _price,
        cycle: 'monthly',
        isPaid: false,
        nextDue: Timestamp.fromDate(_dueDate),
        icon: _icon,
        color: _color,
        category: selectedCategory,
      ),
    );

    if (selectedCategory != 'Uncategorized') {
      final category = await _categoryService.getCategoryByName(selectedCategory);
      if (category != null) {
        final newSpent = category.spent + _price;
        await _categoryService.updateCategorySpent(category.id, newSpent);
      }
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101025),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('New', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Add new\nsubscription',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE0E0FF),
              ),
            ),
            const SizedBox(height: 32),

            // Icon preview
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: _color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Icon(_icon, size: 64, color: _color),
            ),
            const SizedBox(height: 24),

            // Name
            TextField(
              controller: _nameCtrl,
              onChanged: _updateVisuals,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Subscription name',
                hintStyle: TextStyle(color: Colors.grey[500]),
                filled: true,
                fillColor: Colors.grey[900]?.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            TextField(
              controller: _descCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Description (optional)',
                hintStyle: TextStyle(color: Colors.grey[500]),
                filled: true,
                fillColor: Colors.grey[900]?.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category dropdown
            StreamBuilder<List<Category>>(
              stream: _categoryService.getCategories(),
              builder: (context, snapshot) {
                final categories = snapshot.data ?? [];
                final categoryNames = categories.map((c) => c.name).toList();

                return DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: [
                    ...categoryNames.map(
                      (catName) => DropdownMenuItem(
                        value: catName,
                        child: Text(catName, style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                    const DropdownMenuItem(
                      value: '__add_new__',
                      child: Text('+ Add new category', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                  onChanged: (val) async {
                    if (val == '__add_new__') {
                      await _showAddCategoryDialog();
                    } else {
                      setState(() => _selectedCategory = val);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Select category',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[900]?.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  dropdownColor: const Color(0xFF101025),
                  style: const TextStyle(color: Colors.white),
                );
              },
            ),
            const SizedBox(height: 32),

            // Due date
            GestureDetector(
              onTap: _pickDueDate,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[900]?.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'Due date: ${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Monthly price
            Column(
              children: [
                Text(
                  'Monthly price',
                  style: TextStyle(color: Colors.grey[400]),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      color: Colors.white,
                      onPressed: () {
                        if (_price > 1) setState(() => _price -= 1);
                      },
                    ),
                    Text(
                      '\$${_price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      color: Colors.white,
                      onPressed: () => setState(() => _price += 1),
                    ),
                  ],
                ),
              ],
            ),

            const Spacer(),

            // Add subscription button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _addSubscription,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF80FFB5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Add this subscription',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
