import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:share_extend/share_extend.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Image Compression",
      home: MyHomePage1(),
    );
  }
}

class MyHomePage1 extends StatefulWidget {
  @override
  _MyHomePage1State createState() => _MyHomePage1State();
}

File image, image2;
double sliderValue = 50;
GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

class _MyHomePage1State extends State<MyHomePage1> {
  Future<void> pickImage(ImageSource source) async {
    File selected =
        await ImagePicker.pickImage(source: source, imageQuality: 100);
    setState(() {
      image = selected;
    });
  }

  void clear() {
    setState(() {
      image = null;
      image2 = null;
    });
  }

  void changed(e) {
    setState(() {
      sliderValue = e;
      // msg = "Quality is ${e.toString()}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: Text(
          "Image Compression",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue[900],
      ),
      body: Container(
        child: image == null
            ? Center(
                child: Text(
                  "Pick an Image to Compress",
                  style: TextStyle(color: Colors.green[900]),
                ),
              )
            : Column(
                children: <Widget>[
                  UploadInterface(),
                  //Text("The Slider denotes the quality of the image"),
                  FlutterSlider(
                    tooltip: FlutterSliderTooltip(
                        rightPrefix: Icon(
                      Icons.image,
                      color: Colors.blue[900],
                    )),
                    values: [50],
                    max: 95,
                    min: 5,
                    onDragging: (handlerIndex, lowerValue, upperValue) {
                      changed(lowerValue);
                    },
                  ),
                ],
              ),
      ),
      floatingActionButton: new Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              backgroundColor: Colors.green,
              foregroundColor: Colors.black,
              onPressed: () {
                pickImage(ImageSource.camera);
              },
              child: Icon(Icons.photo_camera),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 25),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.black,
                  onPressed: clear,
                  child: Icon(Icons.clear),
                ),
              )),
          Padding(
            padding: EdgeInsets.only(left: 25),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                foregroundColor: Colors.black,
                onPressed: () {
                  pickImage(ImageSource.gallery);
                },
                child: Icon(Icons.photo_library),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UploadInterface extends StatefulWidget {
  @override
  _UploadInterfaceState createState() => _UploadInterfaceState();
}

class _UploadInterfaceState extends State<UploadInterface> {
  final FirebaseStorage firebaseStorage = FirebaseStorage(
      storageBucket: 'gs://image-compression-android.appspot.com/');
  StorageUploadTask uploadTask;
  String filepath = 'images/${DateTime.now()}.png';
  var length = image.lengthSync().toString();

  Future<void> startUpload() async {
    File compressed = await FlutterImageCompress.compressAndGetFile(
        image.path, image.path,
        quality: sliderValue.toInt());
    setState(() {
      image2 = compressed;
      uploadTask = firebaseStorage.ref().child(filepath).putFile(image2);
    });
  }

  share() {
    String path = image2.path;
    ShareExtend.share(path, "file");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 390,
          width: 160,
          margin: EdgeInsets.only(top: 1, left: 10),
          decoration: BoxDecoration(
              border: Border.all(width: 3, color: Colors.lightBlueAccent)),
          child: Column(
            children: <Widget>[
              Image.file(
                image,
                height: 300,
                width: 150,
              ),
              Text(length + " bytes"),
              FloatingActionButton(
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.sync),
                  onPressed: startUpload),
            ],
          ),
        ),
        image2 == null
            ? Container(
                height: 390,
                width: 160,
                margin: EdgeInsets.only(top: 1, left: 10),
                decoration: BoxDecoration(
                    border:
                        Border.all(width: 3, color: Colors.lightBlueAccent)),
                child: Center(child: Text("Compressed Image")),
              )
            : Container(
                height: 390,
                width: 160,
                margin: EdgeInsets.only(top: 1, left: 10),
                decoration: BoxDecoration(
                    border:
                        Border.all(width: 3, color: Colors.lightBlueAccent)),
                child: Column(
                  children: <Widget>[
                    Image.file(
                      image2,
                      height: 300,
                      width: 150,
                    ),
                    Text(image2.lengthSync().toString() + " bytes"),
                    FloatingActionButton(
                      backgroundColor: Colors.orangeAccent,
                      child: Icon(Icons.share),
                      onPressed: share,
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
