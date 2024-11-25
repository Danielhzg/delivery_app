import 'package:delivery_app/main.dart';
import 'package:delivery_app/pages/admin_page.dart';
import 'package:delivery_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _sendEmailVerification() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
      _showTopNotification('Verification email sent! Please check your inbox.');
    } catch (e) {
      await _showErrorDialog(
        title: 'Error',
        message: 'Could not send verification email. Please try again later.',
      );
    }
  }

  Future<void> _showVerificationDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Email Verification Required',
            style: TextStyle(color: Colors.orange)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Please verify your email address to continue.'),
            const SizedBox(height: 10),
            const Text('1. Check your email inbox'),
            const Text('2. Click the verification link'),
            const Text('3. Then try logging in again'),
            const SizedBox(height: 16),
            const Text('Didn\'t receive the email?'),
            TextButton(
              onPressed: () async {
                await _sendEmailVerification();
                if (!mounted) return;
                Navigator.of(context).pop();
                _showTopNotification('New verification email sent!');
              },
              child: const Text('Resend Verification Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  Future<void> _signIn() async {
    // Validate inputs first
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      await _showErrorDialog(
        title: 'Validation Error',
        message: 'Please enter both email and password.',
      );
      return;
    }

    if (!_isValidEmail(_emailController.text.trim())) {
      await _showErrorDialog(
        title: 'Invalid Email',
        message: 'Please enter a valid email address.',
      );
      return;
    }

    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      // Check if email is verified
      if (!userCredential.user!.emailVerified) {
        await _showVerificationDialog();
        return;
      }

      // Check if user document exists
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        // Create user document if it doesn't exist
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'email': _emailController.text.trim(),
          'isAdmin': false,
          'createdAt': Timestamp.now(),
        });
      }

      final isAdmin = userDoc.data()?['isAdmin'] ?? false;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isAdmin ? const AdminPage() : const MainPage(),
        ),
      );

      _showTopNotification('Login successful!');
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided.';
          break;
        case 'invalid-email':
          message = 'The email address is badly formatted.';
          break;
        case 'user-disabled':
          message = 'This user account has been disabled.';
          break;
        case 'invalid-credential':
          message = 'Please check your email and password and try again.';
          break;
        default:
          message = 'Login error: ${e.message}';
      }
      await _showErrorDialog(title: 'Login Failed', message: message);
    } catch (e) {
      await _showErrorDialog(
        title: 'Unexpected Error',
        message: 'An unexpected error occurred. Please try again later.',
      );
    }
  }

  Future<void> _resetPassword() async {
    if (!_isValidEmail(_emailController.text.trim())) {
      await _showErrorDialog(
        title: 'Invalid Email',
        message: 'Please enter a valid email address first.',
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      if (!mounted) return;
      _showTopNotification('Password reset email sent!');
    } on FirebaseAuthException catch (e) {
      await _showErrorDialog(
        title: 'Reset Password Failed',
        message: e.message ?? 'Could not send reset email.',
      );
    }
  }

  void _showTopNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(20, 100, 20, 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _showErrorDialog(
      {required String title, required String message}) async {
    if (mounted) {
      return showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title,
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK', style: TextStyle(color: Colors.orange)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/login.png', // Path to your cooking-themed image
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 20),
                Text(
                  'Welcome to Golden Spoon',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Login to continue',
                  style: TextStyle(fontSize: 16, color: Colors.orange[700]),
                ),
                const SizedBox(height: 40),
                // Wrap email and password fields in a SizedBox to set a consistent width
                SizedBox(
                  width: double
                      .infinity, // Makes the fields take up all available width
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.email, color: Colors.orange),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double
                      .infinity, // Makes the fields take up all available width
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.lock, color: Colors.orange),
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 30),
                // Wrap ElevatedButton in SizedBox to match input field width
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _signIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    );
                  },
                  child: Text(
                    'Don\'t have an account? Register',
                    style: TextStyle(color: Colors.orange[700]),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: _resetPassword,
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.orange[700]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
