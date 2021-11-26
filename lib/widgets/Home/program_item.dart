import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/enums/favorite_type.dart';
import 'package:project/models/program_model.dart';
import 'package:project/services/alert_service.dart';
import 'package:project/services/db_service.dart';
import 'package:project/widgets/Programs/single_program_info.dart';
import 'package:project/services/favorite_service.dart';
import 'package:project/services/programs_service.dart';

class ProgramHomeItem extends StatefulWidget {
  final ProgramModel model;

  ProgramHomeItem(Key key, this.model) : super(key: key);

  @override
  _ProgramHomeItem createState() => _ProgramHomeItem(model);
}

class _ProgramHomeItem extends State<ProgramHomeItem> {
  final ProgramModel model;
  _ProgramHomeItem(this.model);

  String getWeekday(int weekday) {
    switch(weekday){
      case 1: return "Monday";
      case 2: return "Tuesday";
      case 3: return "Wednesday";
      case 4: return "Thursday";
      case 5: return "Friday";
      case 6: return "Saturday";
      case 7: return "Sunday";
      default: return "";
    }
  }

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
              EdgeInsets.all(6.0),
          child: Container(
            width: 155,
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
              padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(model.title!, textAlign: TextAlign.center, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (model.alreadyScheduled && model.orderId == null) {
                            showSnackBar("Can't remove order, program is saved on disc");
                            return;
                          }

                          if (model.alreadyScheduled) {
                            setState(() {
                              model.alreadyScheduled = false;
                            });
                            updateProgram(model);
                            if (!await removeOrder(model.orderId!, context)) {
                              setState(() {
                                model.alreadyScheduled = true;
                              });
                              updateProgram(model);
                            }
                          }
                          else {
                            setState(() {
                              model.alreadyScheduled = true;
                            });
                            updateProgram(model);
                            if (!await postOrder(model, context)) {
                              setState(() {
                                model.alreadyScheduled = false;
                              });
                              updateProgram(model);
                            }
                          }
                        },
                        child: Icon(
                          model.alreadyScheduled
                              ? Icons.alarm_off
                              : Icons.alarm,
                          color: (model.alreadyScheduled &&
                                      model.orderId == null) ||
                                  model.start == null
                              ? Colors.grey
                              : model.alreadyScheduled
                                  ? Colors.blue
                                  : Colors.black,
                          size: 30,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (!model.favorite) {
                            var res = await addFavorite(model.title ?? "");
                            if (res == FavoriteType.EPISODE) {
                              setState(() {
                                model.favorite = true;
                              });
                              updateProgram(model);
                            }
                            else if (res == FavoriteType.TITLE) {
                              setState(() {
                                model.favorite2 = true;
                              });
                              updateProgram(model);
                            }
                          } else {
                            if (await removeFavorite(model.title ?? "")) {
                              setState(() {
                                model.favorite = false;
                              });
                              updateProgram(model);
                            }
                          }
                        },
                        child: Icon(
                          model.favorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 30,
                          color: model.favorite ? Colors.blue : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                              Text(
                                model.start != null
                                    ? DateFormat("dd.MM").format(model.start!) : "",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                model.start != null && model.stop != null
                                    ? (getWeekday(model.start!.weekday) + " " + DateFormat.Hm().format(model.start!)) : "",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
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
