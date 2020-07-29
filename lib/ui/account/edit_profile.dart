import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/global.dart';
import 'change_password.dart';

class EditProfile extends StatefulWidget {
  final Function notifyParent;
  EditProfile({this.notifyParent});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isUpdatingData = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: Image.asset('assets/profile-background.jpg'),
                width: double.infinity,
              ),
              Positioned(
                left: MediaQuery.of(context).size.width * 0.5 - 55,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Material(
                    elevation: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Colors.white, spreadRadius: 4),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          imageUrl: '',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 130, left: 30, right: 30),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      hintText: "Name",
                      labelText: "Full Name",
                      suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() => _nameController.text = '');
                          }),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    enabled: false,
                    style: TextStyle(color: Colors.black45),
                    decoration: InputDecoration(
                        hintText: "Email",
                        labelText: "Email Address",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => ChangePassword()));
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(
                              width: 1, color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(2)),
                      child: Center(
                        child: Text(
                          'Change Password',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
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
              : Text('Save'),
          onPressed: () async {
            FocusScope.of(context).unfocus();
            if (_nameController.text.length < 3) {
              displaySnackBar('Please Enter A Valid Name', _scaffoldKey);
            } else {
              setState(() => isUpdatingData = true);
            }
            setState(() => isUpdatingData = false);
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
      ),
    );
  }
}
