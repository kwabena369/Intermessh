import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class LocationSharingWidget extends StatefulWidget {
  const LocationSharingWidget({super.key});

  @override
  _LocationSharingWidgetState createState() => _LocationSharingWidgetState();
}

class _LocationSharingWidgetState extends State<LocationSharingWidget> {
  List<Map<String, dynamic>> activeUsers = [];
  String? userId;
  Timer? _timer;
  bool isJoined = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _joinPage() async {
    try {
      final response = await http
          .post(Uri.parse('https://intermessh-backend.vercel.app/api/join'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userId = data['id'];
          activeUsers = List<Map<String, dynamic>>.from(data['activeUsers']);
          isJoined = true;
        });
        _startPolling();
      } else {
        print('Failed to join. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error joining: $e');
    }
  }

  Future<void> _leavePage() async {
    if (userId == null) return;
    try {
      final response = await http.post(
        Uri.parse('https://intermessh-backend.vercel.app/api/leave'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': userId}),
      );
      if (response.statusCode == 200) {
        setState(() {
          userId = null;
          activeUsers = [];
          isJoined = false;
        });
        _timer?.cancel();
      } else {
        print('Failed to leave. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error leaving: $e');
    }
  }

  void _startPolling() {
    _timer = Timer.periodic(Duration(seconds: 5), (_) => _updatePresence());
  }

  Future<void> _updatePresence() async {
    if (userId == null) return;
    try {
      Position position = await Geolocator.getCurrentPosition();
      final response = await http.post(
        Uri.parse('https://intermessh-backend.vercel.app/api/updatePresence'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': userId,
          'lat': position.latitude,
          'long': position.longitude,
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          activeUsers = List<Map<String, dynamic>>.from(data['activeUsers']);
        });
      } else {
        print('Failed to update presence. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating presence: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Sharing'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Your ID: ${userId ?? 'Not joined'}'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: isJoined ? null : _joinPage,
                child: Text('Join'),
              ),
              ElevatedButton(
                onPressed: isJoined ? _leavePage : null,
                child: Text('Leave'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: activeUsers.length,
              itemBuilder: (context, index) {
                final user = activeUsers[index];
                return ListTile(
                  title: Text('User ${user['id']}'),
                  subtitle: Text('Lat: ${user['lat']}, Long: ${user['long']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
