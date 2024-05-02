import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:http/http.dart' as http;
import 'package:specno_client/Components/animated_navigation.dart';
import 'package:specno_client/Screens/landing_screen.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final url = dotenv.env['LOCAL_URL'];

class AddOffice extends StatefulWidget {
  const AddOffice({super.key});

  @override
  State<AddOffice> createState() => _AddOfficeState();
}

final _formKey = GlobalKey<FormState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _AddOfficeState extends State<AddOffice> {
  final TextEditingController _officeNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _maxCapacityController = TextEditingController();
  Color? _selectedColor = Colors.orangeAccent;

  void createOffice(
      {officeName,
      address,
      email,
      phoneNumber,
      maxCapacity,
      officeColor}) async {
    const uuid = Uuid();
    //10.0.2.2
    final response = await http.post(
      Uri.parse('$url/office'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'OfficeID': uuid.v1().toString(),
        'OfficeName': officeName,
        'PhoneNumber': phoneNumber,
        'MaxCapacity': maxCapacity.toString(),
        'OfficeColor': officeColor,
        'Address': address,
        'Email': email,
      }),
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body)['data'];
      print('Response: $res');
    } else {
      throw Exception('Failed to create new office.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "New Office",
          style: TextStyle(
            color: Color(0xFF000000),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        controller: _officeNameController,
                        decoration: InputDecoration(
                          labelText: 'Office Name',
                          hintText: 'Office Name',
                          labelStyle: TextStyle(color: Colors.grey),
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Color(0xFFFFFFFF),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Office name is required.';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Physical Address',
                          hintText: 'Physical Address',
                          labelStyle: TextStyle(color: Colors.grey),
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Color(0xFFFFFFFF),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Physical address is required.';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          hintText: 'Email Address',
                          labelStyle: TextStyle(color: Colors.grey),
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Color(0xFFFFFFFF),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email address is required.';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          hintText: 'Phone Number',
                          labelStyle: TextStyle(color: Colors.grey),
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Color(0xFFFFFFFF),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone number is required.';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        controller: _maxCapacityController,
                        decoration: InputDecoration(
                          labelText: 'Maximum Capacity',
                          hintText: 'Maximum Capacity',
                          labelStyle: TextStyle(color: Colors.grey),
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Color(0xFFFFFFFF),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Maximum capacity is required.';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 25),
              child: Text(
                "Office Colour",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: MaterialColorPicker(
                onColorChange: (Color color) {
                  _selectedColor = color;
                },
                circleSize: 40,
                spacing: 20,
                alignment: WrapAlignment.center,
                selectedColor: _selectedColor,
                colors: const [
                  Colors.orangeAccent,
                  Colors.redAccent,
                  Colors.red,
                  Colors.brown,
                  Colors.purpleAccent,
                  Colors.pink,
                  Colors.greenAccent,
                  Colors.green,
                  Colors.lightBlueAccent,
                  Colors.blue,
                  Colors.purple,
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Container(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 90),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      createOffice(
                        officeName: _officeNameController.text,
                        address: _addressController.text,
                        email: _emailController.text,
                        phoneNumber: _phoneController.text,
                        maxCapacity: _maxCapacityController.text,
                        officeColor: _selectedColor!.value,
                      );
                      Navigator.pushReplacement(
                        context,
                        AnimatedNavigation(
                          page: LandingScreen(),
                        ),
                      );
                    }
                    FocusScope.of(context).unfocus();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 87, 182, 250),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'ADD OFFICE',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
