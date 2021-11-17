import 'package:flutter/material.dart';
import 'package:project/services/login_service.dart';
import 'package:project/widgets/Shared/tuner_dropdown.dart';

class SettingsMenu extends StatelessWidget {

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
            case 3:
              Navigator.pushNamed(context, "/settings");
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
              PopupMenuItem(value: 1, child: TunerDropdown()),
              PopupMenuItem(
                value: 3,
                child: Text(
                  "Settings",
                ),
              ),
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
