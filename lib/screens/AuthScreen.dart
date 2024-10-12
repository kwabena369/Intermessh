import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:outcome/services/auth_service.dart';

import '../widgets/custome_SignIn_btn.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();
    Future.microtask(() => _checkLoginStatus());
  }

  void _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString("UserName");
    if (userName != null && userName.isNotEmpty && mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  _buildLogo(),
                  const SizedBox(height: 60),
                  _buildSocialSignInButtons(),
                  const SizedBox(height: 24),
                  const Text('Or', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 24),
                  _buildEmailField(),
                  const SizedBox(height: 16),
                  _buildPasswordField(),
                  const SizedBox(height: 16),
                  _buildConfirmPasswordField(),
                  const SizedBox(height: 24),
                  _buildTermsText(),
                  const SizedBox(height: 16),
                  _buildSignUpButton(),
                  const SizedBox(height: 16),
                  _buildSignInLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Intermessh', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.red)),
                const SizedBox(width: 10),
                Image.asset('assets/Intermessh.png', width: 120, height: 120),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSocialSignInButtons() {
    return Column(
      children: [
        CustomSignInButton(
          icon: Image.asset('assets/Third_party_asserts/Google_.png', width: 24, height: 24),
          text: 'Continue with Google',
          color: Colors.white,
          textColor: Colors.black87,
          onPressed: _handleGoogleSignIn,
        ),
        const SizedBox(height: 16),
        CustomSignInButton(
          icon: const Icon(FontAwesomeIcons.apple),
          text: 'Continue with Apple',
          color: Colors.black,
          textColor: Colors.white,
          onPressed: () {
  //  the apple  authen system here 
           },
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: _inputDecoration('Email', Icons.email),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: _inputDecoration('Password', Icons.lock).copyWith(
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters long';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      decoration: _inputDecoration('Confirm Password', Icons.lock).copyWith(
        suffixIcon: IconButton(
          icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _buildTermsText() {
    return const Text(
      'By continuing, you agree to our Terms of Service and Privacy Policy',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 12, color: Colors.grey),
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: _handleSignUp,
      child: const Text('Sign Up'),
    );
  }

  Widget _buildSignInLink() {
    return TextButton(
      child: const Text('Already have an account? Sign In'),
      onPressed: () {
        // TODO: Navigate to sign in page
      },
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  void _handleGoogleSignIn() async {
    try {
      final userData = await AuthService.signInWithGoogle();
      if (userData != null) {
        final pref = await SharedPreferences.getInstance();
        await pref.setString("UserName", userData['displayName']);
        if (mounted) Navigator.of(context).pushReplacementNamed('/home');
      } else {
        _showErrorSnackBar('Sign in failed. Please try again.');
      }
    } catch (e) {
      print('Error during sign in: $e');
      _showErrorSnackBar('An error occurred. Please try again.');
    }
  }

  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        final result = await AuthService.signUp(_emailController.text, _passwordController.text);
        if (result) {
//   then the nigger goes to the other side 
          if (mounted) Navigator.of(context).pushReplacementNamed('/home');
        } else {
          _showErrorSnackBar('Sign up failed. Please try again.');
        }
      } catch (e) {
        print('Error during sign up: $e');
        _showErrorSnackBar('An error occurred. Please try again.');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

