import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/models/program_model.dart';
import 'package:project/widgets/Favorites/favorite_icon.dart';
import 'package:project/widgets/Programs/single_program_info.dart';
import 'package:project/widgets/Recordings/schedule_icon.dart';

class ProgramListItem extends StatefulWidget {
  final ProgramModel model;

  ProgramListItem(Key key, this.model) : super(key: key);

  @override
  _ProgramListItem createState() => _ProgramListItem(model);
}

class _ProgramListItem extends State<ProgramListItem> {
  final ProgramModel model;
  _ProgramListItem(this.model);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SingleProgram(model)));
        },
        child: Padding(
          padding:
              EdgeInsets.only(top: 15.0, right: 15.0, left: 15.0, bottom: 0.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: model.favorite2
                      ? Colors.blue.withOpacity(0.5)
                      : Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 1,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 6, 15, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 12.0),
                          child: model.title != null
                              ? Text(
                                  model.title!,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : SizedBox.shrink(),
                        ),
                      ),
                      ScheduleIcon(model)
                    ],
                  ),
                  model.fileName != null
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Row(
                            children: [
                              Icon(Icons.folder),
                              Padding(padding: EdgeInsets.only(right: 5.0)),
                              Text(
                                model.fileName! +
                                    " (" +
                                    (model.recordSize! / 1024 / 1024)
                                        .toStringAsFixed(2) +
                                    "MB)",
                                style: TextStyle(
                                  fontSize: 18.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: model.channelName != null
                        ? Text(
                            model.channelName!,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : SizedBox.shrink(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      model.start != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  model.start != null
                                      ? DateFormat("dd.MM.yyyy")
                                          .format(model.start!)
                                      : "",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    // Icon(Icons.access_time_filled),
                                    // Padding(padding: EdgeInsets.only(right: 5.0)),
                                    Text(
                                      model.start != null && model.stop != null
                                          ? DateFormat.Hm()
                                                  .format(model.start!) +
                                              " - " +
                                              DateFormat.Hm()
                                                  .format(model.stop!)
                                          : "",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                      FavoriteIcon(model)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
