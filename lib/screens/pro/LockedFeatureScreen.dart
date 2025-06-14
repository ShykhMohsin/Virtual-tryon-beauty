import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'checkout_screen.dart';
import '../../theme.dart';

class LockedFeatureScreen extends StatelessWidget {
  const LockedFeatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<BeautyTheme>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Premium AR Filters',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: theme.backgroundGradient,
        ),
        child: Stack(
          children: [
            // Semi-transparent overlay
            Container(color: Colors.black.withOpacity(0.3)),

            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Lock Icon
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                        border: Border.all(
                          color: Colors.pinkAccent.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.lock_outline,
                        size: 60,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Premium Feature Text
                    Text(
                      'Premium Feature',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Text(
                      'Unlock exclusive AR Filters by upgrading to Premium',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Upgrade Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CheckoutScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                          shadowColor: Colors.pinkAccent.withOpacity(0.4),
                        ),
                        child: Text(
                          'Upgrade to Premium',
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Not Now Button
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Not Now',
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          color: Colors.white70,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}