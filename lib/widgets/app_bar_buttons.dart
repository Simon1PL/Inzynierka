import 'package:flutter/material.dart';

class MyAppBarWithButtons extends StatefulWidget implements PreferredSizeWidget {
  final List<Widget> buttons;
  MyAppBarWithButtons({
    required List<Widget> buttons,
  }): this.buttons = buttons;

  @override
  AppBarState createState() => AppBarState(buttons);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class AppBarState extends State<MyAppBarWithButtons> {
  final List<Widget> buttons;
  AppBarState(this.buttons);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      title:
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: buttons,
      ),
      elevation: 0,
    );
  }
}
