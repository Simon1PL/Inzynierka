import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projekt/pages/Programs/single_program_info.dart';
import 'package:projekt/services/alert_service.dart';
import 'package:projekt/services/tuner_service.dart';

class SingleItemVerticalList extends StatefulWidget {
  final Program model;

  SingleItemVerticalList(this.model);

  @override
  _SingleItemVerticalList createState() =>  _SingleItemVerticalList(model);
}

class _SingleItemVerticalList extends State<SingleItemVerticalList> {
  final Program model;
  _SingleItemVerticalList(this.model);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => SingleProgram(),
            settings: RouteSettings(
            arguments: model,
            )
          )
        );
      },
      child: Padding(
        padding: EdgeInsets.only(
          top: 15.0,
          right: 15.0,
          left: 15.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
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
                        child: Text(
                          model.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (model.alreadySaved) return;
                        bool result = await postOrder(1, model);
                        if (result) {
                          setState(() {
                            model.alreadySaved = true;
                          });
                        }
                        else {
                          showAlertDialog(context, title: "Error", text: "Can not schedule the program");
                        }
                      },
                      child: Icon(
                        model.alreadySaved ? Icons.alarm_off : Icons.alarm,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    model.channelName,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat("dd.MM.yyyy").format(model.start),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          DateFormat.Hm().format(model.start) + " - " + DateFormat.Hm().format(model.stop),
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          model.favorite = !model.favorite;
                        });
                      },
                      child: Icon(
                        model.favorite ? Icons.favorite : Icons.favorite_border,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
