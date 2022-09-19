import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:map_exam/home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String idScreen = "loginScreen";
  static Route route() =>
      MaterialPageRoute(builder: (_) => const LoginScreen());
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future signIn({
    String? email,
    String? password,
  }) async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email!.trim(),
            password: password!.trim(),
          )
          .then(
            (value) => Navigator.pushNamedAndRemoveUntil(
              context,
              HomeScreen.idScreen,
              (route) => false,
            ),
          );
    } catch (e) {
      log(
        e.toString(),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Please sign in', style: TextStyle(fontSize: 35.0)),
              const SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration:
                    const InputDecoration(hintText: 'Type your email here'),
                onTap: () {},
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: 'Type your password',
                ),
                onTap: () {},
              ),
              const SizedBox(height: 10.0),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : ElevatedButton(
                      child: const Text('Sign in'),
                      onPressed: () async {
                        signIn(
                          email: _usernameController.text,
                          password: _passwordController.text,
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
