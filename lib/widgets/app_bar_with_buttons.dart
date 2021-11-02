import 'package:flutter/material.dart';
import 'package:projekt/models/tuner_model.dart';
import 'package:projekt/services/login_service.dart';
import 'package:projekt/services/tuners_service.dart';

class MyAppBarWithButtons extends StatefulWidget
    implements PreferredSizeWidget {
  final List<Widget> buttons;
  late final isSelected;

  MyAppBarWithButtons(List<Widget> buttons, int selectedTabIndex)
      : this.buttons = buttons {
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
  String? tunerId;
  List<TunerModel> availableTuners = [];

  AppBarState(this.buttons, this.isSelected);

  Future<void> loadTuners() async {
    var tunerIdTmp = (await selectedTunerId).toString();
    var availableTunersTmp = await tuners;
    setState(() {
      tunerId = tunerIdTmp;
      availableTuners = availableTunersTmp;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTuners();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
          child: PopupMenuButton(
              onSelected: (int result) {
                switch (result) {
                  case 0:
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/tuners", (route) => false);
                    break;
                  case 2:
                    logOff();
                    break;
                }
              },
              elevation: 20,
              enabled: true,
              itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 0,
                      child: Text(
                        "Manage tuners",
                      ),
                    ),
                    PopupMenuItem(
                        value: 1,
                        child: DropdownButton<String>(
                          value: tunerId,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          underline: Container(
                            height: 2,
                            color: Colors.blue,
                          ),
                          onChanged: (String? newValue) async {
                            await setSelectedTunerId(newValue);
                            setState(() {
                              tunerId = newValue;
                            });
                          },
                          items: availableTuners
                              .map((tuner) => DropdownMenuItem<String>(
                                    value: tuner.tunerId.toString(),
                                    child: Text(tuner.name),
                                  ))
                              .toList(),
                        )),
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          Icon(Icons.logout),
                          Text(
                            "Logout",
                          ),
                        ],
                      ),
                    )
                  ]),
        ),
      ],
      elevation: 0,
    );
  }
}
