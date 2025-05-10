import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement navigation to the next screen after a delay
    // This might involve using a Timer or Future.delayed
    // and navigating to the next screen (e.g., HomePage) using Navigator.pushReplacement

    return Scaffold(
      backgroundColor: const Color(0xFF3F37C9), // Example background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for a logo or icon
            const Icon(
              Icons.savings, // Example icon
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            Text(
              'Control de gastos', // App name
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // Optional: Add a loading indicator
            // const SizedBox(height: 30),
            // const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}