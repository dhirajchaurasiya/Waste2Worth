import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireflutter/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart';

class SellerMap extends StatefulWidget {
  const SellerMap({super.key});

  @override
  State<SellerMap> createState() => _SellerMapState();
}

class _SellerMapState extends State<SellerMap> {
  String? name;
  String? output;
  Position? _currentPosition; // User's current location
  bool _isLoading = true; // Loading state
  var db = FirebaseFirestore.instance;
  MapController mapController = MapController();
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

        print("Sales list: $tempSalesList");
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
      // mapController.move(LatLng(position.latitude, position.longitude), 13.0);

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
              mapController: mapController,
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
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.125,
                  right: MediaQuery.of(context).size.width * 0.05,
                  child: FloatingActionButton(
                    onPressed: () {
                      Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high,
                      ).then((value) {
                        setState(() {
                          currentLocation = value;
                        });
                        mapController.move(
                            LatLng(currentLocation!.latitude,
                                currentLocation!.longitude),
                            17.0);
                      });
                      print("object");
                    },
                    child: Icon(Icons.my_location),
                  ),
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
                          onTap: () async {
                            final placemarks = await placemarkFromCoordinates(
                                currentLocation!.latitude,
                                currentLocation!.longitude);
                            String resolvedAddress = placemarks.isNotEmpty
                                ? "${placemarks.first.street}, ${placemarks.first.locality}, "
                                : "Address not found";

                            print("My location: $resolvedAddress");
                            showAboutDialog(context: context, children: [
                              Text("My location: $resolvedAddress"),
                            ]);
                          },
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
                            String? name = seller['name'];
                            String? phonenumber = seller['phonenumber'];
                            String? address = seller['address'];

                            if (lat != null && long != null) {
                              return Marker(
                                width: 80.0,
                                height: 80.0,
                                point: LatLng(lat, long),
                                child: GestureDetector(
                                  onTap: () {
                                    _showLocationDetails(context, seller);
                                    // _sendprofiledetails(
                                    //     context, name, phonenumber);

                                    // print("passed name to view profile: $name");
                                    // viewProfile(name: name);
                                  },
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
  _showLocationDetails(
    BuildContext context,
    Map<String, dynamic> sellerData,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Seller Details"),
          content: Text("Name: ${sellerData['name']}\n"
              "Phone: ${sellerData['phonenumber']}\n"
              "Location: ${sellerData['lat']}, ${sellerData['long']}"
              "Address: ${sellerData['address']}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); //close the alert dialog first
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewProfile(sellerData: sellerData),
                  ),
                );
              },
              child: Text('View Profile'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // _sendprofiledetails(
  //   BuildContext context,
  //   String? name,
  // ) {
  //   return viewProfile(
  //     name: name,
  //   );
  // }

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

class ViewProfile extends StatelessWidget {
  final Map<String, dynamic> sellerData;

  const ViewProfile({super.key, required this.sellerData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('View Profile')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.green,
                  )),
              Container(
                height: 80,
                width: double.infinity,
                child: Center(
                  child: Text(
                    sellerData['name'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(children: [
              Text('Name: ${sellerData['name']}',
                  style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Phone: ${sellerData['phonenumber']}'),
              const SizedBox(height: 8),
              Text('Location: ${sellerData['lat']}, ${sellerData['long']}'),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.call),
                label: Text('Call Seller'),
                onPressed: () {
                  launchUrl(Uri.parse('tel:${sellerData['phonenumber']}'));
                },
              ),
              ListTile(
                  leading: Icon(Icons.email),
                  title: Text('Email'),
                  subtitle: Text(sellerData['email']),
                  onTap: () {
                    launchUrl(Uri.parse('mailto:${sellerData['email']}'));
                  })
            ]),
          ),
        ],
      ),
    );
  }
}
