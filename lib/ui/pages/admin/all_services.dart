import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import '../../models/global.dart';
import '../../models/service_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'add_service.dart';
import 'edit_service.dart';

class AllServices extends StatefulWidget {
  @override
  _AllServicesState createState() => _AllServicesState();
}

class _AllServicesState extends State<AllServices> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Service> servicesList = List();
  bool isLoading = false, isError = false, isUpdating = false;
  @override
  void initState() {
    super.initState();
    isError = false;
    isUpdating = false;
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

  deleteService(BuildContext context, int id) async {
    bool isLoading = false;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return SimpleDialog(
            title: Text("Delete Service"),
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(left: 24.0, right: 24.0, top: 15),
                child: Text("Are you sure you want to the Service?"),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 24.0, left: 24, right: 24, bottom: 10),
                child: Row(
                  children: <Widget>[
                    RaisedButton(
                      disabledColor: Colors.pink[500],
                      disabledTextColor: Colors.white,
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              Navigator.of(context).pop();
                            },
                    ),
                    Spacer(),
                    RaisedButton(
                      disabledColor: Colors.pink[500],
                      disabledTextColor: Colors.white,
                      child: isLoading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                          : Text(
                              "Ok",
                              style: TextStyle(color: Colors.white),
                            ),
                      onPressed: isLoading
                          ? null
                          : () async {
                              setStateDialog(() => isLoading = true);
                              try {
                                Response response = await dio.delete(
                                  '/api/DeleteService?serviceId=$id',
                                  options: Options(
                                    headers: {
                                      'Authorization': currentUser.accessToken,
                                    },
                                  ),
                                );
                                print(response.statusCode);
                                if (response.statusCode == 200) {
                                  displaySnackBar(
                                      'Service Deleted Successfully',
                                      _scaffoldKey);
                                  await getAllServices();
                                  Navigator.of(context).pop();
                                } else
                                  displaySnackBar(
                                      'Error Deleting Service', _scaffoldKey);
                                setState(() => isUpdating = false);
                              } catch (e) {
                                print(e);
                                Navigator.of(context).pop();
                                displaySnackBar(
                                    'Error Deleting Service', _scaffoldKey);
                                setState(() => isUpdating = false);
                              }
                              setStateDialog(() => isLoading = false);
                            },
                    ),
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Card(
                            child: ListTile(
                              title: Column(
                                children: <Widget>[
                                  servicesList[index].imageUrl == null ||
                                          servicesList[index].imageUrl == '' ||
                                          servicesList[index].imageUrl ==
                                              '/1/' ||
                                          servicesList[index].imageUrl == '/4/'
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Image.asset(
                                            'assets/no-image.png',
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                servicesList[index].imageUrl,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.35,
                                                    child:
                                                        ProfilePageShimmer()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                150,
                                            child: Text(
                                                servicesList[index].title)),
                                        Spacer(),
                                        RawMaterialButton(
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 20.0,
                                          ),
                                          shape: CircleBorder(),
                                          elevation: 2.0,
                                          fillColor: Colors.orange,
                                          constraints: BoxConstraints.tight(
                                              Size(40.0, 40.0)),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        EditService(
                                                          serviceId:
                                                              servicesList[
                                                                      index]
                                                                  .id,
                                                          serviceName:
                                                              servicesList[
                                                                      index]
                                                                  .title,
                                                          serviceDescription:
                                                              servicesList[
                                                                      index]
                                                                  .description,
                                                          serviceStatus:
                                                              servicesList[
                                                                      index]
                                                                  .isActive,
                                                        )));
                                          },
                                        ),
                                        RawMaterialButton(
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 20.0,
                                          ),
                                          shape: CircleBorder(),
                                          elevation: 2.0,
                                          fillColor: Colors.red,
                                          constraints: BoxConstraints.tight(
                                              Size(40.0, 40.0)),
                                          onPressed: () async {
                                            await deleteService(context,
                                                servicesList[index].id);
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(servicesList[index].description),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(servicesList[index].createdAt ??
                                            ''),
                                        !servicesList[index].isActive ||
                                                servicesList[index].isActive ==
                                                    null
                                            ? Container()
                                            : Icon(
                                                Icons.check,
                                                color: Colors.green,
                                              )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => AddService()));
          }),
    );
  }
}
