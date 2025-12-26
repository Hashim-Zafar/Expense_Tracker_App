import 'package:flutter/material.dart';
import './register_screen.dart'; // adjust path
import './login_screen.dart';
// adjust path if you have it

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF181818),
              Color(0xFF0F0F0F),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Floating icons (subscription logos) - position them as bubbles/abstract
              Positioned(
                top: 120,
                left: 40,
                child: Opacity(
                  opacity: 0.7,
                  child: Image.asset(
                    'assets/images/netflix.png', // ← your asset
                    width: 80,
                    height: 80,
                  ),
                ),
              ),

              Positioned(
                top: 180,
                right: 60,
                child: Opacity(
                  opacity: 0.65,
                  child: Image.asset(
                    'assets/images/spotify.png',
                    width: 100,
                    height: 100,
                  ),
                ),
              ),

              Positioned(
                bottom: 220,
                left: 80,
                child: Opacity(
                  opacity: 0.6,
                  child: Image.asset(
                    'assets/images/youtube.png',
                    width: 90,
                    height: 90,
                  ),
                ),
              ),

              // Optional: more floating elements (add as you have assets)

              // Main content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    const Spacer(flex: 3),

                    // App Logo / Name
                    const Text(
                      'Trackizer',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            color: Colors.black45,
                            offset: Offset(0, 4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Tagline
                    Text(
                      'Track your subscriptions\nand never overpay again',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[300],
                        height: 1.4,
                      ),
                    ),

                    const Spacer(flex: 4),

                    // Get Started Button
                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B6B),
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shadowColor: const Color(0xFFFF6B6B).withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Already have account?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AuthScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              color: Color(0xFFFF6B6B),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}