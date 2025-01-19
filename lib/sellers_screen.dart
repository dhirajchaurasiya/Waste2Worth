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

  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Automatically fetch the location when the app starts
  }

    // Fetch the current location of the user
  _getCurrentLocation() async{
    await Geolocator
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
      .then((Position position) {
        setState(() {
          _currentPosition = position;
          print(_currentPosition);
        });
      }).catchError((e) {
        print(e); 
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compost Sellers Map'),),
      body: FlutterMap(
              options: MapOptions(
                initialCenter:
                    LatLng(51.509364, -0.128928), // Center the map over London
                initialZoom: 9.2,
              ),
              children: [
                TileLayer(
                  // Display map tiles from any source
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server
                  userAgentPackageName: 'com.example.fireflutter',
                  // And many more recommended properties!
                ),
                RichAttributionWidget(
                  // Include a stylish prebuilt attribution widget that meets all requirments
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () => launchUrl(Uri.parse(
                          'https://openstreetmap.org/copyright')), // (external)
                    ),
                    // Also add images...
                  ],
                ),
                
              if (_currentPosition != null) Text(
              "LAT: ${_currentPosition!.latitude}, LNG: ${_currentPosition!.longitude}"
            ),
            TextButton(
              child: Text("Get location"),
              onPressed: () {
                _getCurrentLocation();
              },
            ),
              ],
            ),
    );
  }
}

// ADDED OSM MAP TO THE PROJECT. NEED TO FIND THE EXACT LOCATION OF THE USER. AND THEN ADD MARKERS TO THE MAP. THAT'S ALL I GUESS