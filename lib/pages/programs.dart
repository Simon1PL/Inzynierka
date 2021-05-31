import 'package:flutter/material.dart';

class Programs extends StatefulWidget {
  @override
  _Programs createState() =>  _Programs();
}

class _Programs extends State<Programs> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Choose a Location'),
        centerTitle: true,
        elevation: 0,
      ),
    );
  }
}