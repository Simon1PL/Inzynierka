import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/models/program_model.dart';

class RecordingHomeItem extends StatefulWidget {
  final ProgramModel model;

  RecordingHomeItem(Key key, this.model) : super(key: key);

  @override
  _RecordingHomeItem createState() => _RecordingHomeItem(model);
}

class _RecordingHomeItem extends State<RecordingHomeItem> {
  final ProgramModel model;
  _RecordingHomeItem(this.model);

  String getWeekday(int weekday) {
    switch(weekday){
      case 1: return "Mon";
      case 2: return "Tue";
      case 3: return "Wed";
      case 4: return "Thu";
      case 5: return "Fri";
      case 6: return "Sat";
      case 7: return "Sun";
      default: return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(model.title!, overflow: TextOverflow.ellipsis, maxLines: 3, style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),),
              ),
            ),
            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black)),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(DateFormat("dd.MM").format(model.start!) + "\n" + getWeekday(model.start!.weekday) + " " + DateFormat.Hm().format(model.start!), textAlign: TextAlign.center, style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),),
              ),
            ),
            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black)),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(model.start!.isAfter(DateTime.now()) ? "SCHEDULED" : "RECORDING", style: TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    ),),
                    if (!model.start!.isAfter(DateTime.now())) Icon(Icons.fiber_manual_record, color: Colors.red,)
                  ],
                ),
              ),
            ),
            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black)),
          ),
        ),
      ],
    );
  }
}
