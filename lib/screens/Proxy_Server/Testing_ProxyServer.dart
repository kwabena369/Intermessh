import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';

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
  bool _isServerRunning = false;
  String _ipAddress = '';
  int _port = 8080;
  HttpServer? _server;
  final info = NetworkInfo();

  Future<void> _toggleServer() async {
    if (!_isServerRunning) {
      await _startServer();
    } else {
      await _stopServer();
    }
  }

  Future<void> _startServer() async {
    try {
      _ipAddress = await info.getWifiIP() ?? '';
      if (_ipAddress.isEmpty) {
        throw Exception('No valid network interface found');
      }

      final handler = const shelf.Pipeline()
          .addMiddleware(shelf.logRequests())
          .addHandler(_handleRequest);

      _server = await io.serve(handler, _ipAddress, _port);

      setState(() {
        _isServerRunning = true;
      });
      print('Proxy server running on $_ipAddress:$_port');
    } catch (e) {
      print('Error starting server: $e');
      setState(() {
        _ipAddress = 'Error occurred';
      });
    }
  }

  Future<void> _stopServer() async {
    await _server?.close();
    setState(() {
      _isServerRunning = false;
      _ipAddress = '';
    });
  }

  Future<shelf.Response> _handleRequest(shelf.Request request) async {
    print('Proxying request: ${request.method} ${request.url}');

    try {
      final String url = request.url.toString();
      final headers = Map<String, String>.from(request.headers);
      headers.remove('host');

      final http.Client client = http.Client();
      final http.StreamedResponse proxyResponse = await client.send(
          http.Request(request.method, Uri.parse(url))
            ..headers.addAll(headers)
            ..bodyBytes =
                await request.read().expand((element) => element).toList());

      client.close();

      return shelf.Response(
        proxyResponse.statusCode,
        body: proxyResponse.stream,
        headers: proxyResponse.headers,
      );
    } catch (e) {
      print('Proxy error: $e');
      return shelf.Response.internalServerError(body: 'Proxy error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Internet Sharing Proxy')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Server Status: ${_isServerRunning ? 'Running' : 'Stopped'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('IP Address: $_ipAddress', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Port: $_port', style: TextStyle(fontSize: 18)),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _toggleServer,
              child: Text(_isServerRunning ? 'Stop Server' : 'Start Server'),
            ),
            SizedBox(height: 24),
            Text('To use this proxy on another device:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('1. Connect to the same WiFi network',
                style: TextStyle(fontSize: 16)),
            Text('2. Set proxy settings to:', style: TextStyle(fontSize: 16)),
            Text('   Host: $_ipAddress', style: TextStyle(fontSize: 16)),
            Text('   Port: $_port', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
