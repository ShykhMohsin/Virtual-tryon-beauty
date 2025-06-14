import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber; // or email

  const OtpScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
      6,
          (index) => TextEditingController()
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  bool _isResendLoading = false;
  int _resendTimeout = 30;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    // Auto-focus first OTP field
    FocusScope.of(context).requestFocus(_focusNodes[0]);
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_resendTimeout > 0) {
        setState(() => _resendTimeout--);
        _startResendTimer();
      }
    });
  }

  Future<void> _verifyOtp() async {
    setState(() => _isLoading = true);

    try {
      final otp = _otpControllers.map((c) => c.text).join();

      if (otp.length != 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter 6-digit OTP")),
        );
        return;
      }

      // TODO: Implement OTP verification with Firebase
      // Example:
      // await FirebaseAuth.instance.signInWithCredential(
      //   PhoneAuthProvider.credential(
      //     verificationId: widget.verificationId,
      //     smsCode: otp,
      //   ),
      // );

      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      Navigator.pushReplacementNamed(context, '/home');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOtp() async {
    setState(() {
      _isResendLoading = true;
      _resendTimeout = 30;
    });

    try {
      // TODO: Implement resend OTP logic
      // Example:
      // await FirebaseAuth.instance.verifyPhoneNumber(...);

      await Future.delayed(const Duration(seconds: 1));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP resent successfully")),
      );
      _startResendTimer();
    } finally {
      setState(() => _isResendLoading = false);
    }
  }

  void _handleOtpInput(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index].unfocus();
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index].unfocus();
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }

    // Auto-submit if last digit entered
    if (index == 5 && value.isNotEmpty) {
      _verifyOtp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(context).extension<BeautyTheme>()!.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Verify OTP",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Code sent to ${widget.phoneNumber}",
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 40),

                // OTP Input Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 45,
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          counterText: "",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Theme.of(context)
                                  .extension<BeautyTheme>()!
                                  .primaryColor,
                            ),
                          ),
                        ),
                        onChanged: (value) => _handleOtpInput(index, value),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 40),

                // Verify Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _verifyOtp,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text("VERIFY"),
                  ),
                ),
                const SizedBox(height: 20),

                // Resend OTP
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Didn't receive code?"),
                    TextButton(
                      onPressed: _isResendLoading || _resendTimeout > 0
                          ? null
                          : _resendOtp,
                      child: _isResendLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : Text(
                        _resendTimeout > 0
                            ? "Resend in $_resendTimeout"  // Fixed variable name
                            : "Resend OTP",
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}