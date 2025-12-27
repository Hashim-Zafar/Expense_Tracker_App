import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/models/subscription.dart';
import 'package:expense_tracker/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionCard extends StatelessWidget {
  final Subscription sub;
  final FirestoreService firestoreService;
  final VoidCallback? onTap; // <-- new

  const SubscriptionCard({
    super.key,
    required this.sub,
    required this.firestoreService,
    this.onTap, // <-- new
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // <-- trigger tap
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900]?.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Tick box
              Checkbox(
                value: sub.isPaid,
                onChanged: (val) async {
                  await firestoreService.updateSubscription(sub.id, {
                    'isPaid': val,
                    'nextDue': val == true
                        ? Timestamp.fromDate(
                            sub.nextDue.toDate().add(const Duration(days: 30)),
                          )
                        : sub.nextDue,
                  });
                },
              ),
              const SizedBox(width: 8),
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: sub.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(sub.icon, color: sub.color),
              ),
              const SizedBox(width: 16),
              // Name, cycle, due
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sub.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: sub.isPaid ? Colors.grey : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${sub.cycle[0].toUpperCase()}${sub.cycle.substring(1)}',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Due: ${DateFormat('dd/MM/yyyy').format(sub.nextDue.toDate())}',
                      style: TextStyle(
                        color:
                            !sub.isPaid &&
                                sub.nextDue.toDate().isBefore(DateTime.now())
                            ? Colors.red
                            : Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Price
              Text(
                '\$${sub.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
