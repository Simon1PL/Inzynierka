import 'package:flutter/material.dart';
import 'package:project/models/program_model.dart';
import 'package:project/services/favorite_service.dart';
import 'package:project/services/programs_service.dart';
import 'package:project/widgets/Shared/app_bar_with_buttons.dart';
import 'package:project/widgets/Programs/program_list.dart';
import 'package:project/widgets/Shared/loader.dart';
import 'package:project/widgets/Shared/menu.dart';

class Scheduled extends StatefulWidget {
  @override
  _Recordings createState() => _Recordings();
}

class _Recordings extends State<Scheduled> {
  List<ProgramModel>? programs;
  bool dataLoaded = false;

  @override
  void initState() {
    super.initState();
    loadScheduled();
  }

  loadScheduled() async {
    List<ProgramModel>? programsTmp = await getScheduled();
    if (programsTmp == null) {
      setState(() {
        this.programs = null;
        this.dataLoaded = true;
      });
      return;
    }

    programsTmp = await fillFavoritesDataInProgramList(programsTmp);

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
                context, "/recordings/recorded", (route) => false);
          },
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Text('Recorded')),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, "/recordings/scheduled", (route) => false);
          },
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Text('Scheduled')),
        ),
      ], 1),
      body: dataLoaded
          ? ProgramList(
              programs, "Something goes wrong, can not load scheduled programs")
          : Loader(),
      bottomNavigationBar: Menu(currentIndex: 1),
    );
  }
}
