import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:outcome/firebase_options.dart';
import 'package:outcome/screens/Authen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:outcome/screens/Authenticated/Home.dart';
import 'package:outcome/screens/FromBack/Information.dart';
import 'package:outcome/screens/PaymentSelection/Real_Payment.dart';
import 'package:outcome/screens/Payment_/UsersForm.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }

  // Enable back button callback
  SystemChannels.platform.invokeMethod('SystemNavigator.setNavigationBarColor', Colors.transparent);

  runApp(MaterialApp(
    home: const SplashScreen(),
    title: 'Intermessh',
    debugShowCheckedModeBanner: false,
    routes: {
      '/auth': (context) => const AuthenPage(),
      '/home': (context) => const Home(),
      '/Payment_/test':(context)=>const UsersForm(),
      '/FakeInfo':(context)=>const Blog(),
      'RealPayment':(context)=>const RealPayment(),
    },
  ));
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3)); // Minimum splash screen duration

    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString("UserName");

    if (!mounted) return; // Check if the widget is still in the tree

    if (userName != null && userName.isNotEmpty) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Navigator.of(context).pushReplacementNamed('/auth');
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Image.asset(
                          'assets/Intermessh.png',
                          width: 150,
                          height: 150,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.apartment, size: 150, color: Colors.red);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'From',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'RoomBerl',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}