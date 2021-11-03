import 'package:flutter/material.dart';
import 'package:project/models/program_model.dart';
import 'package:project/services/favorite_service.dart';
import 'package:project/services/programs_service.dart';
import 'package:project/widgets/Shared/app_bar_with_buttons.dart';
import 'package:project/widgets/Programs/program_list.dart';
import 'package:project/widgets/Shared/loader.dart';
import 'package:project/widgets/Shared/menu.dart';

class TvProgram extends StatefulWidget {
  @override
  _Programs createState() => _Programs();
}

class _Programs extends State<TvProgram> {
  List<ProgramModel>? programs;
  bool dataLoaded = false;

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

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

    programsTmp = await fillFavoritesDataInProgramList(programsTmp);

    List<ProgramModel>? recorded = await getRecorded();
    List<ProgramModel>? scheduled = await getScheduled();
    List<ProgramModel> alreadySaved = [];
    if (recorded != null) {
      alreadySaved.addAll(recorded);
    }

    if (scheduled != null) {
      alreadySaved.addAll(scheduled);
    }

    programsTmp
        .forEach((element) {
          if (alreadySaved.any((e) => e.title == element.title)) {
            element.alreadyScheduled = true;
            element.orderId = alreadySaved.firstWhere((e) => e.title == element.title).orderId;
          }
        });

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
          : Loader(),
      bottomNavigationBar: Menu(currentIndex: 2),
    );
  }
}
