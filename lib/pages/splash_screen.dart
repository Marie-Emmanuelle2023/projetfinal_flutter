import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:projet_final/pages/main_screen.dart';
import 'package:projet_final/models/user.dart';

class SplashScreen extends StatelessWidget {
  final User user;

  const SplashScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F1D13), Colors.green],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(
          child: Text(
            'Miamm 😋',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      splashIconSize: double.infinity,
      backgroundColor: Colors.transparent,
      splashTransition: SplashTransition.fadeTransition,
      duration: 2000,
      nextScreen: MainScreen(user: user),
    );
  }
}