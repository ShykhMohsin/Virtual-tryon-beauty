import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:google_fonts/google_fonts.dart'; // Keep your font style

import 'firebase_options.dart';
import 'providers/cart_provider.dart';
import 'theme.dart'; // Your existing theme

// Screens
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/otp_screen.dart';
import 'screens/auth/verify_email_screen.dart';
import 'screens/auth/create_profile_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/success_screen.dart';
import 'screens/order_history_screen.dart';
import 'screens/admin/admin_dashboard.dart'; // Admin screen

// pro screens
import 'screens/pro/checkout_screen.dart';
import 'screens/pro/LockedFeatureScreen.dart';
import 'screens/pro/pricing_screen.dart';
import 'screens/pro/success_screen.dart';
import 'screens/pro/premium_feature.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: beautyTheme,
      dark: beautyDarkTheme,
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => ChangeNotifierProvider(
        create: (_) => CartProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme.copyWith(
            // Preserve your signup screen text styles
            textTheme: GoogleFonts.playfairDisplayTextTheme(theme.textTheme),
          ),
          darkTheme: darkTheme?.copyWith(
            textTheme: GoogleFonts.playfairDisplayTextTheme(darkTheme.textTheme),
          ),
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, authSnapshot) {
              if (authSnapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }

              final user = authSnapshot.data;

              if (user == null) {
                return const OnboardingScreen();
              }

              if (!user.emailVerified) {
                return const VerifyEmailScreen();
              }

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .get(),
                builder: (context, profileSnapshot) {
                  if (profileSnapshot.connectionState == ConnectionState.waiting) {
                    return const SplashScreen();
                  }

                  if (!profileSnapshot.hasData || !profileSnapshot.data!.exists) {
                    return const CreateProfileScreen();
                  }

                  final userData = profileSnapshot.data!.data() as Map<String, dynamic>;
                  final role = userData['role'] ?? 'user';

                  return role == 'admin'
                      ?  AdminDashboard()
                      : const HomeScreen();
                },
              );
            },
          ),
          routes: {
            '/onboarding': (context) => const OnboardingScreen(),
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignupScreen(), // Your styled screen
            '/forgot-password': (context) => const ForgotPasswordScreen(),
            '/verify-email': (context) => const VerifyEmailScreen(),
            '/create-profile': (context) => const CreateProfileScreen(),
            '/home': (context) => const HomeScreen(),
            '/admin-dashboard': (context) =>  AdminDashboard(),
            '/cart': (context) => const CartScreen(),
            '/payment': (context) => const PaymentScreen(),
            '/success': (context) => const SuccessScreen(),
            '/order-history': (context) => const OrderHistoryScreen(),
            '/otp': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map;
              return OtpScreen(
                verificationId: args['verificationId'],
                phoneNumber: args['phoneNumber'],
              );
            },
          },
        ),
      ),
    );
  }
}