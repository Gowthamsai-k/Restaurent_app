import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _logoSlideAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _buttonSlideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      // 1. Longer duration, as you requested
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // 2. Logo slides down from the top
    _logoSlideAnimation =
        Tween<Offset>(
          begin: const Offset(0, -1.1), // Start 110% above its position
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(
              0.0,
              0.5,
              curve: Curves.easeOut,
            ), // 0.0s to 1.25s
          ),
        );
    _logoFadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );

    // 3. Text slides up from below the logo
    _textSlideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 1.1), // Start 110% below its position
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(
              0.3,
              0.7,
              curve: Curves.easeOut,
            ), // 0.75s to 1.75s
          ),
        );
    _textFadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
    );

    // 4. Buttons slide up from the bottom
    _buttonSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(
              0.6,
              1.0,
              curve: Curves.easeInOutBack,
            ), // 1.5s to 2.5s
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              // 5. Removed the fade from the whole container
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: const Color.fromARGB(255, 75, 134, 78)),
                  Container(color: Colors.black.withOpacity(0.2)),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // --- ANIMATED LOGO ---
                        FadeTransition(
                          opacity: _logoFadeAnimation,
                          child: SlideTransition(
                            position: _logoSlideAnimation,
                            child: Image.asset(
                              'assets/images/logo.png',
                              height: 150,
                            ),
                          ),
                        ),
                        // --- END ANIMATED LOGO ---
                        const SizedBox(height: 8),
                        // --- ANIMATED TEXT ---
                        FadeTransition(
                          opacity: _textFadeAnimation,
                          child: SlideTransition(
                            position: _textSlideAnimation,
                            child: Text(
                              'ZOM-REP',
                              style: GoogleFonts.righteous(
                                color: Colors.white,
                                fontSize: 50,
                                shadows: const [
                                  Shadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 3,
                                    color: Colors.black45,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // --- END ANIMATED TEXT ---
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // --- ANIMATED BUTTONS ---
            SlideTransition(
              position: _buttonSlideAnimation,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.green[700]!, width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.green[800],
                          ),
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
