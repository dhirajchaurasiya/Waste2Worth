import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireflutter/screens/splashscreen.dart';
import 'package:flutter/material.dart';


class LoginController {

  static Future<void> login( {required BuildContext context,required email, required password}) async{
    try{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    print("Account logged in");

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) {
          return SplashScreen();
        },
      ),(route){
        return false;   
      }
    );
    }
    catch(e){
      SnackBar snackbarmessage = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbarmessage);  
    }
  }
}