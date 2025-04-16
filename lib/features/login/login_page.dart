import 'package:flutter/material.dart';
import '../signup/signup_page.dart';
import '../../core/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? errorMessage;

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
                textInputAction: TextInputAction.done,
                // obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(),
                  labelText: "Password",
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgotten password?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              ElevatedButton(
                onPressed: handleLogIn,
                child: const Text(
                  'LOGIN',
                  style: TextStyle(color: Colors.black, fontSize: 40),
                ),
              ),
              Text(
                "Don't have an account?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleLogIn() async {
    String? result = await AuthService().login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      context: context,
    );

    if (result == null) {
      print("Successfully signed up!");
    } else {
      errorMessage = result;
    }
  }
}
