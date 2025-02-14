import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireflutter/screens/edit_profile.dart';
import 'package:fireflutter/screens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/userprovider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
 
    var userprovider = Provider.of<Userprovider>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              child: Text(userprovider.userName[0], style: TextStyle(fontSize: 30),),
              radius: 50,
            ),
            SizedBox(
              height: 10,
            ),
            //displaying the fetched data
            Text(
              userprovider.userName,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            
            TextButton(onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){return SplashScreen();},), (route) => false);
            }, child: Text('Logout')),

            Text(userprovider.userEmail),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EditProfile();
                      },
                    ),
                  );
                },
                child: Text("Edit profile")),

            
          ],
        ),
      ),
    );
  }
}