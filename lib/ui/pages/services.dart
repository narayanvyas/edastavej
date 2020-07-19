import '../models/global.dart';
import 'package:flutter/material.dart';
import 'package:strings/strings.dart';

var _value;
List<String> weekIdList = List();

class Services extends StatefulWidget {
  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  final TextEditingController _nameController =
      TextEditingController(text: name == null ? "" : name);
  @override
  void initState() {
    super.initState();
    weekIdList.add('Jan Aadhar');
    weekIdList.add('Finance');
    weekIdList.add('Khaata Book');
    weekIdList.add('Loan');
    weekIdList.add('Medical');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply Services'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 40.0),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      hintText: "Name",
                      labelText: "Name",
                      prefixIcon: Icon(
                        Icons.near_me,
                        color: Theme.of(context).primaryColor,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          _nameController.text = "";
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.0))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      labelText: "Choose Service",
                      prefixIcon: Icon(
                        Icons.list,
                        color: Theme.of(context).primaryColor,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.0))),
                  items: weekIdList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(camelize(value.replaceAll('-', ' '))),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _value = value;
                    });
                  },
                  value: _value,
                ),
              ),
              RaisedButton(child: Text('Apply Now'), onPressed: () {})
            ],
          ),
        ),
      ),
    );
  }
}
