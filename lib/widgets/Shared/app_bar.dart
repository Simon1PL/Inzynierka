import 'package:flutter/material.dart';
import 'package:project/widgets/Shared/settings_menu.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final bool showActions;

  MyAppBar({String text = "", bool showActions = true})
      : this.text = text,
        this.showActions = showActions;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

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
        if (showActions)
          Padding(padding: EdgeInsets.only(right: 20.0), child: SettingsMenu()),
      ],
    );
  }
}
