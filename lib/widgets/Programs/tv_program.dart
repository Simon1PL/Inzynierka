import 'package:flutter/material.dart';
import 'package:project/models/program_model.dart';
import 'package:project/services/db_service.dart';
import 'package:project/widgets/Shared/app_bar_with_buttons.dart';
import 'package:project/widgets/Programs/program_list.dart';
import 'package:project/widgets/Shared/loader.dart';
import 'package:project/widgets/Shared/menu.dart';
import 'package:collection/collection.dart';

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
    List<ProgramModel> programsTmp = await getEpg();
    List<ProgramModel> alreadySaved = [...(await getRecorded()), ...(await getScheduled())];

    programsTmp
      .forEach((element) {
        var program = alreadySaved.firstWhereOrNull((e) => e.title == element.title);

        if (program != null) {
          element.alreadyScheduled = true;
          element.orderId = program.orderId;
          element.fileName = program.fileName;
          element.recordSize = program.recordSize;
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
              child: Text('TV Program')),
        ),
      ], 1),
      body: dataLoaded
          ? ProgramList(programs, "Something went wrong, can not get EPG", false)
          : Loader(),
      bottomNavigationBar: Menu(currentIndex: 2),
    );
  }
}
