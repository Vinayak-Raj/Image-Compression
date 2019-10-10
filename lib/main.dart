import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_xlider/flutter_xlider.dart';
import './ui/compression.dart' as firstpage;
import './ui/info.dart' as secondpage;

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
// GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

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
    });
  }

  void displaySecondPage() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return secondpage.InfoInterface();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: Text(
          "Image Compression",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue[900],
        actions: <Widget>[
          IconButton(
            icon: new Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
            onPressed: image == null ? displaySecondPage : null,
          ),
        ],
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
                  firstpage.CompressionInterface(),
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
              heroTag: "1",
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
                  heroTag: "2",
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
                heroTag: "3",
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
