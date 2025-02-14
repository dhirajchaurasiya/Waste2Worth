import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Userprovider extends ChangeNotifier{
  String userid = '';
  String userName = '';
  String userEmail = '';
  String userToken = '';

  var db = FirebaseFirestore.instance;
  

  void getUserDetails() async{
    var authUser = FirebaseAuth.instance.currentUser;

    

    await db.collection("users").doc(authUser!.uid).get().then((value) {
      userName = value.data()!["name"] ?? "Dummy name";
      userEmail = value.data()!["email"] ?? "Dummy email";
      userid = value.data()!["id"]  ?? "Dummy id";
      notifyListeners();
    });

  }
}