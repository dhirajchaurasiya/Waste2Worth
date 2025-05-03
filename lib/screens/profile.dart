import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireflutter/providers/userprovider.dart';
import 'package:fireflutter/screens/splashscreen.dart';
import 'package:flutter/material.dart';

import 'package:fireflutter/screens/edit_profile.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SplashScreen()));
  }

  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<Userprovider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.green,
                          Colors.green[200]!,
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          child: Text(userprovider.userName[0]),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${userprovider.userName}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Seller Account',
                              style: TextStyle(
                                color: Colors.grey[100],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              buildSectionTitle('Selling'),
              buildListTile(Icons.mail, '${userprovider.userEmail}'),
              buildListTile(Icons.category, 'CategoriesSelected '),
              buildSectionTitle('Settings'),
              buildListTile(Icons.person, 'My Profile'),
              buildListTile(Icons.settings, 'Logout'),
              buildSectionTitle('Resources'),
              buildListTile(Icons.info, 'About Us'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildListTile(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightGreen[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: GestureDetector(
          onTap: () {
            if (title == 'My Profile') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfile()),
              );
            }
            if (title == 'Logout') {
              logout();
            }
          },
          child: ListTile(
            leading: Icon(icon, color: Colors.black),
            title: Text(
              title,
              style: TextStyle(color: Colors.black),
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
