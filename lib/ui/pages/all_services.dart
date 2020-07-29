import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:edatavejapp/ui/models/global.dart';
import 'package:edatavejapp/ui/models/service_model.dart';
import 'package:flutter/material.dart';

class AllServices extends StatefulWidget {
  @override
  _AllServicesState createState() => _AllServicesState();
}

class _AllServicesState extends State<AllServices> {
  List<Service> servicesList = List();
  bool isLoading = false, isError = false;
  @override
  void initState() {
    super.initState();
    isError = false;
    getAllServices();
  }

  getAllServices() async {
    try {
      setState(() => isLoading = true);

      Response response = await dio.get('/api/GetServices',
          options:
              Options(headers: {'Authorization': currentUser.accessToken}));

      if (response.statusCode == 200)
        setState(() => servicesList = (json.decode(response.data) as List)
            .map((data) => Service.fromJson(data))
            .toList());

      setState(() => isLoading = false);
      // print(servicesList[0].id);
      // print(servicesList[0].createdAt);
      // print(servicesList[0].createdBy);
      // print(servicesList[0].imageUrl);
      // print(servicesList[0].modifiedAt);
      // print(servicesList[0].modifiedBy);
      // print(servicesList[0].title);
      // print(servicesList[0].description);
      // print(servicesList[0].transactions);
      // print(servicesList[0].isActive);
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Services'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isError
              ? Center(
                  child: Text('Error Loading Data'),
                )
              : servicesList.length == 0
                  ? Center(child: Text('No Services Available'))
                  : ListView.builder(
                      itemCount: servicesList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(servicesList[index].title),
                            subtitle: Text(servicesList[index].description),
                          ),
                        );
                      },
                    ),
    );
  }
}
