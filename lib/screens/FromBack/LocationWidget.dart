import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationWidget extends StatefulWidget {
  const LocationWidget({super.key});

  @override
  _LocationWidgetState createState() => _LocationWidgetState();
}
// Green space
class _LocationWidgetState extends State<LocationWidget> {
  String _latitude = 'Unknown';
  String _longitude = 'Unknown';
  String _country = 'Unknown';
  String _place = 'Unknown';
  String _debug = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _debug = 'Getting current location...';
    });
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _debug = 'Location permissions are denied';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _debug = 'Location permissions are permanently denied';
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _latitude = position.latitude.toStringAsFixed(4);
        _longitude = position.longitude.toStringAsFixed(4);
        _debug = 'Position obtained. Getting address...';
      });
      await _getAddressFromLatLng(position);
    } catch (e) {
      setState(() {
        _debug = 'Error: $e';
      });
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _country = place.country ?? 'Unknown';
          _place = place.locality ?? place.subAdministrativeArea ?? 'Unknown';
          _debug = 'Address obtained successfully';
        });
      } else {
        await _getAddressFromAPI(position);
      }
    } catch (e) {
      await _getAddressFromAPI(position);
    }
  }

  Future<void> _getAddressFromAPI(Position position) async {
    try {
      final response = await http.get(Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}&zoom=18&addressdetails=1'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _country = data['address']['country'] ?? 'Unknown';
          _place = data['address']['city'] ??
              data['address']['town'] ??
              data['address']['village'] ??
              'Unknown';
          _debug = 'Address obtained from API';
        });
      } else {
        setState(() {
          _debug = 'Failed to get address from API';
        });
      }
    } catch (e) {
      setState(() {
        _debug = 'Error getting address from API: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Current Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Latitude: $_latitude',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Longitude: $_longitude',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Country: $_country',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Place: $_place',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Debug: $_debug',
              style: TextStyle(fontSize: 14, color: Colors.red),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: Text('Refresh Location'),
            ),
          ],
        ),
      ),
    );
  }
}
