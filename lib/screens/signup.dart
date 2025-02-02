
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireflutter/controllers/singup_controllers.dart';
import 'package:fireflutter/screens/dashboard.dart';
import 'package:flutter/material.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  var userform  = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController country  = TextEditingController();
  TextEditingController name = TextEditingController();

  Future<void> createaccount() async{
    try{
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: password.text);
    

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) {
          return DashboardScreen();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: userform,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.asset('assets/images/logo.png'),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: email,
                  validator: (value) {
                    if (value==null || value.isEmpty) {
                      return "Email is required";
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: password,
                  validator: (value) {
                    if (value==null || value.isEmpty) {
                      return "Password is required";
                    }
                  },
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Password',),
                ),
                
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: name,
                  validator: (value) {
                    if (value==null || value.isEmpty) {
                      return "Name is required";
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Name',),
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: country,
                  validator: (value) {
                    if (value==null || value.isEmpty) {
                      return "country is required";
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Country',),
                ),
                ElevatedButton(onPressed: (){
                  if(userform.currentState!.validate()){
                    SignupController.createaccount(context: context, email: email.text, password: password.text, name: name.text, country: country.text);
                  }
                }, child: Text('Submit'))
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text("Signup"),
      ),
    );
  }
}