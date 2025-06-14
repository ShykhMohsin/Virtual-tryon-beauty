import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pro/success_screen.dart';
import '../../theme.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedPaymentMethod = 'Credit Card';
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController cardholderNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<BeautyTheme>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
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

            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Premium Card
                  _buildPremiumCard(context),
                  const SizedBox(height: 30),

                  // Features Section
                  _buildFeaturesSection(),
                  const SizedBox(height: 30),

                  // Payment Section
                  _buildPaymentSection(),
                  const SizedBox(height: 30),

                  // Start Trial Button
                  _buildStartTrialButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "TryOn Premium",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF2D55), Color(0xFFFF6B81)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "PRO",
                  style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "\$9.99 / month",
            style: GoogleFonts.raleway(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "First 7 days free, then auto-renews",
            style: GoogleFonts.raleway(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Premium Features",
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 15),
        ..._buildFeatureList(),
      ],
    );
  }

  List<Widget> _buildFeatureList() {
    final features = [
      {"icon": Icons.auto_awesome, "title": "Advanced AR Filters"},
      {"icon": Icons.block, "title": "No Ads"},
      {"icon": Icons.save, "title": "Save Try-On Looks"},
      {"icon": Icons.new_releases, "title": "Early Product Access"},
    ];

    return features.map((feature) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.pinkAccent.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(feature["icon"] as IconData, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 15),
          Text(
            feature["title"] as String,
            style: GoogleFonts.raleway(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    )).toList();
  }

  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Payment Method",
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 15),
        ..._buildPaymentOptions(),
        const SizedBox(height: 20),
        if (selectedPaymentMethod == 'Credit Card') _buildCreditCardForm(),
        const SizedBox(height: 15),
        Text(
          "You'll be charged after your 7-day free trial. Cancel anytime.",
          style: GoogleFonts.raleway(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPaymentOptions() {
    final options = [
      {"title": "Credit Card", "icon": Icons.credit_card},
      {"title": "PayPal", "icon": Icons.payment},
      {"title": "Apple Pay", "icon": Icons.apple},
    ];

    return options.map((option) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => setState(() => selectedPaymentMethod = option["title"] as String),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: selectedPaymentMethod == option["title"]
                ? Colors.pinkAccent.withOpacity(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selectedPaymentMethod == option["title"]
                  ? Colors.pinkAccent
                  : Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(
                option["icon"] as IconData,
                color: selectedPaymentMethod == option["title"]
                    ? Colors.white
                    : Colors.white70,
              ),
              const SizedBox(width: 15),
              Text(
                option["title"] as String,
                style: GoogleFonts.raleway(
                  color: selectedPaymentMethod == option["title"]
                      ? Colors.white
                      : Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (selectedPaymentMethod == option["title"])
                const Icon(Icons.check_circle, color: Colors.pinkAccent),
            ],
          ),
        ),
      ),
    )).toList();
  }

  Widget _buildCreditCardForm() {
    return Column(
      children: [
        _buildFormField(
          label: "Card Number",
          hint: "4242 4242 4242 4242",
          controller: cardNumberController,
          icon: Icons.credit_card,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _buildFormField(
                label: "Expiry Date",
                hint: "MM/YY",
                controller: expiryDateController,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildFormField(
                label: "CVV",
                hint: "123",
                controller: cvvController,
                obscureText: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        _buildFormField(
          label: "Cardholder Name",
          hint: "Your Name",
          controller: cardholderNameController,
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required String hint,
    required TextEditingController controller,
    IconData? icon,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.raleway(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: GoogleFonts.raleway(color: Colors.white),
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.raleway(color: Colors.white54),
            prefixIcon: icon != null ? Icon(icon, color: Colors.white54) : null,
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStartTrialButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SubscriptionSuccessScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pinkAccent,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          shadowColor: Colors.pinkAccent.withOpacity(0.4),
        ),
        child: Text(
          "START FREE TRIAL",
          style: GoogleFonts.raleway(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}