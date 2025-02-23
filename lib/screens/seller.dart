import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fireflutter/providers/userprovider.dart';
import 'package:fireflutter/widgets/locationPicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:fireflutter/models/sellmodels.dart';
import 'package:fireflutter/screens/sellers_screen.dart';
import 'package:provider/provider.dart';

class BuyerSellerScreen extends StatefulWidget {
  @override
  _BuyerSellerScreenState createState() => _BuyerSellerScreenState();
}

class _BuyerSellerScreenState extends State<BuyerSellerScreen> {
  LatLng? _selectedLocation;

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

  // Fetch the current location of the user

  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<Userprovider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Sell Compost Manure',
          style: TextStyle(color: Colors.white),
        ),
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

            const SizedBox(height: 16),

            // Phone Number Input
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(
              height: 16,
            ),
            if (_selectedLocation != null)
              Container(
                color: Colors.green[200],
                height: 50,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Selected Location: ${_selectedLocation?.latitude}, ${_selectedLocation?.longitude}',
                    ),
                  ),
                ),
              ),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(0, 50),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocationPicker(),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        _selectedLocation = result;
                      });
                    }
                  },
                  child: Text(
                    'Pick Location',
                  ),
                ),
                SizedBox(width: 24),

                // Submit Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(0, 50),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    if (_weightController.text.isEmpty ||
                        _selectedLocation == null ||
                        _phoneController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please fill in all fields!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      return;
                    }

                    /// create new object of model (making sure kun field ma kasto value janxa - controller le dekhayejsto)
                    final newsale = sellmodel(
                        id: DateTime.now().toString(),
                        weight: _weightController.text,
                        lat: _selectedLocation!.latitude,
                        long: _selectedLocation!.longitude,
                        email: userprovider.userEmail,
                        name: userprovider.userName,
                        phonenumber: _phoneController.text);

                    //add data to the firebase
                    await FirebaseFirestore.instance
                        .collection('salesdetails')
                        .add(newsale.toJson());

                    print('Weight: ${_weightController.text} kg');
                    print('Address: ${_addressController.text}');
                    print('Location: ${_selectedLocation}');
                    print('Phone: ${_phoneController.text}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                            'Your details have been submitted.',
                            style: TextStyle(color: Colors.white),
                          )),
                    );

                    FirebaseFirestore.instance.collection('salesdetails').get();

                    //clearing the textfields
                    _weightController.clear();
                    _selectedLocation = null;
                    setState(() {});
                    // _addressController.clear();
                    _phoneController.clear();
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),

            const SizedBox(height: 32),

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
                      MaterialPageRoute(builder: (context) => SellerMap()),
                    );
                    print('Icon btn to see full screen location pressed');
                  },
                  icon: const Icon(Icons.arrow_right),
                  iconSize: 30,
                )
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

//zoom in the map
