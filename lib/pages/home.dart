import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('R-M DVB-T Tunner',
        style: TextStyle(
          color: Colors.black
        )),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            FlatButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/recordings');
                },
                icon: Icon(Icons.edit_location),
                label: Text(
                    'Edit Location'
                )
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60.0,
          color: Colors.white,
          child: Row(
            children: [
              Text("Home"),
              Text("Recordings"),
              Text("Programs"),
            ],
          ),
        ),
      ),
    );
  }
}