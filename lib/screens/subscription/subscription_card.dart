import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/models/subscription.dart';
import 'package:expense_tracker/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionCard extends StatelessWidget {
  final Subscription sub;
  final FirestoreService firestoreService;
  final VoidCallback? onTap;

  const SubscriptionCard({
    super.key,
    required this.sub,
    required this.firestoreService,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2B2D4F), // 60% primary surface
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Tick box
              Checkbox(
                value: sub.isPaid,
                fillColor:
                    MaterialStateProperty.all(const Color(0xFF5CFFB0)), // 10%
                checkColor: Colors.black,
                onChanged: (val) async {
                  await firestoreService.updateSubscription(sub.id, {
                    'isPaid': val,
                    'nextDue': val == true
                        ? Timestamp.fromDate(
                            sub.nextDue
                                .toDate()
                                .add(const Duration(days: 30)),
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
                  color:
                      const Color(0xFFB18AFF).withOpacity(0.2), // 30% soft
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  sub.icon,
                  color: const Color(0xFFB18AFF), // 30%
                ),
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
                        color: sub.isPaid
                            ? Colors.white54
                            : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${sub.cycle[0].toUpperCase()}${sub.cycle.substring(1)}',
                      style: const TextStyle(
                        color: Color(0xFFB7B6D8),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Due: ${DateFormat('dd/MM/yyyy').format(sub.nextDue.toDate())}',
                      style: TextStyle(
                        color: !sub.isPaid &&
                                sub.nextDue.toDate().isBefore(DateTime.now())
                            ? const Color(0xFFFF6B6B) // danger
                            : const Color(0xFFB7B6D8),
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
