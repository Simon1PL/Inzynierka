import 'package:flutter/material.dart';
import 'package:projekt/services/globals.dart';

class Menu extends StatelessWidget {
  final List<String> routes = ["/home", "/recordings/scheduled", "/programs/tv_program"];
  late int currentIndex = 0;
  late bool noSelectedItem = true;

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
      onTap: (index) {
        Navigator.pushNamedAndRemoveUntil(context, routes[index], (route) => false);
      },
    );
  }
}
