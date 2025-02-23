import 'package:firebase_core/firebase_core.dart';
import 'package:fireflutter/providers/userprovider.dart';
import 'package:fireflutter/screens/splashscreen.dart';
import 'package:fireflutter/widgets/locationPicker.dart';
import 'package:fireflutter/widgets/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:fireflutter/firebase_options.dart';
import 'package:fireflutter/screens/dashboard.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: (context) => Userprovider(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Waste2Worth',
      theme: ThemeData(
        fontFamily: "Poppins",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

// class MyHomeScreen extends StatefulWidget {
//   @override
//   _MyHomeScreenState createState() => _MyHomeScreenState();
// }

// class _MyHomeScreenState extends State<MyHomeScreen> {
//   LatLng? _selectedLocation;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             if (_selectedLocation != null)
//               Text(
//                 'Selected Location: ${_selectedLocation?.latitude}, ${_selectedLocation?.longitude}',
//               ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 final result = await Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => LocationPicker(),
//                   ),
//                 );
//                 if (result != null) {
//                   setState(() {
//                     _selectedLocation = result;
//                   });
//                 }
//               },
//               child: Text('Pick Location'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
