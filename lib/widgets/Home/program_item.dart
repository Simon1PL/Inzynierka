import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/models/program_model.dart';
import 'package:project/widgets/Favorites/favorite_icon.dart';
import 'package:project/widgets/Programs/single_program_info.dart';
import 'package:project/widgets/Recordings/schedule_icon.dart';

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

  void refreshProgram() async {
    setState(() {
      model;
    });
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
                      ScheduleIcon(model),
                      FavoriteIcon(model, refreshProgram)
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
