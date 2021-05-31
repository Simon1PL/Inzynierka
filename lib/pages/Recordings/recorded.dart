import 'package:flutter/material.dart';
import 'package:projekt/widgets/app_bar.dart';
import 'package:projekt/widgets/app_bar_buttons.dart';
import 'package:projekt/widgets/button.dart';
import 'package:projekt/widgets/menu.dart';

class Recorded extends StatefulWidget {
  @override
  _Recordings createState() => _Recordings();
}

class _Recordings extends State<Recorded> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar:MyAppBarWithButtons(
        buttons: [
          MyButton(
            "Recorded",
            true,
          ),
          MyButton(
            "Scheduled",
            false,
            () {Navigator.pushNamedAndRemoveUntil(context, "/recordings/scheduled", (route) => false);}),
        ],
        ),
        bottomNavigationBar: Menu(
        currentIndex: 1
      ),
    );
  }
}