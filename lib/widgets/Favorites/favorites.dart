import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/models/program_model.dart';
import 'package:project/services/favorite_service.dart';
import 'package:project/services/programs_service.dart';
import 'package:project/widgets/Favorites/favorite_titles.dart';
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
  List<String> favorites2 = [];
  bool dataLoaded = false, titleView = false;
  var isSelected = [true, false];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  loadFavorites() async {
    var tmp = await getFavorites();
    List<String>? favorites = tmp[0];
    favorites2 = tmp[1] ?? [];
    favorites2.sort((a, b) => a.toString().compareTo(b.toString()));
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
    List<ProgramModel> programsTmp = [];
    if (recorded != null) {
      programsTmp.addAll(recorded);
    }

    if (scheduled != null) {
      programsTmp.addAll(scheduled);
    }

    if (epg != null) {
      programsTmp.addAll(epg);
    }

    favorites.sort((a, b) => a.toString().compareTo(b.toString()));
    var favoritePrograms = favorites.map((e) {
      var program = programsTmp.firstWhere((element) => element.title == e, orElse: () => ProgramModel(title: e));
      program.favorite = true;
      program.favorite2 = favorites2.any((e) => program.title!.toLowerCase().contains(e.toLowerCase()));
      return program;
    }).toList();

    setState(() {
      this.programs = favoritePrograms;
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
              child: Text('TV Programe')),
        ),
      ], 0),
      body: dataLoaded
          ? Column(children: [
              Padding(padding: EdgeInsets.only(top: 10.0)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text(""),
                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(
                        width: titleView ? 1.0 : 2.0, color: Colors.grey),
                  ),
                  onPressed: () {
                    setState(() {
                      titleView = false;
                    });
                  },
                  child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      child: Text(
                        'Episodes',
                        style: TextStyle(
                            fontWeight: titleView ? null : FontWeight.w600,
                            color: Colors.black),
                      )),
                ),
                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(
                        width: !titleView ? 1.0 : 2.0, color: Colors.grey),
                  ),
                  onPressed: () {
                    setState(() {
                      titleView = true;
                    });
                  },
                  child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      child: Text(
                        'Titles',
                        style: TextStyle(
                            fontWeight: !titleView ? null : FontWeight.w600,
                            color: Colors.black),
                      )),
                ),
                Text(""),
              ]),
              !titleView
                  ? Expanded(
                      child: ProgramList(programs,
                          "Something went wrong, can not get favorites"),
                    )
                  : Expanded(child: FavoriteTitles(favorites2))
            ])
          : Loader(),
      bottomNavigationBar: Menu(currentIndex: 2),
    );
  }
}
