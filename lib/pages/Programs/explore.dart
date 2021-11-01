import 'package:flutter/material.dart';
import 'package:projekt/widgets/app_bar_buttons.dart';
import 'package:projekt/widgets/menu.dart';

class Explore extends StatefulWidget {
  @override
  _Programs createState() =>  _Programs();
}

class _Programs extends State<Explore> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: MyAppBarWithButtons(
        [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, "/programs/favorites", (route) => false);
            },
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Text('Favorites')
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {Navigator.pushNamedAndRemoveUntil(context, "/programs/tv_program", (route) => false);},
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Text('TV Programme')
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {Navigator.pushNamedAndRemoveUntil(context, "/programs/explore", (route) => false);},
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Text('Explore')
            ),
          ),
        ], 2
      ),
      bottomNavigationBar: Menu(
          currentIndex: 2
      ),
    );
  }
}