import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required String title});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _keepLoggedIn = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final bitterStyle = GoogleFonts.bitter();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top-left logo
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                    'assets/InnateX-04.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain, // fit whole image in box
                  ),
              ),

              const SizedBox(height: 10),

              /// Sign in title
              Center(
                child: Text(
                  'Sign in',
                  style: GoogleFonts.bitter(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Email input
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email or phone',
                  labelStyle: bitterStyle,
                  border: const OutlineInputBorder(),
                ),
                style: bitterStyle,
              ),

              const SizedBox(height: 10),

              /// Password input
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: bitterStyle,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                style: bitterStyle,
              ),

              const SizedBox(height: 10),

              /// Forgot password
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot password?',
                    style: GoogleFonts.bitter(color: Colors.blue),
                  ),
                ),
              ),

              /// Keep me logged in
              Row(
                children: [
                  Checkbox(
                    value: _keepLoggedIn,
                    onChanged: (value) {
                      setState(() {
                        _keepLoggedIn = value ?? false;
                      });
                    },
                  ),
                  Text('Keep me logged in', style: bitterStyle),
                ],
              ),

              const SizedBox(height: 10),

              /// Sign in button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();

                  if (email.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please enter both email and password.',
                          style: bitterStyle,
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // If valid, navigate to dashboard
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyDashBoardScreen(),
                    ),
                  );
                },
                child: Text(
                  'Sign in',
                  style: GoogleFonts.bitter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Register text
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'New to InnateX? ',
                    style: bitterStyle,
                    children: [
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RegisterScreen()),
                            );
                          },
                          child: Text(
                            'Register',
                            style: GoogleFonts.bitter(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}