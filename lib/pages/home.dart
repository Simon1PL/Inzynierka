import 'package:flutter/material.dart';
import 'package:projekt/widgets/app_bar.dart';
import 'package:projekt/widgets/menu.dart';
import 'package:projekt/widgets/section_title.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: MyAppBar(
        text: "R-M DVB-T Tuner",
      ),
      body: Column(
        children: [
          SectionTitle("Your recording list"),
          SectionTitle("Your scheduled favourites"),
          SectionTitle("Check this out"),
        ]
      ),
      bottomNavigationBar: Menu(
        currentIndex: 0,
      ),
    );
  }
}