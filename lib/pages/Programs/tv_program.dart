import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:projekt/models/program_model.dart';
import 'package:projekt/services/favorite_service.dart';
import 'package:projekt/services/programs_service.dart';
import 'package:projekt/widgets/app_bar_buttons.dart';
import 'package:projekt/widgets/loading_list.dart';
import 'package:projekt/widgets/menu.dart';

class TvProgram extends StatefulWidget {
  @override
  _Programs createState() => _Programs();
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
    if (programsTmp == null) {
      setState(() {
        this.programs = null;
        this.dataLoaded = true;
      });
      return;
    }

    List<String>? favorites = await getFavorites();
    if (favorites != null) {
      programsTmp
          .where((element) => favorites.contains(element.title))
          .forEach((element) {
        element.favorite = true;
      });
    }

    List<ProgramModel>? recorded = await getRecorded();
    List<ProgramModel>? scheduled = await getScheduled();
    List<String> alreadySaved = [];
    if (recorded != null) {
      programsTmp.addAll(recorded);
    }

    if (scheduled != null) {
      programsTmp.addAll(scheduled);
    }

    programsTmp
        .where((element) => alreadySaved.contains(element.title))
        .forEach((element) => element.alreadyScheduled = true);

    setState(() {
      this.programs = programsTmp;
      this.dataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: MyAppBarWithButtons([
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, "/programs/favorites", (route) => false);
          },
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Text('Favorites')),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, "/programs/tv_program", (route) => false);
          },
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Text('TV Programme')),
        ),
      ], 1),
      body: dataLoaded
          ? ProgramList(programs, "Something goes wrong, can not get EPG")
          : Center(
              child: SpinKitFadingCircle(
                color: Colors.grey[800],
                size: 50,
              ),
            ),
      bottomNavigationBar: Menu(currentIndex: 2),
    );
  }
}
