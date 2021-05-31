import 'package:flutter/material.dart';
import 'package:projekt/services/tuner_service.dart';
import 'package:projekt/widgets/app_bar.dart';
import 'package:projekt/widgets/app_bar_buttons.dart';
import 'package:projekt/widgets/button.dart';
import 'package:projekt/widgets/menu.dart';
import 'package:projekt/widgets/single_item_vertical_list.dart';

class TvProgram extends StatefulWidget {
  @override
  _Programs createState() =>  _Programs();
}

class _Programs extends State<TvProgram> {
  List<Program> programs = [];

  @override
  void initState() {
    super.initState();
    loadEpg();
  }

  loadEpg() async {
    List<Program> programsTmp = await getEpg(1);
    setState(() {
      this.programs = programsTmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: MyAppBarWithButtons(
        buttons: [
          MyButton(
              "Favorites",
              false,
                  () {Navigator.pushNamedAndRemoveUntil(context, "/programs/favorites", (route) => false);}
          ),
          MyButton(
              "Tv Program",
              true,
          ),
          MyButton(
            "Explore",
            false,
            () {Navigator.pushNamedAndRemoveUntil(context, "/programs/explore", (route) => false);}
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: programs.length,
        itemBuilder: (context, index) {
          return SingleItemVerticalList(programs[index]);
        }
      ),
      bottomNavigationBar: Menu(
          currentIndex: 2
      ),
    );
  }
}