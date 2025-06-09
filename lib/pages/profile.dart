import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:line_awesome_flutter/line_awesome_flutter.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile",style:Theme.of(context).textTheme.headlineSmall ,),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Icon(
              Icons.account_circle,
              size: 120,
              color: Colors.grey,
            ),
            const SizedBox(height: 10,),
            Text(
              "Email: ${user?.email ?? 'Not available'}",
              style: const TextStyle(fontSize: 18),
            ),
            const Divider(),
            const SizedBox(height: 50,),
            Form(child: Column(
              children: [
                TextFormField(
                  // decoration: const InputDecoration(labelText: "First Name",border: OutlineInputBorder(),prefixIcon: Icon(LineAwesomeIcons.line)),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
