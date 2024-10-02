// ignore_for_file: use_super_parameters, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:outcome/services/Dedug/Classic_debug.dart';
import 'package:outcome/services/Location_Asset/assets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isDarkMode = false;
  double _downloadRate = 0.0;
  double _uploadRate = 0.0;
  String _unitText = 'Mbps';
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startContinuousSpeedTest();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startContinuousSpeedTest() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _measureDownloadSpeed();
      _measureUploadSpeed();
    });
  }

  Future<void> _measureDownloadSpeed() async {
    final url =
        'https://speed.cloudflare.com/__down?bytes=20000000'; // 20MB file
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
    final url = 'https://speed.cloudflare.com/__up';
    final dataSize = 10000000; // 10MB of data
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
            Image.asset('assets/Intermessh.png', height: 50),
            const SizedBox(width: 10),
            const Text('Intermessh '),
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
              child: Container(
//   here we do the placement of the logo andthe name
     child: Center(
       child: Row(
         children: [
          //   the logo
          Image(image: AssetImage('assets/Intermessh.png'),width: 120, height: 120,),
          //   the other element been the name

 Padding(padding: EdgeInsets.only(left: 6),
 child: Text("Intermessh",
 style: TextStyle(
  color: Colors.white,
  fontSize: 25,
  fontWeight: FontWeight.bold
 ),),)
         ],

       ),
     ),
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
            //  there is something there

            _buildSpeedometer('Download Speed', _downloadRate),
            const SizedBox(height: 20),
            _buildSpeedometer('Upload Speed', _uploadRate),
            //  the btn to go to the payment

//  Padding(padding: EdgeInsets.all(20),
//  child: Row(
//               children: [
//             ElevatedButton(onPressed: (){
//                      Navigator.of(context).pushReplacementNamed('/Payment_/test');
//             }, child: Text("Test_Payment")),

            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pushReplacementNamed('/FakeInfo');
                        final value_Now = await LocationNow();
                        value_Now.Getcurrent_location();
                      },
                      child: Text("Fake_Info -  ")),
//  for the backend socket side conection
                  ElevatedButton(
                      onPressed: () {
                        print("btn_there");
                        Navigator.of(context)
                            .pushReplacementNamed('/FakeProximity');
                        // final Debug_class = Classic_debug().Check_try_two();
                      },
                      child: const Text("FakeProximity"))
                ],
              ),
            )
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

  Widget _buildSpeedometer(String title, double speed) {
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
    );
  }
}
