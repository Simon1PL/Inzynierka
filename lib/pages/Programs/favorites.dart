import 'package:flutter/material.dart';
import 'package:projekt/widgets/app_bar.dart';
import 'package:projekt/widgets/app_bar_buttons.dart';
import 'package:projekt/widgets/button.dart';
import 'package:projekt/widgets/menu.dart';

class Favorites extends StatefulWidget {
  @override
  _Programs createState() =>  _Programs();
}

class _Programs extends State<Favorites> {

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
              "Favorites",
              true,
          ),
          MyButton(
              "Tv Program",
              false,
              () {Navigator.pushNamedAndRemoveUntil(context, "/programs/tv_program", (route) => false);}
          ),
          MyButton(
            "Explore",
            false,
            () {Navigator.pushNamedAndRemoveUntil(context, "/programs/explore", (route) => false);}
          ),
        ],
      ),
      bottomNavigationBar: Menu(
          currentIndex: 2
      ),
    );
  }
}