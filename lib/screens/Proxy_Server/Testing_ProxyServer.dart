import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;


class ProxyServerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProxyServerScreen(),
    );
  }
}

class ProxyServerScreen extends StatefulWidget {
  @override
  _ProxyServerScreenState createState() => _ProxyServerScreenState();
}

class _ProxyServerScreenState extends State<ProxyServerScreen> {
  String _serverStatus = 'Stopped';
  String _ipAddress = '';
  int _port = 8080;
  HttpServer? _server;

  Future<void> _startServer() async {
    try {
      // Get all network interfaces
      List<NetworkInterface> interfaces = await NetworkInterface.list(
        includeLoopback: false,
        type: InternetAddressType.IPv4,
      );

      // Find the first non-loopback IPv4 address
      for (var interface in interfaces) {
        if (interface.addresses.isNotEmpty) {
          _ipAddress = interface.addresses.first.address;
          break;
        }
      }

      if (_ipAddress.isEmpty) {
        throw Exception('No valid network interface found');
      }

      final handler = const shelf.Pipeline()
          .addMiddleware(shelf.logRequests())
          .addHandler(_handleRequest);

      _server = await io.serve(handler, _ipAddress, _port);

      setState(() {
        _serverStatus = 'Running';
      });

      print('Server running on $_ipAddress:$_port');
    } catch (e) {
      print('Error starting server: $e');
      setState(() {
        _serverStatus = 'Error: ${e.toString()}';
        _ipAddress = 'Error occurred';
      });
    }
  }

  Future<void> _stopServer() async {
    await _server?.close();
    setState(() {
      _serverStatus = 'Stopped';
      _ipAddress = '';
    });
  }

  shelf.Response _handleRequest(shelf.Request request) {
    print('Received request: ${request.method} ${request.url}');
    // Here you would implement the actual proxy logic
    return shelf.Response.ok('Proxy request received for: ${request.url}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Local Network Proxy Server')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Server Status: $_serverStatus'),
            Text('IP Address: $_ipAddress'),
            Text('Port: $_port'),
            ElevatedButton(
              onPressed:
                  _serverStatus == 'Stopped' ? _startServer : _stopServer,
              child: Text(
                  _serverStatus == 'Stopped' ? 'Start Server' : 'Stop Server'),
            ),
          ],
        ),
      ),
    );
  }
}
