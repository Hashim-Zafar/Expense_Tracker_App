import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onSettingsTap;
  const HomeHeader({super.key, required this.onSettingsTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: Colors.white70),
          onPressed: onSettingsTap,
        ),
      ],
    );
  }
}
