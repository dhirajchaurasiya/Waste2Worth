import 'package:cloud_firestore/cloud_firestore.dart';
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
  var db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> saleslist = []; // List to store sales data

  @override
  void initState() {
    super.initState();
    _fetchSalesDetails();
    _getCurrentLocation();
  }

  // Fetch sales details from Firebase
  Future<void> _fetchSalesDetails() async {
    try {
      QuerySnapshot snapshot = await db.collection("salesdetails").get();
      List<Map<String, dynamic>> tempSalesList = [];

      for (var element in snapshot.docs) {
        tempSalesList.add(element.data() as Map<String, dynamic>);
      }

      setState(() {
        saleslist = tempSalesList;
      });

      print("Sales details fetched successfully.");
    } catch (e) {
      print("Error fetching sales details: $e");
    }
  }

  // Fetch user's current location
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true,
      );

      setState(() {
        currentLocation = position;
        _isLoading = false;
      });

      print(
          "Current location: ${currentLocation!.latitude}, ${currentLocation!.longitude}");
    } catch (e) {
      print("Error fetching location: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Compost Sellers Map')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : FlutterMap(
              options: MapOptions(
                initialCenter: currentLocation != null
                    ? LatLng(
                        currentLocation!.latitude, currentLocation!.longitude)
                    : LatLng(51.509364,
                        -0.128928), // Default to London if location is null
                initialZoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.fireflutter',
                ),

                // Marker Layer
                MarkerLayer(
                  markers: [
                    // User's current location marker
                    if (currentLocation != null)
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(
                          currentLocation!.latitude,
                          currentLocation!.longitude,
                        ),
                        child: GestureDetector(
                          onTap: () => _showLocationDetails(
                            context,
                            "Your Location",
                            "Latitude: ${currentLocation!.latitude}, Longitude: ${currentLocation!.longitude}",
                          ),
                          child: Icon(Icons.location_on,
                              color: Colors.red, size: 50.0),
                        ),
                      ),

                    // Dynamically generate markers for sellers
                    if (saleslist.isNotEmpty)
                      ...saleslist
                          .map((seller) {
                            double? lat = _parseDouble(seller['lat']);
                            double? long = _parseDouble(seller['long']);

                            if (lat != null && long != null) {
                              return Marker(
                                width: 80.0,
                                height: 80.0,
                                point: LatLng(lat, long),
                                child: GestureDetector(
                                  onTap: () => _showLocationDetails(
                                    context,
                                    "Seller Location",
                                    "Latitude: $lat, Longitude: $long",
                                  ),
                                  child: Icon(Icons.location_on,
                                      color: Colors.blue, size: 50.0),
                                ),
                              );
                            } else {
                              print("Invalid seller location data: $seller");
                              return null;
                            }
                          })
                          .whereType<Marker>()
                          .toList(), // Ensure only valid markers are added
                  ],
                ),

                // Attribution Widget
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () => launchUrl(
                          Uri.parse('https://openstreetmap.org/copyright')),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  // Function to show seller location details in a popup
  void _showLocationDetails(
      BuildContext context, String title, String details) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(details),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Function to safely parse latitude and longitude values
  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        print("Error parsing double: $e");
        return null;
      }
    }
    return null;
  }
}
