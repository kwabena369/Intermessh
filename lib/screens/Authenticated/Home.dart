import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:outcome/services/auth_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isDarkMode = false;
  double _downloadRate = 0.0;
  double _uploadRate = 0.0;
  final String _unitText = 'Mbps';
  late Timer _timer;
  String? _userName;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _startContinuousSpeedTest();
    _loadUserData();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString("UserName") ?? 'User';
      _userEmail = prefs.getString("UserEmail") ?? '';
    });
  }

  void _startContinuousSpeedTest() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _measureDownloadSpeed();
      _measureUploadSpeed();
    });
  }

  Future<void> _measureDownloadSpeed() async {
    const url =
        'https://speed.cloudflare.com/__down?bytes=20000000'; // that is something around ... 20MB file
    final stopwatch = Stopwatch()..start();

    try {
      final response = await http.get(Uri.parse(url));
      stopwatch.stop();

      if (response.statusCode == 200) {
        final durationInSeconds = stopwatch.elapsedMilliseconds / 1000;
        final fileSizeInBits = response.bodyBytes.length * 8;
        final speedInMbps = (fileSizeInBits / durationInSeconds) / 1000000;

        setState(() {
          _downloadRate = speedInMbps;
        });
      }
    } catch (e) {
      print('Download speed test error: $e');
    }
  }

  Future<void> _measureUploadSpeed() async {
    const url = 'https://speed.cloudflare.com/__up';
    const dataSize = 10000000; // 10MB of data
    final data = List.filled(dataSize, 'a').join();
    final stopwatch = Stopwatch()..start();

    try {
      final response = await http.post(Uri.parse(url), body: data);
      stopwatch.stop();

      if (response.statusCode == 200) {
        final durationInSeconds = stopwatch.elapsedMilliseconds / 1000;
        final dataSizeInBits = dataSize * 8;
        final speedInMbps = (dataSizeInBits / durationInSeconds) / 1000000;

        setState(() {
          _uploadRate = speedInMbps;
        });
      }
    } catch (e) {
      print('Upload speed test error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/Intermessh.png', height: 40),
            const SizedBox(width: 10),
            const Text('Intermessh',
                style: TextStyle(fontWeight: FontWeight.bold)),
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
      drawer: _buildDrawer(context),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(_userName ?? 'User'),
            accountEmail: Text(_userEmail ?? ''),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person, size: 50),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              // Navigate to profile page
              Navigator.pop(context);
//   the futrue profile and other
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
             await AuthService.signOut();
              final pref = await SharedPreferences.getInstance();
              await pref.remove("UserName");
              await pref.remove("UserEmail");
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/auth');
              }
            },
          ),
        ],
      ),
    );
  }

//  the single card for the internet information
  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSpeedometer('Download Speed', _downloadRate),
            const SizedBox(height: 20),
            _buildSpeedometer('Upload Speed', _uploadRate),
            const SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeedometer(String title, double speed) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: const [Colors.blue, Colors.purple],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${speed.toStringAsFixed(2)} $_unitText',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  CircularProgressIndicator(
                    value: speed / 100, // Assuming max speed of 100 Mbps
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          icon: Icon(Icons.info),
          label: Text("Fake Info"),
          onPressed: () async {
            Navigator.of(context).pushNamed('/FakeInfo');
            // Implement LocationNow().Getcurrent_location();
          },
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12)),
        ),
        SizedBox(height: 10),
        ElevatedButton.icon(
          icon: Icon(Icons.security),
          label: Text("Proxy Server Testing"),
          onPressed: () {
            Navigator.of(context).pushNamed('/FakeProximity');
          },
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12)),
        ),
        SizedBox(height: 10),
        ElevatedButton.icon(
          icon: Icon(Icons.vpn_lock),
          label: Text("Test Proxy"),
          onPressed: () {
            Navigator.of(context).pushNamed('/TestProxy');
          },
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12)),
        ),
      ],
    );
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
      child: SizedBox(
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
    );
  }
}
