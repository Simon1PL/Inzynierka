import 'package:flutter/material.dart';
import 'package:project/models/program_model.dart';
import 'package:project/services/favorite_service.dart';
import 'package:project/services/programs_service.dart';
import 'package:project/widgets/Shared/app_bar_with_buttons.dart';
import 'package:project/widgets/Programs/program_list.dart';
import 'package:project/widgets/Shared/loader.dart';
import 'package:project/widgets/Shared/menu.dart';

class Favorites extends StatefulWidget {
  @override
  _Programs createState() => _Programs();
}

class _Programs extends State<Favorites> {
  List<ProgramModel>? programs;
  List<String> otherFavorites = [];
  bool dataLoaded = false;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  loadFavorites() async {
    List<String>? favorites = await getFavorites();
    if (favorites == null) {
      setState(() {
        this.programs = null;
        this.dataLoaded = true;
      });
      return;
    }

    List<ProgramModel>? recorded = await getRecorded();
    List<ProgramModel>? scheduled = await getScheduled();
    List<ProgramModel>? epg = await getEpg();
    List<ProgramModel>? programsTmp = [];
    if (recorded != null) {
      programsTmp.addAll(recorded);
    }

    if (scheduled != null) {
      programsTmp.addAll(scheduled);
    }

    if (epg != null) {
      programsTmp.addAll(epg);
    }

    programsTmp = programsTmp
        .where((element) => favorites.contains(element.title))
        .toList();

    programsTmp.forEach((element) => element.favorite = true);

    var programsNames = programsTmp.map((e) => e.title).toList();

    setState(() {
      this.otherFavorites = favorites
          .where((element) => !programsNames.contains(element))
          .toList();
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
      ], 0),
      body: dataLoaded
          ? Column(children: [
          ConstrainedBox(
            constraints: new BoxConstraints(
              maxHeight: 500.0,
            ),
                child: ProgramList(
                    programs, "Something goes wrong, can not get favorites"),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 10),
                child: Text(
                  'Other favorites:',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(color: Colors.blue[600]!, fontSize: 25),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: otherFavorites.length,
                    itemBuilder: (context, index) {
                      return Text(otherFavorites[index],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w300));
                    }),
              )
            ])
          : Loader(),
      bottomNavigationBar: Menu(currentIndex: 2),
    );
  }
}
