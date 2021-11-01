import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  final int? currentIndex;
  Menu({
    int? currentIndex,
  }): this.currentIndex = currentIndex;

  @override
  MenuState createState() => MenuState(currentIndex);
}

class MenuState extends State<Menu> {
  final List<String> routes = ["/home", "/recordings/scheduled", "/programs/tv_program"];
  int currentIndex = 0;
  bool noSelectedItem = true;
  MenuState(int? currentIndex) {
    if (currentIndex != null) {
      this.currentIndex = currentIndex;
      this.noSelectedItem = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
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
