import 'package:flutter/material.dart';
import 'package:projekt/models/tuner_model.dart';
import 'package:projekt/services/login_service.dart';
import 'package:projekt/services/tuners_service.dart';

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
  String? selectedId;
  List<TunerModel>? availableTuners;
  final bool showActions;
  AppBarState(this.text, this.showActions);

  @override
  void initState() {
    super.initState();
  }

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
      title: Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: Text(text, style: TextStyle(color: Colors.black)),
      ),
      actions: [
        showActions
            ? Row(
                children: [
                  FutureBuilder<bool>(
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
                            onChanged: (String? newValue) async {
                              await setSelectedTunerId(newValue);
                              selectedId = newValue;
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
                  Padding(
                    padding: EdgeInsets.only(right: 20.0, left: 10),
                    child: PopupMenuButton(
                        onSelected: (int result) {
                          print(result);
                          switch (result) {
                            case 0:
                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/tuners", (route) => false);
                              break;
                            case 1:
                              logOff();
                              break;
                          }
                        },
                        elevation: 20,
                        enabled: true,
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 0,
                                child: Row(
                                  children: [
                                    Text(
                                      "Manage tuners",
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 1,
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
              )
            : Text(""),
      ],
      elevation: 0,
    );
  }
}
