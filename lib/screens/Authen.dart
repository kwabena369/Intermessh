import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:outcome/widgets/custome_SignIn_btn.dart';
class AuthenPage extends StatefulWidget {
  const AuthenPage({Key? key}) : super(key: key);

  @override
  _AuthenPageState createState() => _AuthenPageState();
}

class _AuthenPageState extends State<AuthenPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

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
                  onPressed: () {
                  },
                ),
                const SizedBox(height: 16),
                CustomSignInButton(
                  icon: const Icon(FontAwesomeIcons.apple),
                  text: 'Continue with Apple',
                  color: Colors.black,
                  textColor: Colors.white,
                  onPressed: () {
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

                //  for the email 
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
      borderRadius: BorderRadius.circular(20.0), //
      borderSide: BorderSide(
        color: Colors.grey, // Default border color
        width: 1.0, // Default border thickness
      ),
    ),
    prefixIcon: Icon(Icons.email), // Email icon
  ),
),
                const SizedBox(height: 16),
             TextFormField(
  obscureText: true, // Hide the text for password input
  decoration: InputDecoration(
    hintText: 'Password',
    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0), // Padding around the text
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0), // Rounded corners
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0), // Keep rounded when focused
      borderSide: BorderSide(
        color: Colors.red, 
        width: 2.0, // Border thickness
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
//  the CWA of the guy is 77 = wow