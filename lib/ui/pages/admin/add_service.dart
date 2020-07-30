import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../../models/global.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

File _image;

class AddService extends StatefulWidget {
  @override
  _AddServiceState createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _serviceDescriptionController =
      TextEditingController();
  String base64Image;
  bool status = false, isUpdating = false;

  @override
  void initState() {
    super.initState();
    _image = null;
    status = false;
  }

  Future chooseFile(ImageSource source) async {
    ImagePicker _picker = ImagePicker();
    await _picker
        .getImage(
            imageQuality: 60, source: source, maxWidth: 1000, maxHeight: 1000)
        .then((image) async {
      if (image != null) {
        if (this.mounted) {
          setState(() {
            _image = File(image.path);
            base64Image = base64Encode(_image.readAsBytesSync());
          });
        }
        print('dwd');
        final Directory directory = await getApplicationDocumentsDirectory();
        print(directory.path);
        String path = directory.path.replaceAll('/app_flutter', '');
        final File file = File('$path/files/filepath');
        await file.writeAsString('base64Image');
        print(file.path);
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
        title: Text('Add Service'),
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
                  controller: _serviceNameController,
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
                  controller: _serviceDescriptionController,
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
                      : Text('Add Service'),
                  onPressed: isUpdating
                      ? null
                      : () async {
                          if (_serviceNameController.text.length < 5)
                            displaySnackBar('Please Enter Valid Service Name',
                                _scaffoldKey);
                          else if (_serviceDescriptionController.text.length <
                              5)
                            displaySnackBar(
                                'Please Enter Valid Service Description',
                                _scaffoldKey);
                          else {
                            setState(() => isUpdating = true);
                            DateTime currentTime = DateTime.now();
                            FormData formData = FormData.fromMap({
                              'ServiceName': _serviceNameController.text,
                              'ServiceDescription':
                                  _serviceDescriptionController.text,
                              'CreatedAt': currentTime.toString(),
                              'ModifiedAt': currentTime.toString(),
                              'CreatedBy': 1,
                              'ModifiedBy': 1,
                              'IsActive': status,
                              // 'ImageUrl': base64Image
                              // 'ImageUrl': await MultipartFile.fromFile("./text.txt",
                              //     filename: "upload.txt"),
                            });
                            try {
                              final Directory directory =
                                  await getApplicationDocumentsDirectory();
                              final File file =
                                  File('${directory.path}/filepath.txt');
                              await file.writeAsString('base64Image');
                              print(file.path);
                              Response response = await dio.post(
                                "/api/AddService",
                                data: {
                                  'ServiceName': _serviceNameController.text,
                                  'ServiceDescription':
                                      _serviceDescriptionController.text,
                                  'CreatedAt': currentTime.toString(),
                                  'ModifiedAt': currentTime.toString(),
                                  'CreatedBy': 1,
                                  'ModifiedBy': 1,
                                  'IsActive': status,
                                  'ImageUrl': '',
                                  'filepath': base64Image,
                                },
                                options: Options(headers: {
                                  'Authorization': currentUser.accessToken,
                                }),
                                onSendProgress: (int sent, int total) {
                                  print("$sent $total");
                                },
                              );
                              if (response.statusCode == 200)
                                displaySnackBar(
                                    'Service Added Successfully', _scaffoldKey);
                              else
                                displaySnackBar(
                                    'Error Adding Service', _scaffoldKey);
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
