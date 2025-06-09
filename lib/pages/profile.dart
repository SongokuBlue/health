import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';

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
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Icon(Icons.account_circle, size: 100, color: Colors.grey),
            const SizedBox(height: 10),
            Text(
              "Email: ${user?.email ?? 'Not available'}",
              style: const TextStyle(fontSize: 18),
            ),
            const Divider(),
            const SizedBox(height: 20),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "First Name",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(LineAwesomeIcons.user),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Last Name",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(LineAwesomeIcons.user),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly,],
                          decoration: const InputDecoration(
                            labelText: "Age", border: OutlineInputBorder(), prefixIcon: Icon(LineAwesomeIcons.heart),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16), // Khoảng cách giữa hai ô nhập
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: "Male", // mặc định
                          items: const [
                            DropdownMenuItem(value: "Male", child: Text("Male")),
                            DropdownMenuItem(value: "Female", child: Text("Female")),
                          ],
                          onChanged: (value) {
                            // Gán giá trị cho biến trạng thái nếu cần
                            print("Gender selected: $value");
                          },
                          decoration: const InputDecoration(
                            labelText: "Gender",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(LineAwesomeIcons.venus_mars_solid),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                   TextFormField(
                    keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly,], decoration: const InputDecoration(labelText: "Phone number", border: OutlineInputBorder(), prefixIcon: Icon(LineAwesomeIcons.phone_solid),),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Address",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(LineAwesomeIcons.address_card),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(LineAwesomeIcons.smile),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
