import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class CityFinderWidget extends StatefulWidget {
  final double latitude;
  final double longitude;

  CityFinderWidget({required this.latitude, required this.longitude});

  @override
  _CityFinderWidgetState createState() => _CityFinderWidgetState();
}

class _CityFinderWidgetState extends State<CityFinderWidget> {
  String _city = 'Нажмите кнопку, чтобы найти город';

  Future<void> _findCity() async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(widget.latitude, widget.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _city = place.locality ?? 'Город не найден';
        });
      } else {
        setState(() {
          _city = 'Город не найден';
        });
      }
    } catch (e) {
      setState(() {
        _city = 'Ошибка: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Найти город по координатам'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _city,
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _findCity,
              child: Text('Найти город'),
            ),
          ],
        ),
      ),
    );
  }
}

class LocationWidget extends StatelessWidget {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
      future: _determinePosition(),
      builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading indicator while waiting
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Show error message
        } else if (snapshot.hasData) {
          Position position = snapshot.data!;
          return CityFinderWidget(
            latitude: position.latitude, // Пример: широта Москвы
            longitude: position.altitude, // Пример: долгота Москвы
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }
}
