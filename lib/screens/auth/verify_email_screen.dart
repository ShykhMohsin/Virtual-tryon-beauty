import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;
  bool _isVerified = false;

  Future<void> _checkEmailVerified() async {
    setState(() => _isLoading = true);
    await user?.reload();
    setState(() {
      _isVerified = user?.emailVerified ?? false;
      _isLoading = false;
    });

    if (_isVerified) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _resendVerification() async {
    setState(() => _isLoading = true);
    try {
      await user?.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification email resent!')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(context).extension<BeautyTheme>()!.backgroundGradient,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.email, size: 80, color: Colors.white),
                const SizedBox(height: 20),
                Text(
                  "Verify Your Email",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "We've sent a verification email to ${user?.email}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _checkEmailVerified,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text("I've Verified My Email"),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: _isLoading ? null : _resendVerification,
                  child: const Text("Resend Verification Email"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}