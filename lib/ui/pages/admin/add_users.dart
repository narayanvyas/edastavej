import '../../models/global.dart';
import 'package:flutter/material.dart';

class AddUsers extends StatefulWidget {
  @override
  _AddUsersState createState() => _AddUsersState();
}

class _AddUsersState extends State<AddUsers> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _panNumberController = TextEditingController();
  final TextEditingController _aadharNumberController = TextEditingController();
  List<String> rolesList = [
    'Admin',
    'Customer',
    'Telecaller',
    'City Admin',
    'Employee'
  ];
  String _currentlySelectedRole;
  bool status = false;

  void initState() {
    super.initState();
    status = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Add Users'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0, top: 30),
              child: TextFormField(
                controller: _firstNameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                    hintText: 'First Name',
                    labelText: 'First Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: TextFormField(
                controller: _lastNameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                    hintText: 'Last Name',
                    labelText: 'Last Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: 'Email',
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: TextFormField(
                controller: _passwordController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                    hintText: 'Password',
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    hintText: 'Phone',
                    labelText: 'Phone',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: TextFormField(
                controller: _aadharNumberController,
                keyboardType: TextInputType.number,
                maxLength: 12,
                decoration: InputDecoration(
                    hintText: 'Aadhar Number',
                    labelText: 'Aadhar Number',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: TextFormField(
                controller: _panNumberController,
                textCapitalization: TextCapitalization.words,
                onChanged: (value) {
                  _panNumberController.text =
                      _panNumberController.text.toUpperCase();
                },
                maxLength: 10,
                decoration: InputDecoration(
                    hintText: 'PAN Number',
                    labelText: 'PAN Number',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                    labelText: "Role",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3.0))),
                items: rolesList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.replaceAll('-', ' ')),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _currentlySelectedRole = value;
                  });
                },
                value: _currentlySelectedRole,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                children: <Widget>[
                  Text('Status'),
                  Checkbox(
                    value: status,
                    onChanged: (bool value) {
                      setState(() => status = value);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: RaisedButton(
                  child: Text('Add User'),
                  onPressed: () {
                    if (_firstNameController.text.length < 2)
                      displaySnackBar(
                          'Please Enter Valid First Name', _scaffoldKey);
                    else if (_lastNameController.text.length < 2)
                      displaySnackBar(
                          'Please Enter Valid Last Name', _scaffoldKey);
                    else if (!regex.hasMatch(_emailController.text))
                      displaySnackBar(
                          "Please Enter Valid Email ID", _scaffoldKey);
                    else if (_passwordController.text.length < 8)
                      displaySnackBar(
                          'Password Length must be of minimum 8 characters',
                          _scaffoldKey);
                    else if (_phoneController.text.length != 10)
                      displaySnackBar(
                          'Please Enter Valid Phone Number', _scaffoldKey);
                    else if (_aadharNumberController.text.length != 12)
                      displaySnackBar(
                          'Please Enter Valid Aadhar Number', _scaffoldKey);
                    else if (_phoneController.text.length != 10)
                      displaySnackBar(
                          'Please Enter Valid PAN Card Number', _scaffoldKey);
                    else if (_currentlySelectedRole == null)
                      displaySnackBar(
                          'Please Select Valid User Role', _scaffoldKey);
                    else {
                      print('Now execute your actual logic for adding users');
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
