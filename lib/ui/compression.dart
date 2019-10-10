import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';
import 'package:share_extend/share_extend.dart';
import '../main.dart';

class CompressionInterface extends StatefulWidget {
  @override
  _CompressionInterfaceState createState() => _CompressionInterfaceState();
}

class _CompressionInterfaceState extends State<CompressionInterface> {
  var length = image.lengthSync().toString();

  Future<void> startUpload() async {
    File compressed = await FlutterImageCompress.compressAndGetFile(
        image.path, image.path,
        quality: sliderValue.toInt());
    setState(() {
      image2 = compressed;
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
