import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isDarkMode = false;
  double _downloadRate = 0.0;
  String _downloadProgress = '0';
  String _unitText = 'Kbps';
  bool _isTesting = false;

  @override
  void initState() {
    super.initState();
    _startSpeedTest();
  }

  Future<void> _startSpeedTest() async {
    setState(() {
      _isTesting = true;
      _downloadRate = 0.0;
      _downloadProgress = '0';
    });

    final url = 'https://drive.google.com/file/d/1lEn1DtJQW6-nTcoS_FG7-EB3Kamy0147/view?usp=sharing';
    final stopwatch = Stopwatch()..start();

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final elapsed = stopwatch.elapsedMilliseconds;
        final speedInKbps = ((response.bodyBytes.length / 1024) / (elapsed / 1000)) * 8;

        setState(() {
          _isTesting = false;
          _downloadRate = speedInKbps;
          _downloadProgress = '100';
          _unitText = 'Kbps';
        });
      } else {
        _showErrorDialog('Failed to download the file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog('Error: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    setState(() {
      _isTesting = false;
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
            const Text('Internet Speed Test'),
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
              onTap: () async {
                final pref = await SharedPreferences.getInstance();
                await pref.remove("UserName");
                if (context.mounted) {
                  Navigator.of(context).pushReplacementNamed('/auth');
                }
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSpeedometer('Download Speed', _downloadRate, _downloadProgress),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isTesting ? null : _startSpeedTest,
        child: Icon(_isTesting ? Icons.hourglass_empty : Icons.refresh),
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

  Widget _buildSpeedometer(String title, double speed, String progress) {
    return Column(
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
              colors: [Colors.blue, Colors.purple],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${speed.toStringAsFixed(2)} $_unitText',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                'Progress: $progress%',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(
                value: double.parse(progress) / 100,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}