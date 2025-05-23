import 'package:flutter/material.dart';
import 'signin_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? errorMessage;
  String? userType;

  bool _obscurePassword = true;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bitterStyle = GoogleFonts.bitter();
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/PNG/Untitled-1-01.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain, // fit whole image in box
                    ),
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: Text(
                      'Register with us!',
                      style: GoogleFonts.bitter(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Enter your name',
                      border: OutlineInputBorder(),
                      labelText: "Name",
                      labelStyle: bitterStyle,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(),
                      labelText: "Email",
                      labelStyle: bitterStyle,
                    ),
                    validator: (value) {
                      // Future implementation along with the rest, Check the gmail and password, validation for password might be different
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),

                  Padding(padding: EdgeInsets.all(5.0)),

                  TextFormField(
                    controller: _passwordController,
                    textInputAction: TextInputAction.next,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(),
                      labelText: "Password",
                      labelStyle: bitterStyle,
                    ),
                    validator: (value) {
                      // Future implementation along with the rest, Check the gmail and password, validation for password might be different
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: _confirmPasswordController,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password),
                      hintText: 'Enter your password again',
                      border: OutlineInputBorder(),
                      labelText: "Confirm Password",
                      labelStyle: bitterStyle,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  DropdownButton(
                    items: [
                      DropdownMenuItem(
                        value: "Student",
                        child: Text("Student", style: bitterStyle),
                      ),
                      DropdownMenuItem(
                        value: "Professor",
                        child: Text("Professor", style: bitterStyle),
                      ),
                      DropdownMenuItem(
                        value: "Coach",
                        child: Text("Coach", style: bitterStyle),
                      ),
                      DropdownMenuItem(
                        value: "Recruiter",
                        child: Text("Recruiter", style: bitterStyle),
                      ),
                    ],
                    value: userType,
                    onChanged: (String? value) {
                      setState(() {
                        userType = value;
                      });
                    },
                    hint: Text("Choose Your Profession!", style: bitterStyle),
                  ),

                  const SizedBox(height: 30),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (await handleSignUp()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Sign Up Success',
                                style: bitterStyle,
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Incorrect Details, Please Check Again!',
                                style: bitterStyle,
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please fill in all required fields',
                              style: bitterStyle,
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Sign up',
                      style: GoogleFonts.bitter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: 'Already with InnateX ? ',
                        style: bitterStyle,
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SigninPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Login',
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> handleSignUp() async {
    String? result = await AuthService().signup(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
      userType: userType,
      context: context,
    );

    if (result == null) {
      return true;
    } else {
      return false;
    }
  }
}
