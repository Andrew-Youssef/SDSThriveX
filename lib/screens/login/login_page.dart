import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
              TextField(
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
              TextField(
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
                onPressed: logIn,
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  'GET STARTED',
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future logIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      print(emailController.text.trim());
      print(passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      // https://stackoverflow.com/questions/77312410/flutter-firebase-authentication-with-email-password-not-functioning-as-intende/77312743#77312743
      // if (e.code == 'user-not-found') {
      //   // print('No user found for that email.'); future console
      // } else if (e.code == 'wrong-password') {
      //   // print('Wrong password provided for that user.'); future console
      // }
    }
  }
}
