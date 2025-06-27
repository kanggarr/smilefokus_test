import 'package:flutter/material.dart';
import 'package:smilefokus_test/home.dart'; // นำเข้าไฟล์ HomePage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // TextField อีเมลและรหัสผ่าน
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // ตัวแปรเก็บข้อความแสดงข้อผิดพลาด
  String? emailError;
  String? passwordError;
  String? loginError;

  // อีเมลและรหัสผ่านที่ถูกต้อง
  final String correctEmail = 'smile@smilefokus.com';
  final String correctPassword = '11111111';

  // ฟังก์ชันตรวจสอบข้อมูลและล็อกอิน
  void _validateAndLogin() {
    setState(() {
      emailError = null;
      passwordError = null;
      loginError = null;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // ตรวจสอบรูปแบบอีเมลด้วย Regular Expression
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    bool isEmailValid = emailRegex.hasMatch(email);

    // ตรวจสอบว่ารหัสผ่านเป็นตัวเลข 8 หลัก
    bool isPasswordValid = RegExp(r'^\d{8}$').hasMatch(password);

    // กำหนดข้อความแสดงข้อผิดพลาดถ้าไม่ผ่าน validation
    if (!isEmailValid) {
      emailError = 'Please enter a valid email';
    }
    if (!isPasswordValid) {
      passwordError = 'Password must be 8 digits';
    }

    // ถ้าผ่าน validation ทั้งสอง
    if (isEmailValid && isPasswordValid) {
      // ตรวจสอบว่าอีเมลและรหัสผ่านตรงกับข้อมูลที่กำหนดไว้หรือไม่
      if (email == correctEmail && password == correctPassword) {
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
        // กรณีข้อมูลล็อกอินไม่ถูกต้อง
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
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 40),
              // ช่องกรอกอีเมล พร้อมแสดง error ถ้าตรวจสอบไม่ผ่าน
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
              // ช่องกรอกรหัสผ่านพร้อมแสดง error
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
              // ข้อความแสดงข้อผิดพลาดการล็อกอิน (เช่น รหัสผ่านผิด)
              if (loginError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    loginError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 32),
              // ปุ่ม Sign In
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      _validateAndLogin, // เรียกฟังก์ชันตรวจสอบและล็อกอิน
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFFFFF),
                    ),
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
