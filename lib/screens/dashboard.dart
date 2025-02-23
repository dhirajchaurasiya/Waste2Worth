import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireflutter/providers/userprovider.dart';
import 'package:fireflutter/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:fireflutter/screens/seller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart'; // Import the BuyerSellerInterface screen

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Position? _currentPosition;

  var user = FirebaseAuth.instance.currentUser;
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<Userprovider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Header
              Text('Welcome ${userprovider.userName}!'),
              Text(
                'Current Compost Status',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),

              // Sensor Data Widgets
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SensorWidget(
                    title: 'Temperature',
                    value: '35°C',
                    icon: Icons.thermostat,
                    color: Colors.orange,
                  ),
                  SensorWidget(
                    title: 'Humidity',
                    value: '55%',
                    icon: Icons.water_drop,
                    color: Colors.blue,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SensorWidget(
                    title: 'pH Level',
                    value: '6.8',
                    icon: Icons.science,
                    color: Colors.green,
                  ),
                  SensorWidget(
                    title: 'Gas Levels',
                    value: 'Low',
                    icon: Icons.cloud,
                    color: Colors.grey,
                  ),
                ],
              ),

              SizedBox(height: 32),

              // Tips Container
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.lightGreen[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Composting Tips',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                        '1. Maintain temperature between 35-50°C for optimal decomposition.'),
                    Text('2. Ensure humidity stays between 40-60%.'),
                    Text('3. Regularly mix the compost to keep it aerated.'),
                    Text(
                        '4. Add a thin membrane of soil daily to prevent odor.'),
                    Text(
                        '5. Include dry leaves or sawdust for proper carbon-to-nitrogen balance.'),
                  ],
                ),
              ),
              // Center(
              //   child: ElevatedButton(
              //     onPressed: () {
              //       // Navigator.push(
              //       //   context,
              //       //   MaterialPageRoute(builder: (context) => SellerScreen()),
              //       // );
              //       print("Sell Compost Manure");
              //     },
              //     child: Text('Sell Compost Manure'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
  // _getCurrentLocation() {
  //   Geolocator
  //     .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
  //     .then((Position position) {
  //       setState(() {
  //         _currentPosition = position;
  //         print(_currentPosition);
  //       });
  //     }).catchError((e) {
  //       print(e);
  //     });
  // }
}

class SensorWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  SensorWidget({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 40),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}

class BuyerMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compost Sellers Map'),
        centerTitle: true,
      ),
      body: Center(
        child: Stack(
          children: [
            Image.network(
              'https://www.mapz.com/stadtplan/image/kathmandu_multicolor.png',
              height: double.infinity,
              width: double.infinity,
            ),
            Positioned(
              top: 150,
              left: 100,
              child: IconButton(
                icon: Icon(Icons.location_pin, color: Colors.red, size: 40),
                onPressed: () {
                  _showSellerDetails(context, 'Seller 1',
                      'Location: Area A\nPhone: 1234567890');
                },
              ),
            ),
            Positioned(
              top: 300,
              left: 200,
              child: IconButton(
                icon: Icon(Icons.location_pin, color: Colors.red, size: 40),
                onPressed: () {
                  _showSellerDetails(context, 'Seller 2',
                      'Location: Area B\nPhone: 0987654321');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSellerDetails(
      BuildContext context, String sellerName, String details) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(sellerName),
          content: Text(details),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
