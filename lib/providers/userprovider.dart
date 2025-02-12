import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Userprovider extends ChangeNotifier{
  String? uid;
  String? email;

  void getUserDetails(){
    uid = FirebaseAuth.instance.currentUser!.uid;
    email = FirebaseAuth.instance.currentUser!.email;
    notifyListeners();
  }
}