import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireflutter/screens/splashscreen.dart';
import 'package:flutter/material.dart';


class SignupController {
  static Future<void> createaccount({
    required BuildContext context,
    required email,
    required password,
    required name,
    required country,
  }) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print("Account created");

      var userid = FirebaseAuth.instance.currentUser!.uid;

    var db = FirebaseFirestore.instance;

    Map<String, dynamic> userdata = {
      "email": email,
      "name": name,
      "country": country,
      "id":userid.toString(),
    };

    try{
      print('taking data to firebase collection');
          await db.collection("users").doc(userid.toString()).set(userdata);
    }catch(e){
      print('at firebase collection');
      print(e);
    }

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return SplashScreen();
        },
      ), (route) {
        return false;
      });
    } catch (e) {
      SnackBar snackbarmessage = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbarmessage);
    }
  }
}