import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class LocationPicker extends StatefulWidget {
  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  LatLng _pickedLocation = LatLng(27.7172, 85.3240); // Default to Kathmandu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick a Location'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _pickedLocation,
          initialZoom: 13.0,
          onTap: (tapPosition, point) {
            setState(() {
              _pickedLocation = point;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.fireflutter',
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: _pickedLocation,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 48.0,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, _pickedLocation);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
