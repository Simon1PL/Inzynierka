import 'package:flutter/material.dart';
import 'package:projekt/widgets/app_bar_buttons.dart';
import 'package:projekt/widgets/button.dart';
import 'package:projekt/widgets/menu.dart';

class Scheduled extends StatefulWidget {
  @override
  _Recordings createState() => _Recordings();
}

class _Recordings extends State<Scheduled> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: MyAppBarWithButtons(
        buttons: [
          MyButton(
            "Recorded",
            false,
            () {Navigator.pushNamedAndRemoveUntil(context, "/recordings/recorded", (route) => false);}
          ),
          MyButton("Scheduled", true),
        ],
      ),
      bottomNavigationBar: Menu(
        currentIndex: 1
      ),
    );
  }
}