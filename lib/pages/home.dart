import 'package:flutter/material.dart';
import 'package:projekt/widgets/app_bar.dart';
import 'package:projekt/widgets/menu.dart';

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
      backgroundColor: Colors.grey[200],
      appBar: MyAppBar(
        text: "R-M DVB-T Tuner",
      ),
      bottomNavigationBar: Menu(
        currentIndex: 0,
      ),
    );
  }
}