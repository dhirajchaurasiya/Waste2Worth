import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireflutter/controllers/login_controllers.dart';
import 'package:fireflutter/providers/userprovider.dart';
import 'package:fireflutter/screens/dashboard.dart';
import 'package:fireflutter/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var userform = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isloading = false;

  Future<void> createaccount() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
      print("Account logged in");

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return DashboardScreen();
        },
      ), (route) {
        return false;
      });
    } catch (e) {
      SnackBar snackbarmessage = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbarmessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    var userinfo = Provider.of<Userprovider>(context);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: userform,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image.asset("assets/images/logo.png", width: 200, height: 200,),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: password,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                      },
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(0, 50),
                              backgroundColor: Colors.green,
                            ),
                              onPressed: () async{
                                if (userform.currentState!.validate()) {
                          
                                  isloading = true;
                                  setState(() {
                                    
                                  });
                                  await LoginController.login(
                                      context: context,
                                      email: email.text,
                                      password: password.text);
                          
                                  isloading = false;
                                  setState(() {
                                    
                                  });
                                }
                                print(userinfo.userName);
                              },
                              child: isloading ? CircularProgressIndicator(
                                color: Colors.white,
                              ) : Text('Login', style: TextStyle(color: Colors.white),)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SignupScreen();
                              },
                            ),
                          );
                        },
                        child: Text("Sign up"),
                      ),
                    ])
                  ],
                ),
              ),
            ),
          ),
        ),
        appBar: AppBar(
          title: const Text("Login"),
        ),
      ),
    );
  }
}