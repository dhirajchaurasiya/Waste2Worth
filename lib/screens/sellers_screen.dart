import 'package:fireflutter/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class SellerMap extends StatefulWidget {
  const SellerMap({super.key});

  @override
  State<SellerMap> createState() => _SellerMapState();
}

class _SellerMapState extends State<SellerMap> {
  Position? _currentPosition; // User's current location
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Automatically fetch the location when the app starts
  }

  // Fetch the current location of the user
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      forceAndroidLocationManager: true,
    ).then((Position position) {
      setState(() {
        currentLocation = position;
        _isLoading = false; // Stop loading once location is fetched
      });
    }).catchError((e) {
      print("Error fetching location: $e");
      setState(() {
        _isLoading = false; // Stop loading even if there's an error
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compost Sellers Map'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show loading spinner
            )
          : FlutterMap(
              options: MapOptions(
                initialCenter: currentLocation != null
                    ? LatLng(currentLocation!.latitude, currentLocation!.longitude)
                    : LatLng(51.509364, -0.128928), // Default to London if location is null
                initialZoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.fireflutter',
                ),
                MarkerLayer(
                  markers: [
                    if (currentLocation != null)
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(
                          currentLocation!.latitude,
                          currentLocation!.longitude,
                        ),
                        child:  Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 50.0,
                        ),
                      ),
                  ],
                ),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () => launchUrl(
                        Uri.parse('https://openstreetmap.org/copyright'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
