import 'package:flutter/material.dart';
import 'login_page.dart';

import '../auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? errorMessage;
  String? userType;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container(
              //   width: 300,
              //   height: 300,
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //       image: AssetImage("assets/PNG/Untitle d-1-01.png"),
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
              Text(
                'Welcome!',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                  labelText: "Email",
                ),
              ),
              Padding(padding: EdgeInsets.all(5.0)),
              TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.next,
                // obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(),
                  labelText: "Password",
                ),
              ),
              Padding(padding: EdgeInsets.all(5.0)),
              TextFormField(
                controller: confirmPasswordController,
                textInputAction: TextInputAction.done,
                // obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  hintText: 'Enter your password again',
                  border: OutlineInputBorder(),
                  labelText: "Confirm Password ",
                ),
              ),
              DropdownButton(
                items: const [
                  DropdownMenuItem(value: "Student", child: Text("Student")),
                  DropdownMenuItem(
                    value: "Professor",
                    child: Text("Professor"),
                  ),
                  DropdownMenuItem(value: "Coach", child: Text("Coach")),
                  DropdownMenuItem(
                    value: "Recruiter",
                    child: Text("Recruiter"),
                  ),
                ],
                value: userType,
                onChanged: (String? value) {
                  setState(() {
                    userType = value;
                  });
                },
                hint: Text("Choose Your Profession!"),
              ),
              ElevatedButton(
                onPressed: handleSignUp,
                child: const Text(
                  'SIGN UP',
                  style: TextStyle(color: Colors.black, fontSize: 40),
                ),
              ),
              Text(
                "Have an account?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  'Log In',
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleSignUp() async {
    String? result = await AuthService().signup(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
      userType: userType,
      context: context,
    );

    if (result == null) {
      print("Successfully signed up!");
    } else {
      errorMessage = result;
    }
  }
}
