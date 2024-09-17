import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vector;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  bool _isDarkMode = false;
  double _downloadSpeed = 0.0;
  double _uploadSpeed = 0.0;
  Timer? _speedUpdateTimer;
  late AnimationController _downloadAnimationController;
  late AnimationController _uploadAnimationController;

  @override
  void initState() {
    super.initState();
    _startSpeedSimulation();
    _downloadAnimationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _uploadAnimationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _speedUpdateTimer?.cancel();
    _downloadAnimationController.dispose();
    _uploadAnimationController.dispose();
    super.dispose();
  }

  void _startSpeedSimulation() {
    _speedUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _downloadSpeed = (DateTime.now().millisecond % 100).toDouble();
        _uploadSpeed = (DateTime.now().second % 50).toDouble();
        _downloadAnimationController.animateTo(_downloadSpeed / 100);
        _uploadAnimationController.animateTo(_uploadSpeed / 50);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/Intermessh.png', height: 30),
            const SizedBox(width: 10),
            const Text('Internet Status'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              // onPressed: () {
              //   // Implement logout functionality
              //   Navigator.of(context).pop(); // Close the drawer
              //   // Add your logout logic here
              // },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSpeedometer('Download Speed', _downloadSpeed, _downloadAnimationController),
            const SizedBox(height: 20),
            _buildSpeedometer('Upload Speed', _uploadSpeed, _uploadAnimationController),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          child: Center(
            child: Text(
              'Powered by Intermessh',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpeedometer(String title, double speed, AnimationController controller) {
    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return CustomPaint(
                painter: SpeedometerPainter(
                  speed: controller.value,
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Text(
                    '${speed.toStringAsFixed(1)} Mbps',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SpeedometerPainter extends CustomPainter {
  final double speed;
  final Color color;

  SpeedometerPainter({required this.speed, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      vector.radians(150),
      vector.radians(240),
      false,
      paint,
    );

    final needlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final needleLength = radius - 20;
    final angle = vector.radians(150 + 240 * speed);
    final needleEnd = Offset(
      center.dx + needleLength * cos(angle),
      center.dy + needleLength * sin(angle),
    );

    canvas.drawLine(center, needleEnd, needlePaint..strokeWidth = 3);
    canvas.drawCircle(center, 10, needlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}