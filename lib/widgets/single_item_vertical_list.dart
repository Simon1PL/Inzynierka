import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projekt/services/tuner_service.dart';

class SingleItemVerticalList extends StatelessWidget {
  final Program model;
  SingleItemVerticalList(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      alignment: Alignment.topLeft,
      color: Colors.white,
      child:
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Colors.grey),
              )
            ),
            child: Column(
              children: [
                Text(
                  model.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  model.channelName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  DateFormat("dd.MM.yyyy").format(model.start),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  DateFormat.Hm().format(model.start) + " - " + DateFormat.Hm().format(model.stop),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
