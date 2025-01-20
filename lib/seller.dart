import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fireflutter/sellers_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fireflutter/models/sellmodels.dart';

class BuyerSellerScreen extends StatefulWidget {
  @override
  _BuyerSellerScreenState createState() => _BuyerSellerScreenState();
}

class _BuyerSellerScreenState extends State<BuyerSellerScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Markers for Sellers
  final List<Marker> _markers = [
    const Marker(
      point: LatLng(51.509364, -0.128928), // Example: Kathmandu
      child: Icon(
        Icons.location_pin,
        color: Colors.red,
        size: 40,
      ),
    ),
    const Marker(
      point: LatLng(51.51452, -0.128928), // Another location
      child: Icon(
        Icons.location_pin,
        color: Colors.red,
        size: 40,
      ),
    ),
  ];

  @override
  void dispose() {
    _weightController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text('Sell Compost Manure'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form Header
            Text(
              'Fill the details below to sell your compost manure.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Weight Input
            TextField(
              controller: _weightController,
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.scale),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),

            // Address Input
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 16),

            // Phone Number Input
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 24),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (_weightController.text.isEmpty ||
                      _addressController.text.isEmpty ||
                      _phoneController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill in all fields!')),
                    );
                    return;
                  }

                  /// create new object of model (making sure kun field ma kasto value janxa - controller le dekhayejsto)
                  final newsale = sellmodel(
                      id: DateTime.now().toString(),
                      weight: _weightController.text,
                      address: _addressController.text,
                      phonenumber: _phoneController.text);
                  
                  //add data to the firebase
                  await FirebaseFirestore.instance
                      .collection('salesdetails')
                      .add(newsale.toJson());

                  print('Weight: ${_weightController.text} kg');
                  print('Address: ${_addressController.text}');
                  print('Phone: ${_phoneController.text}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Your details have been submitted.')),
                  );
                  
                  //clearing the textfields
                  _weightController.clear();
                  _addressController.clear();
                  _phoneController.clear();
                },
                child: Text('Submit'),
              ),
            ),
            SizedBox(height: 32),

            // Map Header
            Row(
              children: [
                const Text(
                  'Nearby Compost Sellers:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SellerMap()));
                    print('Icon btn to see full screen location pressed');
                  },
                  icon: const Icon(Icons.arrow_right),
                  iconSize: 30,
                )
              ],
            ),
            const SizedBox(height: 16),

            // OpenStreetMap Integration
            Container(
              height: 300,
              child: FlutterMap(
                options: const MapOptions(
                  initialCenter: LatLng(
                      51.509364, -0.128928), // Center the map over London
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
                  MarkerLayer(markers: _markers),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
