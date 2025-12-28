import 'package:flutter/material.dart';
import 'package:expense_tracker/screens/home/home_screen.dart';
import 'package:expense_tracker/screens/calender/calendar_screen.dart'; // Fixed path typo if needed
import 'package:expense_tracker/screens/settings/settings_screen.dart';
import 'package:expense_tracker/widgets/custom_bottom_nav_bar.dart';
import 'Category/category_main.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    HomeScreen(),
    CategoryPage(),
    CalendarScreen(),
    SettingsScreen(),
    // Add more screens here if you have 4-5 tabs
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        // ← FIXED: Added missing ( and )
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
