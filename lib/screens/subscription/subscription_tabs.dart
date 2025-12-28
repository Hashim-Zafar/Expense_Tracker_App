import 'package:flutter/material.dart';

class SubscriptionTabs extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabSelected;

  // Non-const constructor (do NOT mark as const)
  const SubscriptionTabs({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildTab('Your subscriptions', 0),
        _buildTab('Upcoming bills', 1),
        _buildTab('Overdue', 2),
      ],
    );
  }

  Widget _buildTab(String title, int index) {
    final bool isSelected = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFB18AFF).withOpacity(0.25) // 30%
                : const Color(0xFF2B2D4F), // 60%
            borderRadius: BorderRadius.horizontal(
              left: index == 0 ? const Radius.circular(16) : Radius.zero,
              right: index == 2 ? const Radius.circular(16) : Radius.zero,
            ),
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFFB18AFF) // 30%
                    : const Color(0xFFB7B6D8), // muted text
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
