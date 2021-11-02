import 'package:flutter/material.dart';
import 'package:projekt/models/tuner_model.dart';
import 'package:projekt/services/globals.dart';
import 'package:projekt/services/login_service.dart';
import 'package:projekt/services/tuners_service.dart';

class SettingsMenu extends StatefulWidget {
  SettingsMenu();

  @override
  SettingsMenuState createState() => SettingsMenuState();
}

class SettingsMenuState extends State<SettingsMenu> {
  String? tunerId;
  List<TunerModel> availableTuners = [];

  SettingsMenuState();

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
    return PopupMenuButton(
        onSelected: (int result) {
          switch (result) {
            case 0:
              Navigator.pushNamed(context, "/tuners");
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
                      if (activeTab != null) {
                        Navigator.pushNamedAndRemoveUntil(context, activeTab!, (route) => false);
                      }
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
            ]);
  }
}
