import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:outcome/widgets/custome_SignIn_btn.dart';

import '../services/Google/Authen.dart';

//  in here the person would select the option that they would in doing the things
class AuthenPage extends StatefulWidget {
  const AuthenPage({Key? key}) : super(key: key);

  @override
  _AuthenPageState createState() => _AuthenPageState();
}

class _AuthenPageState extends State<AuthenPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  ValueNotifier userCredential = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    // Use a Future.microtask to schedule the login check after the build is complete
    Future.microtask(() => _checkLoginStatus());
  }

  void _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString("UserName");
    if (userName != null && userName.isNotEmpty) {
      // User is already logged in, navigate to home screen
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        //  for scrrollabity sake with do that there ,,..
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Intermessh',
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Image.asset(
                                'assets/Intermessh.png',
                                width: 120,
                                height: 120,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 60),
                CustomSignInButton(
                  icon: Image.asset(
                    'assets/Third_party_asserts/Google_.png',
                    width: 24,
                    height: 24,
                  ),
                  text: 'Continue with Google',
                  color: Colors.white,
                  textColor: Colors.black87,
                  onPressed: () async {
                    try {
                      final userData = await signInWithGoogle();
                      if (userData != null) {
                        final pref = await SharedPreferences.getInstance();
                        pref.setString("UserName", userData['displayName']);
                        print(userData);
                        // Navigator.of(context).pushReplacementNamed('/home');
                        return;
                      } else {
                        print('Sign in failed');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Sign in failed. Please try again.')),
                        );
                      }
                    } catch (e) {
                      print('Error during sign in: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('An error occurred. Please try again.')),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                CustomSignInButton(
                  icon: const Icon(FontAwesomeIcons.apple),
                  text: 'Continue with Apple',
                  color: Colors.black,
                  textColor: Colors.white,
                  onPressed: () {
                    // Implement Apple sign in
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Or',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'By continuing, you agree to our Terms of Service and Privacy Policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  child: const Text('Sign Up'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  onPressed: () {
                    // Implement email/password sign-up
                  },
                ),
                const SizedBox(height: 16),
                TextButton(
                  child: const Text('Already have an account? Sign In'),
                  onPressed: () {
                    // Navigate to sign in page
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
