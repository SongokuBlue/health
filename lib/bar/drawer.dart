import 'package:flutter/material.dart';
import 'package:health/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health/pages/auth_page.dart';
import 'package:health/pages/profile.dart';
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});
  void SignOut(){
    FirebaseAuth.instance.signOut();
  }
  Widget build(BuildContext context) {
    return Drawer(
      child:ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('User Info',style: TextStyle(color: Colors.white,fontSize: 20),),
          ),
          ListTile(
            title: const Text('Profile',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            onTap: () {
              // Update the state of the app.
              // ...
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          ListTile(
            title: const Text('Log Out',style: TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold),),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Warning", style: TextStyle(fontWeight: FontWeight.bold)),
                  content: Text('Do you want to log out',style: TextStyle(fontSize: 15),),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        SignOut();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const AuthPage()),
                              (Route<dynamic> route) => false,
                        );
                      },
                      child: Text('Log out',style: TextStyle(color: Colors.red),),
                    ),
                  ],
                ),
              );

            },
          ),
        ],
      ),
    );
  }
}

