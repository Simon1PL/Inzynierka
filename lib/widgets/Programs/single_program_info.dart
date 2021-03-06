import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:project/models/program_model.dart';
import 'package:project/services/db_service.dart';
import 'package:project/services/favorite_service.dart';
import 'package:project/widgets/Favorites/favorite_icon.dart';
import 'package:project/widgets/Programs/next_in_epg_list_item.dart';
import 'package:project/widgets/Recordings/schedule_icon.dart';
import 'package:project/widgets/Shared/app_bar.dart';
import 'package:project/widgets/Shared/loader.dart';
import 'package:project/widgets/Shared/menu.dart';

class SingleProgram extends StatefulWidget {
  static const String routeName = '/programs/program_info';
  late final bool reloadData;
  late final ProgramModel program;

  SingleProgram(this.program, {this.reloadData = false});
  @override
  _SingleProgram createState() => _SingleProgram(this.program, this.reloadData);
}

class _SingleProgram extends State<SingleProgram> {
  List<String>? favTitles;
  List<ProgramModel>? nextInEpg;
  late ProgramModel program;

  _SingleProgram(this.program, bool reloadData) {
    if (reloadData) {
      reloadProgramData();
    }
  }

  @override
  void initState() {
    super.initState();
    if (program.favorite2 && favTitles == null) loadFav();
    if (nextInEpg == null) loadNextInEpg();
  }

  loadFav() async {
    var favTitlesTmp = (await getFavorites())[1]
            ?.where(
                (e) => program.title!.toLowerCase().contains(e.toLowerCase()))
            .toList() ??
        [];
    setState(() {
      favTitles = favTitlesTmp;
    });
  }

  loadNextInEpg() async {
    var nextInEpgTmp = (await getEpg())
            .where((e) =>
                program.title == e.title &&
                (program.start != e.start || program.channelId != e.channelId))
            .toList();
    setState(() {
      nextInEpg = nextInEpgTmp;
    });
  }

  reloadProgramData() async {
    var favs = await getFavorites();
    var fav2 = favs[1]
        ?.any((e) => program.title!.toLowerCase().contains(e.toLowerCase()));
    setState(() {
      program.favorite2 = fav2 ?? false;
    });
    if (program.favorite2) {
      loadFav();
    }
    var fav1 =
        favs[0]?.any((e) => program.title!.toLowerCase() == e.toLowerCase());
    setState(() {
      program.favorite = fav1 ?? false;
    });

    List<ProgramModel> scheduled = await getScheduled();
    scheduled.addAll(await getRecorded());
    if (scheduled
        .any((p) => p.title!.toLowerCase() == program.title!.toLowerCase())) {
      var p = scheduled.firstWhere(
          (p) => p.title!.toLowerCase() == program.title!.toLowerCase());
      setState(() {
        program.alreadyScheduled = true;
        program.orderId = p.orderId;
      });
    } else {
      setState(() {
        program.alreadyScheduled = false;
        program.orderId = null;
        program.recordSize = null;
      });
    }
  }

  void refreshProgram() async {
    loadFav();
    setState(() {
      program = program;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: MyAppBar(
        text: "",
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: program.favorite2
                    ? Colors.blue.withOpacity(0.5)
                    : Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 1,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 15, 22, 15),
            child: Stack(
              children: [
                SizedBox.expand(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left:
                                      40 /*it has to be equal to favorite icon size + right padding to be in center*/,
                                  right: 10,
                                  bottom: 12.0),
                              child: Text(
                                program.title != null
                                    ? program.title!
                                    : "No title!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          FavoriteIcon(program, refreshProgram)
                        ],
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      program.subtitle != null
                                          ? Center(
                                              child: Text(
                                                program.subtitle!,
                                                style: TextStyle(
                                                  fontSize: 17,
                                                ),
                                              ),
                                            )
                                          : SizedBox.shrink(),
                                      program.favorite2
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15.0),
                                              child: Wrap(
                                                direction: Axis.horizontal,
                                                children: [
                                                  Text(
                                                    "Fitting favorite titles: ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                  favTitles != null
                                                      ? Text(
                                                          favTitles!.join(", "),
                                                          style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 17,
                                                          ),
                                                        )
                                                      : SizedBox(
                                                          width: 20,
                                                          child:
                                                              SpinKitFadingCircle(
                                                            color: Colors
                                                                .grey[800],
                                                            size: 20,
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            )
                                          : SizedBox.shrink(),
                                      program.summary == null ||
                                              program.summary ==
                                                  program.subtitle
                                          ? SizedBox.shrink()
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: Wrap(
                                                children: [
                                                  Text(
                                                    "Summary: ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                  Text(
                                                    program.summary!,
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      program.genre.length > 0
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: Wrap(
                                                children: [
                                                  Text(
                                                    "Genre: ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                  Text(
                                                    program.genre.join(", "),
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : SizedBox.shrink(),
                                      program.fileName != null
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: Wrap(
                                                children: [
                                                  Text(
                                                    "Downloaded file: ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                  Wrap(
                                                    children: [
                                                      Icon(Icons.folder),
                                                      Text(
                                                        program.fileName! +
                                                            " (" +
                                                            (program.recordSize! /
                                                                    1024 /
                                                                    1024)
                                                                .toStringAsFixed(
                                                                    2) +
                                                            "MB)",
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          : SizedBox.shrink(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Wrap(
                                          children: [
                                            Text(
                                              "Description: ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17,
                                              ),
                                            ),
                                            Text(
                                              (program.description == null
                                                  ? "Sorry, we have no description for this program"
                                                  : program.description!),
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Wrap(
                                          children: [
                                            Text(
                                              "Channel: ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17,
                                              ),
                                            ),
                                            Text(
                                              (program.channelName != null
                                                      ? program.channelName!
                                                      : "") +
                                                  (program.channelNumber != null
                                                      ? " (" +
                                                          program
                                                              .channelNumber! +
                                                          ")"
                                                      : "-"),
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Wrap(
                                          children: [
                                            Text(
                                              "Date: ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17,
                                              ),
                                            ),
                                            Text(
                                              (program.start != null &&
                                                      program.stop != null
                                                  ? DateFormat("dd.MM.yyyy")
                                                      .format(program.start!)
                                                  : "-"),
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.access_time_filled),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(right: 5)),
                                            Text(
                                              program.start != null &&
                                                      program.stop != null
                                                  ? DateFormat.Hm().format(
                                                          program.start!) +
                                                      " - " +
                                                      DateFormat.Hm()
                                                          .format(program.stop!)
                                                  : "00:00 - 00:00",
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Wrap(
                                          children: [
                                            Text(
                                              "Other occurrences in epg: ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17,
                                              ),
                                            ),
                                            Text(
                                              (nextInEpg != null &&
                                                      nextInEpg!.length == 0
                                                  ? "-"
                                                  : ""),
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      nextInEpg != null
                                          ? ListView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: nextInEpg!.length,
                                              itemBuilder: (context, index) {
                                                return NextInEpgListItem(
                                                    ValueKey(nextInEpg![index]),
                                                    nextInEpg![index],
                                                    program);
                                              })
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: Loader(),
                                            )
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: ScheduleIcon(program)
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Menu(),
    );
  }
}
