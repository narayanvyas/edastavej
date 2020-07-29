import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:edatavejapp/ui/models/global.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

File _image;

class EditService extends StatefulWidget {
  final int serviceId;
  final String serviceName;
  final String serviceDescription;
  final String imageUrl;
  final bool serviceStatus;

  EditService(
      {this.serviceId,
      this.serviceName,
      this.serviceDescription,
      this.imageUrl,
      this.serviceStatus});

  @override
  _EditServiceState createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _editServiceNameController =
      TextEditingController();
  final TextEditingController _editServiceDescriptionController =
      TextEditingController();
  String base64Image;
  bool status = false, isUpdating = false;

  @override
  void initState() {
    super.initState();
    _image = null;
    status = widget.serviceStatus;
    _editServiceNameController.text = widget.serviceName;
    _editServiceDescriptionController.text = widget.serviceDescription;
  }

  Future chooseFile(ImageSource source) async {
    ImagePicker _picker = ImagePicker();
    await _picker
        .getImage(
            imageQuality: 60, source: source, maxWidth: 1000, maxHeight: 1000)
        .then((image) {
      if (image != null) {
        if (this.mounted) {
          setState(() {
            _image = File(image.path);
            base64Image = base64Encode(_image.readAsBytesSync());
          });
        }
        cropImage();
      }
    });
  }

  Future<Null> cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false),
        compressQuality: 50,
        iosUiSettings: IOSUiSettings(
          title: 'Crop Image',
        ));
    if (croppedFile != null) {
      if (this.mounted) {
        setState(() {
          _image = croppedFile;
          base64Image = base64Encode(_image.readAsBytesSync());
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Edit Service'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: _image != null
                    ? Center(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              child: Image.file(
                                _image,
                                fit: BoxFit.fill,
                              ),
                            ),
                            _image != null
                                ? Positioned(
                                    right: 0,
                                    child: RawMaterialButton(
                                      constraints: BoxConstraints.tight(
                                          Size(40.0, 40.0)),
                                      child: Icon(
                                        Icons.cancel,
                                        color: Colors.white,
                                        size: 20.0,
                                      ),
                                      shape: CircleBorder(),
                                      elevation: 20.0,
                                      fillColor: Colors.red,
                                      onPressed: () {
                                        setState(() {
                                          _image = null;
                                        });
                                      },
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          chooseFile(ImageSource.gallery);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 5),
                          child: Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'assets/no-image.png',
                                  height: 100,
                                ),
                              ),
                              Positioned(
                                  right:
                                      MediaQuery.of(context).size.width * .25,
                                  child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      )))
                            ],
                          ),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: TextFormField(
                  controller: _editServiceNameController,
                  decoration: InputDecoration(
                      hintText: 'Service Name',
                      labelText: 'Service Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: TextFormField(
                  controller: _editServiceDescriptionController,
                  decoration: InputDecoration(
                      hintText: 'Service Description',
                      labelText: 'Service Description',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Row(
                  children: <Widget>[
                    Text("Status"),
                    Checkbox(
                      value: status,
                      onChanged: (bool value) {
                        setState(() => status = value);
                      },
                    ),
                  ],
                ),
              ),
              RaisedButton(
                  disabledColor: Colors.pink[400],
                  disabledTextColor: Colors.white,
                  child: isUpdating
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Text('Edit Service'),
                  onPressed: isUpdating
                      ? null
                      : () async {
                          if (_editServiceNameController.text.length < 5)
                            displaySnackBar('Please Enter Valid Service Name',
                                _scaffoldKey);
                          else if (_editServiceDescriptionController
                                  .text.length <
                              5)
                            displaySnackBar(
                                'Please Enter Valid Service Description',
                                _scaffoldKey);
                          else {
                            setState(() => isUpdating = true);
                            DateTime currentTime = DateTime.now();
                            FormData formData = FormData.fromMap({
                              'ServiceName': _editServiceNameController.text,
                              'ServiceDescription':
                                  _editServiceDescriptionController.text,
                              'CreatedAt': currentTime.toString(),
                              'ModifiedAt': currentTime.toString(),
                              'CreatedBy': 1,
                              'ModifiedBy': 1,
                              'IsActive': status,
                              // 'ImageUrl': await MultipartFile.fromFile("./text.txt",
                              //     filename: "upload.txt"),
                            });
                            try {
                              print(widget.serviceId);
                              Response response = await dio.put(
                                "/api/UpdateService",
                                data: {
                                  'ServiceId': widget.serviceId,
                                  'ServiceName':
                                      _editServiceNameController.text,
                                  'ServiceDescription':
                                      _editServiceDescriptionController.text,
                                  'ModifiedAt': currentTime.toString(),
                                  'CreatedBy': 1,
                                  'ModifiedBy': 1,
                                  'IsActive': status,
                                  'ImageUrl': '',
                                  // 'filepath': base64Image,
                                },
                                options: Options(headers: {
                                  'Authorization': currentUser.accessToken,
                                }),
                                onSendProgress: (int sent, int total) {
                                  print("$sent $total");
                                },
                              );
                              if (response.statusCode == 200)
                                displaySnackBar('Service Updating Successfully',
                                    _scaffoldKey);
                              else
                                displaySnackBar(
                                    'Error Updating Service', _scaffoldKey);
                              setState(() => isUpdating = false);
                            } catch (e) {
                              print(e);
                              setState(() => isUpdating = false);
                            }
                          }
                        })
            ],
          ),
        ),
      ),
    );
  }
}
