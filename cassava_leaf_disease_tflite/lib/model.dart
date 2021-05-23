import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BuildModel extends StatefulWidget {
  BuildModel({Key key}) : super(key: key);

  @override
  _BuildModelState createState() => _BuildModelState();
}

class _BuildModelState extends State<BuildModel> {
  List _outputs;
  File _image;
  bool _loading = false;
  final picker = ImagePicker();
  String _result = "";

  @override
  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    if (pickedFile == null) return null;
    setState(() {
      _loading = true;
      _image = File(pickedFile.path);
    });
    Navigator.pop(context);
    classifyImage(_image);
  }

  openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return null;
    setState(() {
      _loading = true;
      _image = File(pickedFile.path);
    });
    Navigator.pop(context);
    classifyImage(_image);
  }

  Future showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Choose option",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      openGallery(context);
                    },
                    title: Text("Gallery"),
                    leading: Icon(
                      Icons.account_box,
                      color: Colors.blue,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      openCamera(context);
                    },
                    title: Text("Camera"),
                    leading: Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/cassava_plant_cnn.tflite",
      labels: "assets/cassava_plant_cnn.txt",
      numThreads: 1,
    );
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 2,
        threshold: 0.2,
        asynch: true);
    setState(() {
      _loading = false;
      _outputs = output;
      _result = "Label : " +
          _outputs[0]['label'] +
          "\nConfidence : " +
          (_outputs[0]['confidence'] * 100).toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cassava Leaf Disease",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _loading
                ? Container(
                    height: 300,
                    width: 300,
                  )
                : Container(
                    margin: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _image == null ? Container() : Image.file(_image),
                        SizedBox(
                          height: 20,
                        ),
                        _image == null
                            ? Container()
                            : _outputs != null
                                ? Text(
                                    _result,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  )
                                : Container(child: Text(""))
                      ],
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Pick Image',
        onPressed: () {
          showChoiceDialog(context);
        },
        child: Icon(
          Icons.add_a_photo,
          size: 20,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
