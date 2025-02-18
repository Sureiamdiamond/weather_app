/*import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationWidget extends StatefulWidget {
  @override
  _LocationWidgetState createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  String _locationMessage = "Fetching location...";
  Location _location = Location();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    // Проверка, включена ли служба геолокации
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        setState(() {
          _locationMessage = "Location services are disabled.";
        });
        return;
      }
    }

    // Проверка разрешений
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        setState(() {
          _locationMessage = "Location permissions are denied.";
        });
        return;
      }
    }

    // Получение текущего местоположения
    LocationData locationData = await _location.getLocation();
    setState(() {
      _locationMessage =
          "Latitude: ${locationData.latitude}, Longitude: ${locationData.longitude}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location Widget"),
      ),
      body: Center(
        child: Text(
          _locationMessage,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
*/