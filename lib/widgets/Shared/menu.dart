import 'package:flutter/material.dart';
import 'package:project/services/alert_service.dart';
import 'package:project/services/globals.dart';
import 'package:project/services/tuners_service.dart';

class Menu extends StatelessWidget {
  final List<String> routes = ["/home", "/recordings/scheduled", "/programs/tv_program"];
  late final int currentIndex;
  late final bool noSelectedItem;

  Menu({int? currentIndex}) {
    switch (currentIndex) {
      case 0:
        activeTab = "/home";
        break;
      case 1:
        activeTab = "/recordings/scheduled";
        break;
      case 2:
        activeTab = "/programs/tv_program";
        break;
      default:
        activeTab = null;
    }

    if (currentIndex != null) {
      this.currentIndex = currentIndex;
      this.noSelectedItem = false;
    }
    else {
      this.currentIndex = 0;
      this.noSelectedItem = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fiber_manual_record),
          label: 'Recordings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.tv),
          label: 'Programs',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: noSelectedItem ? Colors.grey : Colors.black,
      unselectedItemColor: Colors.grey,
      onTap: (index) async {
        if ((await acceptedTuners).length == 0) {
          showSnackBar("You need at least one tuner");
          return;
        }
        Navigator.pushNamedAndRemoveUntil(context, routes[index], (route) => false);
      },
    );
  }
}
