import 'package:flutter/material.dart';
import 'package:expense_tracker/models/subscription.dart';
import 'package:expense_tracker/services/firestore_service.dart';
import 'package:expense_tracker/widgets/custom_bottom_nav_bar.dart';
import '../subscription/add_subscription_screen.dart';
import 'package:expense_tracker/widgets/budget_summary.dart';
import 'package:expense_tracker/widgets/home_headet.dart';
import 'package:expense_tracker/widgets/stats_row.dart';
import '../subscription/subscription_tabs.dart';
import '../subscription/subscription_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  int _selectedIndex = 0;
  int _selectedTab = 0;
  double _budget = 2000.0; // Default budget

  @override
  void initState() {
    super.initState();
    _loadBudget();
  }

  Future<void> _loadBudget() async {
    double budget = await _firestoreService.getBudget();
    if (mounted) {
      setState(() => _budget = budget);
    }
  }

  List<Subscription> _getUpcomingBills(List<Subscription> subs) {
    final now = DateTime.now();
    final end = now.add(const Duration(days: 30));

    return subs.where((sub) {
      final due = sub.nextDue.toDate();
      return !sub.isPaid && due.isAfter(now) && due.isBefore(end);
    }).toList();
  }

  List<Subscription> _getOverdueBills(List<Subscription> subs) {
    final now = DateTime.now();
    return subs
        .where((sub) => !sub.isPaid && sub.nextDue.toDate().isBefore(now))
        .toList();
  }

  double _calculateMonthlyTotal(List<Subscription> subs) {
    return subs.fold(0.0, (sum, sub) => sum + sub.price);
  }

  double _getHighestPrice(List<Subscription> subs) {
    if (subs.isEmpty) return 0.0;
    return subs.map((s) => s.price).reduce((a, b) => a > b ? a : b);
  }

  double _getLowestPrice(List<Subscription> subs) {
    if (subs.isEmpty) return 0.0;
    return subs.map((s) => s.price).reduce((a, b) => a < b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0F0F0F),
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF121212),
                  Color(0xFF0A0A0A),
                  Color(0xFF0C0C0C),
                  Color(0xFF0A0A0A),
                ],
                stops: [0.0, 0.4, 0.6, 1.0],
              ),
            ),
            child: Opacity(
              opacity: 0.15,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: List.generate(
                      20,
                      (_) => Colors.white.withOpacity(0.02),
                    ),
                    stops: List.generate(20, (i) => i / 20),
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: StreamBuilder<List<Subscription>>(
              stream: _firestoreService.getSubscriptions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }

                final List<Subscription> subs = snapshot.data ?? [];
                final double monthlyTotal = _calculateMonthlyTotal(subs);
                final int activeCount = subs.length;
                final double highest = _getHighestPrice(subs);
                final double lowest = _getLowestPrice(subs);

                final List<Subscription> displayedSubs = _selectedTab == 0
                    ? subs
                    : _selectedTab == 1
                    ? _getUpcomingBills(subs)
                    : _getOverdueBills(subs);

                return Column(
                  children: [
                    const SizedBox(height: 16),
                    HomeHeader(onSettingsTap: () {}),
                    const SizedBox(height: 20),
                    BudgetSummary(
                      totalAmount: monthlyTotal,
                      maxAmount: _budget,
                    ),

                    const SizedBox(height: 32),
                    StatsRow(
                      activeCount: activeCount,
                      highest: highest,
                      lowest: lowest,
                    ),
                    const SizedBox(height: 32),
                    SubscriptionTabs(
                      selectedTab: _selectedTab,
                      onTabSelected: (index) =>
                          setState(() => _selectedTab = index),
                    ),
                    const SizedBox(height: 16),

                    // Use Expanded + ListView.builder to prevent memory crash
                    Expanded(
                      child: displayedSubs.isEmpty
                          ? const Center(
                              child: Text(
                                'No subscriptions yet',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              itemCount: displayedSubs.length,
                              itemBuilder: (context, index) {
                                final sub = displayedSubs[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: SubscriptionCard(
                                    sub: sub,
                                    firestoreService: _firestoreService,
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF6B6B),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddSubscriptionScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
