import 'package:flutter/material.dart';
import 'package:expense_tracker/models/subscription.dart';
import 'package:expense_tracker/services/firestore_service.dart';

class EditSubscriptionScreen extends StatefulWidget {
  final Subscription subscription;

  const EditSubscriptionScreen({super.key, required this.subscription});

  @override
  State<EditSubscriptionScreen> createState() => _EditSubscriptionScreenState();
}

class _EditSubscriptionScreenState extends State<EditSubscriptionScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;

  late double _price;
  late IconData _icon;
  late Color _color;

  @override
  void initState() {
    super.initState();

    _nameCtrl = TextEditingController(text: widget.subscription.name);
    _descCtrl = TextEditingController();

    _price = widget.subscription.price;
    _icon = widget.subscription.icon;
    _color = widget.subscription.color;
  }

  void _updateVisuals(String name) {
    setState(() {
      _icon = Subscription.getIconFromName(name);
      _color = Subscription.getColorFromName(name);
    });
  }

  Future<void> _saveChanges() async {
    await _firestoreService.updateSubscription(widget.subscription.id, {
      'name': _nameCtrl.text.trim(),
      'price': _price,
      'icon': _icon.codePoint,
      'color': _color.value,
    });

    Navigator.pop(context);
  }

  Future<void> _deleteSubscription() async {
    await _firestoreService.deleteSubscription(widget.subscription.id);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101025),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Edit', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),

            const Text(
              'Edit\nsubscription',
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

            const SizedBox(height: 32),

            // Price
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

            // Save button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF80FFB5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Save changes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Delete button
            TextButton(
              onPressed: _deleteSubscription,
              child: const Text(
                'Delete subscription',
                style: TextStyle(
                  color: Color(0xFFFF6B6B),
                  fontWeight: FontWeight.w600,
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
