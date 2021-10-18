import 'package:flutter/material.dart';
import 'package:projekt/models/program_model.dart';
import 'package:projekt/services/tuner_service.dart';
import 'package:projekt/widgets/app_bar_buttons.dart';
import 'package:projekt/widgets/button.dart';
import 'package:projekt/widgets/loading_list.dart';
import 'package:projekt/widgets/menu.dart';

class TvProgram extends StatefulWidget {
  @override
  _Programs createState() =>  _Programs();
}

class _Programs extends State<TvProgram> {
  List<ProgramModel>? programs;
  bool dataLoaded = false;

  @override
  void initState() {
    super.initState();
    loadEpg();
  }

  loadEpg() async {
    List<ProgramModel>? programsTmp = await getEpg();

    setState(() {
      this.programs = programsTmp;
      this.dataLoaded = true;
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
      body: getView(programs, dataLoaded, "Something goes wrong, can not get EPG"),
      bottomNavigationBar: Menu(
          currentIndex: 2
      ),
    );
  }
}