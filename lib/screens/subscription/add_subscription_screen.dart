import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/services/firestore_service.dart';
import 'package:expense_tracker/models/subscription.dart';
import '../Category/category_main.dart';

class AddSubscriptionScreen extends StatefulWidget {
  const AddSubscriptionScreen({super.key});

  @override
  State<AddSubscriptionScreen> createState() => _AddSubscriptionScreenState();
}

class _AddSubscriptionScreenState extends State<AddSubscriptionScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 30));

  String? _selectedCategory;

  Future<void> _showAddCategoryDialog() async {
    final TextEditingController _catCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Category'),
        content: TextField(
          controller: _catCtrl,
          decoration: const InputDecoration(hintText: 'Category name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_catCtrl.text.trim().isEmpty) return;
              await _firestoreService.addCategory(_catCtrl.text.trim());
              setState(() => _selectedCategory = _catCtrl.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

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
    );

    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _addSubscription() async {
    if (_nameCtrl.text.trim().isEmpty) return;

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
        category: _selectedCategory ?? 'Uncategorized',
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('New'),
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
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 32),

            // Dynamic icon preview
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

            // Subscription name
            TextField(
              controller: _nameCtrl,
              onChanged: _updateVisuals,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Subscription name',
                hintStyle: TextStyle(color: Colors.grey[500]),
                filled: true,
                fillColor: Colors.grey[900]?.withOpacity(0.4),
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
                fillColor: Colors.grey[900]?.withOpacity(0.4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            StreamBuilder<List<String>>(
              stream: _firestoreService.getCategories(),
              builder: (context, snapshot) {
                final categories = snapshot.data ?? [];
                return DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: [
                    ...categories.map(
                      (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                    ),
                    const DropdownMenuItem(
                      value: '__add_new__',
                      child: Text('+ Add new category'),
                    ),
                  ],
                  onChanged: (val) async {
                    if (val == '__add_new__') {
                      // Navigate to CategoryPage
                      final selected = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CategoryPage()),
                      );
                      if (selected != null) {
                        setState(() => _selectedCategory = selected);
                      }
                    } else {
                      setState(() => _selectedCategory = val);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Select category',
                    filled: true,
                    fillColor: Colors.grey[900]?.withOpacity(0.4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  dropdownColor: Colors.grey[900],
                  style: const TextStyle(color: Colors.white),
                );
              },
            ),

            const SizedBox(height: 32),

            const SizedBox(height: 24),
            //Due Date
            GestureDetector(
              onTap: _pickDueDate,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[900]?.withOpacity(0.4),
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
                        if (_price > 1) {
                          setState(() => _price -= 1);
                        }
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
                      onPressed: () {
                        setState(() => _price += 1);
                      },
                    ),
                  ],
                ),
              ],
            ),

            const Spacer(),

            // Add button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _addSubscription,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B6B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Add this subscription',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
