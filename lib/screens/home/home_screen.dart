import 'package:flutter/material.dart';
import '../../widgets/circular_progress_ring.dart';
import '../../widgets/custom_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Demo data - in real app this comes from Firestore
  final double monthlyTotal = 1235.0;
  final double budget = 2000.0;

  final List<Map<String, dynamic>> subscriptions = [
    {'name': 'Spotify', 'price': 5.99, 'icon': Icons.music_note, 'color': Colors.green},
    {'name': 'YouTube Premium', 'price': 18.99, 'icon': Icons.play_arrow, 'color': Colors.red},
    {'name': 'Microsoft OneDrive', 'price': 29.99, 'icon': Icons.cloud, 'color': Colors.blue},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0F0F0F),

      body: Stack(
        children: [
          // Background stripes pattern
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF121212), Color(0xFF0A0A0A)],
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
                    colors: List.generate(20, (_) => Colors.white.withOpacity(0.02)),
                    stops: List.generate(20, (i) => i / 20),
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Header - Settings icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.settings_outlined, color: Colors.white70),
                        onPressed: () {
                          // TODO: Navigate to settings
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Circular Ring - Main feature
                  CircularProgressRing(
                    totalAmount: monthlyTotal,
                    maxAmount: budget,
                    size: 300,
                    currency: '\$',
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'This month bills',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // See your budget button
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey[900]?.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[800]!, width: 1),
                    ),
                    child: const Center(
                      child: Text(
                        'See your budget',
                        style: TextStyle(
                          color: Color(0xFFFF6B6B),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatCard('Active subs', '12', Colors.green),
                      _buildStatCard('Highest subs', '\$19.99', Colors.orange),
                      _buildStatCard('Lowest subs', '\$5.99', Colors.blue),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Tabs - Your subscriptions / Upcoming bills
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B6B).withOpacity(0.15),
                            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                          ),
                          child: const Center(
                            child: Text(
                              'Your subscriptions',
                              style: TextStyle(
                                color: Color(0xFFFF6B6B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
                          ),
                          child: const Center(
                            child: Text(
                              'Upcoming bills',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Subscription list
                  ...subscriptions.map((sub) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[900]?.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: sub['color'].withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(sub['icon'], color: sub['color']),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      sub['name'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Monthly',
                                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '\$${sub['price'].toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          // TODO: Handle navigation to other screens
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey[900]?.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}