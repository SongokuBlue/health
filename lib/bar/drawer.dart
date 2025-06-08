import 'package:flutter/material.dart';
import 'package:health/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health/pages/auth_page.dart';
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
            child: Text('account'),
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              // Update the state of the app.
              // ...
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Log Out'),
            onTap: () {
              SignOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const AuthPage()),
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

