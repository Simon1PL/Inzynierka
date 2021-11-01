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
  final List<bool> isSelected;
  Object? selectedValueFromMenu;
  String? selectedId;
  List<TunerModel>? availableTuners;

  AppBarState(this.buttons, this.isSelected);

  Future<bool> loadTuners() async {
    selectedId = (await selectedTunerId).toString();
    availableTuners = await tuners;
    return true;
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
          selectedColor: Colors.blue[600],
          selectedBorderColor: Colors.blue[600],
          fillColor: Colors.blue[600]!.withOpacity(0.08),
          splashColor: Colors.blue[600]!.withOpacity(0.12),
          hoverColor: Colors.blue[600]!.withOpacity(0.04),
          borderRadius: BorderRadius.circular(4.0),
          constraints: BoxConstraints(minHeight: 36.0),
          isSelected: isSelected,
          onPressed: (index) {
            // Respond to button selection
            setState(() {
              isSelected[index] = !isSelected[index];
            });
          },
          children: buttons,
        ),
      ]),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: PopupMenuButton(
              elevation: 20,
              enabled: true,
              onSelected: (value) {
                setState(() {
                  selectedValueFromMenu = value;
                  // here do sth with selected option from menu
                });
              },
              itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, "/tuners", (route) => false);
                        },
                        child: Row(
                          children: [
                            Text(
                              "Manage tuners",
                            ),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 0,
                      child: FutureBuilder<bool>(
                          future: loadTuners(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return DropdownButton<String>(
                                value: selectedId,
                                icon: const Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                underline: Container(
                                  height: 2,
                                  color: Colors.blue,
                                ),
                                onChanged: (String? newValue) {
                                  setSelectedTunerId(newValue);
                                  setState(() {
                                    selectedId = newValue;
                                  });
                                },
                                items: availableTuners!
                                    .map<DropdownMenuItem<String>>(
                                        (TunerModel tuner) {
                                  return DropdownMenuItem<String>(
                                    value: tuner.tunerId.toString(),
                                    child: Text(tuner.name!),
                                  );
                                }).toList(),
                              );
                            } else
                              return Text("");
                          }),
                    ),
                    PopupMenuItem(
                      value: 0,
                      child: GestureDetector(
                        onTap: () {
                          logOff();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.logout),
                            Text(
                              "Logout",
                            ),
                          ],
                        ),
                      ),
                    )
                  ]),
        ),
      ],
      elevation: 0,
    );
  }
}
