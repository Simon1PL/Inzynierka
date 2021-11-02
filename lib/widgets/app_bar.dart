import 'package:flutter/material.dart';
import 'package:projekt/widgets/settings_menu.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String text;
  final bool showActions;

  MyAppBar({String text = "", bool showActions = true})
      : this.text = text,
        this.showActions = showActions;

  @override
  AppBarState createState() => AppBarState(text, showActions);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class AppBarState extends State<MyAppBar> {
  final String text;
  final bool showActions;

  AppBarState(this.text, this.showActions);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      title: Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: Text(text, style: TextStyle(color: Colors.black)),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: SettingsMenu()
        ),
      ],
    );
  }
}
