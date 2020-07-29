import 'package:flutter/material.dart';
import '../models/global.dart';
import '../models/user_model.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isUpdatingData = false,
      _obscureTextOldPassword = true,
      _obscureTextNewPassword = true,
      _obscureTextConfirmNewPassword = true,
      isValidOldPassword = false;
  void _toggleOldPassword() =>
      setState(() => _obscureTextOldPassword = !_obscureTextOldPassword);

  void _toggleNewPassword() =>
      setState(() => _obscureTextNewPassword = !_obscureTextNewPassword);

  void _toggleConfirmNewPassword() => setState(
      () => _obscureTextConfirmNewPassword = !_obscureTextConfirmNewPassword);
  loginCustomer(User user) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Change Password'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Image.asset(
                'assets/icons/password.png',
                height: 200,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: TextFormField(
                  controller: _oldPasswordController,
                  obscureText: _obscureTextOldPassword,
                  decoration: InputDecoration(
                      hintText: "Current Password",
                      labelText: "Current Password",
                      suffixIcon: GestureDetector(
                        onTap: _toggleOldPassword,
                        child: Icon(
                          Icons.remove_red_eye,
                          size: 20.0,
                          color: Colors.black,
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscureTextNewPassword,
                  decoration: InputDecoration(
                      hintText: "New Password",
                      labelText: "New Password",
                      suffixIcon: GestureDetector(
                        onTap: _toggleNewPassword,
                        child: Icon(
                          Icons.remove_red_eye,
                          size: 20.0,
                          color: Colors.black,
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 40),
                child: TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureTextConfirmNewPassword,
                  decoration: InputDecoration(
                      hintText: "Confirm New Password",
                      labelText: "Confirm New Password",
                      suffixIcon: GestureDetector(
                        onTap: _toggleConfirmNewPassword,
                        child: Icon(
                          Icons.remove_red_eye,
                          size: 20.0,
                          color: Colors.black,
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3))),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 20),
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      isUpdatingData = true;
                    });
                  },
                  child: Text(
                    'Forgot Current Password?',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        child: RaisedButton(
          disabledColor: Colors.pink[200],
          elevation: 0,
          child: isUpdatingData
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                )
              : Text('Update Password'),
          onPressed: () async {
            FocusScope.of(context).unfocus();
            if (_oldPasswordController.text == '')
              displaySnackBar('Please Enter Current Password', _scaffoldKey);
            else if (_newPasswordController.text == '')
              displaySnackBar('Please Enter New Password', _scaffoldKey);
            else if (_confirmPasswordController.text == '')
              displaySnackBar('Please Repeate New Password', _scaffoldKey);
            else if (_oldPasswordController.text.length < 8 ||
                _newPasswordController.text.length < 8)
              displaySnackBar(
                  'Password Length Must Be Atleast 8 Characters Long',
                  _scaffoldKey);
            else if (_oldPasswordController.text == _newPasswordController.text)
              displaySnackBar(
                  'Old Password New Password Fields Must Not Be Same',
                  _scaffoldKey);
            else if (_confirmPasswordController.text !=
                _newPasswordController.text)
              displaySnackBar(
                  'New Password And Confirm New Password Fields Must Be Same',
                  _scaffoldKey);
            else {
              setState(() => isUpdatingData = true);
              setState(() => isUpdatingData = false);
            }
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
      ),
    );
  }
}
