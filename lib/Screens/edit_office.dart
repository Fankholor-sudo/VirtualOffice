import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:http/http.dart' as http;
import 'package:specno_client/Components/animated_navigation.dart';
import 'package:specno_client/Screens/landing_screen.dart';

class EditOffice extends StatefulWidget {
  final Map<String, dynamic> officeData;
  const EditOffice({super.key, required this.officeData});

  @override
  State<EditOffice> createState() => _EditOfficeState();
}

final _formKey = GlobalKey<FormState>();

class _EditOfficeState extends State<EditOffice> {
  final TextEditingController _officeNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _maxCapacityController = TextEditingController();

  Color? _selectedColor = Colors.orangeAccent;

  void editOffice(
      {officeID,
      officeName,
      address,
      email,
      phoneNumber,
      maxCapacity,
      officeColor}) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/office/update'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'OfficeID': officeID,
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
      throw Exception('Failed to update office.');
    }
  }

  void deleteOffice() async {
    final response = await http.delete(
      Uri.parse(
          'http://10.0.2.2:3000/office/?OfficeID=${widget.officeData['OfficeID']}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body)['message'];
      print('Response: $res');
    } else {
      throw Exception('Failed to delete office.');
    }
  }

  @override
  void initState() {
    super.initState();

    final officeColorValue = widget.officeData['OfficeColor'];
    _selectedColor = Color(int.parse(officeColorValue.substring(0, 10)));

    _officeNameController.text = widget.officeData['OfficeName'];
    _addressController.text = widget.officeData['Address'];
    _emailController.text = widget.officeData['Email'];
    _phoneController.text = widget.officeData['PhoneNumber'];
    _maxCapacityController.text = (widget.officeData['MaxCapacity']).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Edit Office",
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
                    Container(
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
                  // Converting selectedColor to type Color
                  // int colorValue = color.value;
                  // Color newColor = Color(colorValue);

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
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(content: Text("Validated")));
                      editOffice(
                        officeID: widget.officeData['OfficeID'],
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
                      FocusScope.of(context).unfocus();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 87, 182, 250),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'UPDATE OFFICE',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 90),
                child: TextButton(
                  onPressed: () {
                    deleteOffice();
                    Navigator.pushReplacement(
                      context,
                      AnimatedNavigation(
                        page: LandingScreen(),
                      ),
                    );
                    FocusScope.of(context).unfocus();
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'DELETE OFFICE',
                    style: TextStyle(color: Color.fromARGB(255, 87, 182, 250)),
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
