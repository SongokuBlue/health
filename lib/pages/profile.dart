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
  final User? user = FirebaseAuth.instance.currentUser; // lấy dữ liệu hiện tại của user đó
  DateTime _lastUpdated = DateTime.now();
  bool isEditing = false;

  // Controllers để lưu trữ dữ liệu nhập
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String gender = "Male";

  void initState() {

    super.initState();
    _loadUserData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFEDF3),
      appBar: AppBar(
        title: Row(
          children: [
            const Text("Profile", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            const Icon(LineAwesomeIcons.user_check_solid, color: Colors.blueAccent),
            const Spacer(),
            IconButton(
              icon: Icon(isEditing ? Icons.save : Icons.edit),
                onPressed: () async {
                  if (isEditing) {
                    // Save dữ liệu
                    final userId = user?.uid;
                    if (userId == null) return;

                    final userRef = FirebaseDatabase.instance.ref().child('patients').child(userId);
                    final snapshot = await userRef.get();

                    final dataToSave = {
                      'firstName': firstNameController.text,
                      'lastName': lastNameController.text,
                      'age': int.tryParse(ageController.text) ?? 0,
                      'gender': gender.toLowerCase(), // vì lưu trong database là ko in hoa
                      'phone': phoneController.text,
                      'address': addressController.text,
                      'description': descriptionController.text,
                      'authId': userId,
                    }; //data cần lưu

                    if (snapshot.exists) { //có tồn tại thì update ko thì tạo mới
                      await userRef.update(dataToSave);
                    } else {
                      await userRef.set(dataToSave);
                    }

                    setState(() {
                      _lastUpdated = DateTime.now(); // Cập nhật lại thời gian
                      isEditing = false;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Profile saved successfully!")),
                    );
                  } else {
                    // Bật chế độ chỉnh sửa
                    setState(() {
                      isEditing = true;
                    });
                  }
                }
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Icon(Icons.account_circle, size: 100, color: Colors.grey),
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
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      labelText: "First Name",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(LineAwesomeIcons.user),
                    ),
                    enabled: isEditing,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      labelText: "Last Name",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(LineAwesomeIcons.user),
                    ),
                    enabled: isEditing,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: ageController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: const InputDecoration(
                            labelText: "Age",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(LineAwesomeIcons.heart),
                          ),
                          enabled: isEditing,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: gender,
                          items: const [
                            DropdownMenuItem(value: "Male", child: Text("Male")),
                            DropdownMenuItem(value: "Female", child: Text("Female")),
                          ],
                          onChanged: isEditing
                              ? (value) {
                            setState(() {
                              gender = value!;
                            });
                          }
                              : null,
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
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: "Phone number",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(LineAwesomeIcons.phone_solid),
                    ),
                    enabled: isEditing,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: "Address",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(LineAwesomeIcons.address_card),
                    ),
                    enabled: isEditing,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(LineAwesomeIcons.smile),
                    ),
                    enabled: isEditing,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text("Last updated: ${_lastUpdated.toString()}"),
          ],

        ),
      ),
    );
  }
  Future<void> _loadUserData() async {
    final userId = user?.uid;
    if (userId == null) return;

    final userRef = FirebaseDatabase.instance.ref().child('patients').child(userId);// đi từ database lúc đầu vào sâu hơn
    final snapshot = await userRef.get();
    if (snapshot.exists) { //nếu có tồn tại thì hiện
      final data = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        firstNameController.text = data['firstName'] ?? '';
        lastNameController.text = data['lastName'] ?? '';
        ageController.text = (data['age'] ?? '').toString();
        String rawGender = (data['gender'] ?? 'Male').toString();
        gender = rawGender[0].toUpperCase() + rawGender.substring(1).toLowerCase();
        phoneController.text = data['phone'] ?? '';
        addressController.text = data['address'] ?? '';
        descriptionController.text = data['description'] ?? '';
      });
    }
  }
}
