import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
  final DatabaseReference sensorRef =
      FirebaseDatabase.instance.ref().child('sensorData/current');
  Map<String, dynamic> lastData = {};

  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<Userprovider>(context);

    return Scaffold(
      
      body: StreamBuilder<DatabaseEvent>(
        stream: sensorRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('❌ Error loading data.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting &&
              lastData.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data?.snapshot.value as Map? ?? lastData;
          if (data.isNotEmpty) lastData = Map<String, dynamic>.from(data);

          final temperature = data['temperature']?.toStringAsFixed(1) ?? '--';
          final humidity = data['humidity']?.toStringAsFixed(1) ?? '--';
          final ph = data['ph']?.toStringAsFixed(1) ?? '--';
          final co2 = data['co2']?.toStringAsFixed(1);
          final nh3 = data['nh3']?.toStringAsFixed(1);
          final gasLevel = (co2 != null || nh3 != null)
              ? 'CO₂: ${co2 ?? '--'}, NH₃: ${nh3 ?? '--'}'
              : 'Low';

          return RefreshIndicator(
            onRefresh: () async {
              final snapshot = await sensorRef.get();
              if (snapshot.exists) {
                setState(
                    () {}); // triggers a rebuild, StreamBuilder will auto update
              }
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Welcome ${userprovider.userName}!'),
                  SizedBox(height: 8),
                  Text(
                    'Current Compost Status',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AnimatedSensorWidget(
                        title: 'Temperature',
                        value: '$temperature °C',
                        icon: Icons.thermostat,
                        color: Colors.orange,
                      ),
                      AnimatedSensorWidget(
                        title: 'Humidity',
                        value: '$humidity %',
                        icon: Icons.water_drop,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AnimatedSensorWidget(
                        title: 'pH Level',
                        value: ph,
                        icon: Icons.science,
                        color: Colors.green,
                      ),
                      AnimatedSensorWidget(
                        title: 'Gas Levels',
                        value: gasLevel,
                        icon: Icons.cloud,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.lightGreen[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Composting Tips',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[900])),
                        SizedBox(height: 8),
                        Text(
                            '1. Maintain temperature between 35-50°C for optimal decomposition.'),
                        Text('2. Ensure humidity stays between 40-60%.'),
                        Text(
                            '3. Regularly mix the compost to keep it aerated.'),
                        Text(
                            '4. Add a thin membrane of soil daily to prevent odor.'),
                        Text(
                            '5. Include dry leaves or sawdust for proper carbon-to-nitrogen balance.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
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
// }

class AnimatedSensorWidget extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const AnimatedSensorWidget({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  State<AnimatedSensorWidget> createState() => _AnimatedSensorWidgetState();
}

class _AnimatedSensorWidgetState extends State<AnimatedSensorWidget> {
  String? oldValue;
  bool animate = false;

  @override
  void didUpdateWidget(covariant AnimatedSensorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      animate = true;
      Future.delayed(Duration(milliseconds: 800), () {
        if (mounted) setState(() => animate = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: animate
                ? widget.color.withOpacity(0.6)
                : Colors.grey.withOpacity(0.3),
            spreadRadius: animate ? 4 : 2,
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, color: widget.color, size: 40),
          SizedBox(height: 8),
          Text(
            widget.title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            widget.value,
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
