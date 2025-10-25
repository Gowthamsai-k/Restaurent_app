import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// 1. Add the SingleTickerProviderStateMixin
class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // --- Auth Controllers ---
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _verificationId = '';
  bool _otpSent = false;
  bool _isLoading = false;

  // 2. Define Animation Controllers and Animations
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  late Animation<Offset> _titleSlideAnimation;
  late Animation<Offset> _formSlideAnimation;

  @override
  void initState() {
    super.initState();

    // 3. Initialize the Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800), // 1.8 second animation
    );

    // General fade animation
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // Logo slides down (from -0.5 offset to 0)

    // Title slides up (from 0.5 offset to 0)
    _titleSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
          ),
        );

    // Form slides up (from 0.5 offset to 0)
    _formSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
          ),
        );

    // 4. Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    // 5. Dispose the controllers
    _controller.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // --- Auth Functions (No changes here) ---
  Future<void> _sendOTP() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter phone number')),
      );
      return;
    }

    if (!mounted) return;
    setState(() => _isLoading = true);

    await _auth.verifyPhoneNumber(
      phoneNumber: '+91$phone',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await _auth.signInWithCredential(credential);
          if (mounted) _onLoginSuccess();
        } catch (e) {
          if (mounted) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Auto verification failed: $e')),
            );
          }
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: ${e.message}')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        if (!mounted) return;
        setState(() {
          _verificationId = verificationId;
          _otpSent = true;
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('OTP sent successfully')));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> _verifyOTP() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter OTP')));
      return;
    }

    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      if (mounted) _onLoginSuccess();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP verification failed: ${e.message}')),
      );
    }
  }

  void _onLoginSuccess() {
    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }
  // --- End Auth Functions ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  // --- TOP 75% SECTION (Image and Title) ---
                  Expanded(
                    child: Container(
                      color: const Color.fromARGB(255, 60, 107, 62),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 6. Wrap Logo in animations
                            FadeTransition(
                              opacity: _fadeAnimation,

                              child: Image.asset(
                                'assets/images/logo.png',
                                height: 120,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // --- END OPTIMIZATION ---

                  // --- BOTTOM 25% SECTION (Form) ---
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 20.0,
                    ),
                    // 7. Wrap Form in animations
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Login Title
                          SlideTransition(
                            position: _titleSlideAnimation,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Text(
                                'Login',
                                style: GoogleFonts.righteous(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                ),
                              ),
                            ),
                          ),
                          // Form Fields
                          SlideTransition(
                            position: _formSlideAnimation,
                            child: Column(
                              children: [
                                TextField(
                                  controller: _phoneController,
                                  decoration: const InputDecoration(
                                    labelText: 'Phone Number',
                                    border: OutlineInputBorder(),
                                    prefixText: '+91 ',
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 12),
                                if (_otpSent)
                                  TextField(
                                    controller: _otpController,
                                    decoration: const InputDecoration(
                                      labelText: 'Enter OTP',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                if (_otpSent) const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _isLoading
                                        ? null
                                        : _otpSent
                                        ? _verifyOTP
                                        : _sendOTP,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[700],
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : Text(
                                            _otpSent
                                                ? 'Verify OTP'
                                                : 'Send OTP',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- Back Button ---
          Positioned(
            top: 40,
            left: 10,
            // 8. Wrap Back Button in fade
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Back',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
