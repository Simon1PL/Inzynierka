import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String text;
  MyAppBar({
    String text = "",
  }): this.text = text;

  @override
  AppBarState createState() => AppBarState(text);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class AppBarState extends State<MyAppBar> {
  final String text;
  AppBarState(this.text);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      title:
      Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
              text,
              style: TextStyle(
                  color: Colors.black
              )
          ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.more_vert
            ),
          )
        ),
      ],
      elevation: 0,
    );
  }
}
