import 'package:flutter/material.dart';
import 'package:project/widgets/Shared/settings_menu.dart';

class MyAppBarWithButtons extends StatefulWidget
    implements PreferredSizeWidget {
  final List<Widget> buttons;
  late final isSelected;

  MyAppBarWithButtons(this.buttons, int selectedTabIndex) {
    isSelected = new List.filled(buttons.length, false);
    isSelected[selectedTabIndex] = true;
  }

  @override
  AppBarState createState() => AppBarState(buttons, isSelected);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class AppBarState extends State<MyAppBarWithButtons> {
  final List<Widget> buttons;
  List<bool> isSelected;

  AppBarState(this.buttons, this.isSelected);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ToggleButtons(
          color: Colors.black.withOpacity(0.60),
          selectedColor: Colors.blue,
          selectedBorderColor: Colors.blue,
          fillColor: Colors.blue.withOpacity(0.08),
          splashColor: Colors.blue.withOpacity(0.12),
          hoverColor: Colors.blue.withOpacity(0.04),
          borderRadius: BorderRadius.circular(4.0),
          constraints: BoxConstraints(minHeight: 36.0),
          isSelected: isSelected,
          onPressed: (index) {
            var isSelectedTmp = List.filled(buttons.length, false);
            isSelectedTmp[index] = true;

            setState(() {
              isSelected = isSelectedTmp;
            });
          },
          children: buttons,
        ),
      ]),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: SettingsMenu()
        ),
      ],
      elevation: 0,
    );
  }
}
