import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireflutter/providers/userprovider.dart';
import 'package:fireflutter/screens/dashboard.dart';
import 'package:fireflutter/screens/login.dart';
import 'package:fireflutter/screens/login.dart';
import 'package:fireflutter/widgets/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  var user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // Check for login status
    Future.delayed(const Duration(seconds: 2), () {

      if(user == null) {

      openLogin();
    } else {

      openDashboard();
    }
    }
    
    );

    super.initState();
  }

// PushReplacement won't allow to get back to the previous screen while using appbar
  void openDashboard() {

    Provider.of<Userprovider>(context, listen: false).getUserDetails();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return HomeScreen();
        },
      ),
    );
  }

  void openLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LoginScreen();
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo.png', width: 200, height: 200,),

      ),
    );
  }
}