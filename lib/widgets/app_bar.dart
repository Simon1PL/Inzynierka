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
  final bool showActions;
  String? tunerId;
  List<TunerModel> availableTuners = [];

  AppBarState(this.text, this.showActions);


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
      title: Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: Text(text, style: TextStyle(color: Colors.black)),
      ),
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
                          onChanged: (String? newValue) {
                            setSelectedTunerId(newValue);
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
    );
  }
}
