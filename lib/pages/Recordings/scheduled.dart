import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:projekt/models/program_model.dart';
import 'package:projekt/services/favorite_service.dart';
import 'package:projekt/services/programs_service.dart';
import 'package:projekt/widgets/app_bar_with_buttons.dart';
import 'package:projekt/widgets/program_list.dart';
import 'package:projekt/widgets/menu.dart';

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

    List<String>? favorites = await getFavorites();
    if (favorites != null) {
      programsTmp
          .where((element) => favorites.contains(element.title))
          .forEach((element) => element.favorite = true);
    }

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
          : Center(
              child: SpinKitFadingCircle(
                color: Colors.grey[800],
                size: 50,
              ),
            ),
      bottomNavigationBar: Menu(currentIndex: 1),
    );
  }
}
