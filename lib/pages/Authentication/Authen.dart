import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AuthenPage extends StatelessWidget {
  const AuthenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40),
              Row(
                children: [
                  CustomPaint(
                    size: Size(40, 40),
                    painter: LogoPainter(),
                  ),
                  SizedBox(width: 10),
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
              SizedBox(height: 60),
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton.icon(
                icon: FaIcon(FontAwesomeIcons.google, color: Colors.white),
                label: Text('Continue with Google'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  // Implement Google Sign-In
                },
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                icon: FaIcon(FontAwesomeIcons.apple, color: Colors.white),
                label: Text('Continue with Apple'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  // Implement Apple Sign-In
                },
              ),
              SizedBox(height: 24),
              Text(
                'Or',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  // Implement email/password sign-in
                },
                child: Text('Sign In'),
              ),
              SizedBox(height: 16),
              TextButton(
                child: Text('Forgot Password?'),
                onPressed: () {
                  // Implement password reset
                },
              ),
              Spacer(),
              Text(
                'By continuing, you agree to our Terms of Service and Privacy Policy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 4;

    // Draw circles and lines (same as in SplashScreen)
    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(Offset(center.dx - radius, center.dy), radius / 2, paint);
    canvas.drawCircle(Offset(center.dx + radius, center.dy), radius / 2, paint);
    canvas.drawCircle(Offset(center.dx, center.dy - radius), radius / 2, paint);
    canvas.drawCircle(Offset(center.dx, center.dy + radius), radius / 2, paint);

    canvas.drawLine(Offset(center.dx - radius, center.dy), Offset(center.dx + radius, center.dy), paint);
    canvas.drawLine(Offset(center.dx, center.dy - radius), Offset(center.dx, center.dy + radius), paint);
    canvas.drawLine(center, Offset(center.dx - radius, center.dy), paint);
    canvas.drawLine(center, Offset(center.dx + radius, center.dy), paint);
    canvas.drawLine(center, Offset(center.dx, center.dy - radius), paint);
    canvas.drawLine(center, Offset(center.dx, center.dy + radius), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}