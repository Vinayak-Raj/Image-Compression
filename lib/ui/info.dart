import 'package:flutter/material.dart';

class InfoInterface extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: Text("Info"),
        backgroundColor: Colors.lightBlue[900],
      ),
      body: Center(
        child: Image.asset("assets/com.gif"),
      ),
    );
  }
}