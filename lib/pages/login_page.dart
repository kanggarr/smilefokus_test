import 'package:flutter/material.dart';
import 'package:smilefokus_test/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? emailError;
  String? passwordError;
  String? loginError;

  final String correctEmail = 'smile@smilefokus.com';
  final String correctPassword = '11111111';

  void _validateAndLogin() {
    setState(() {
      emailError = null;
      passwordError = null;
      loginError = null;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    bool isEmailValid = emailRegex.hasMatch(email);
    bool isPasswordValid = RegExp(r'^\d{8}$').hasMatch(password);

    if (!isEmailValid) {
      emailError = 'Please enter a valid email';
    }
    if (!isPasswordValid) {
      passwordError = 'Password must be 8 digits';
    }

    if (isEmailValid && isPasswordValid) {
      if (email == correctEmail && password == correctPassword) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Login successful')),
        // );

        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Home(
                firstName: 'smile',
                lastName: 'Challenge',
              ),
            ),
          );
        });
      } else {
        loginError = 'Incorrect email or password';
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const Text(
                'smileReward',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000)),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  errorText: emailError,
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  errorText: passwordError,
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                obscureText: true,
                keyboardType: TextInputType.number,
              ),
              if (loginError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    loginError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _validateAndLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
