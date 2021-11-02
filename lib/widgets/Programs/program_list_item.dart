import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/models/program_model.dart';
import 'package:project/widgets/Programs/single_program_info.dart';
import 'package:project/services/favorite_service.dart';
import 'package:project/services/programs_service.dart';

class ProgramListItem extends StatefulWidget {
  final ProgramModel model;

  ProgramListItem(Key key, this.model) : super(key: key);

  @override
  _ProgramListItem createState() =>  _ProgramListItem(model);
}

class _ProgramListItem extends State<ProgramListItem> {
  final ProgramModel model;
  _ProgramListItem(this.model);

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
                          model.title != null ? model.title! : "",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (model.alreadyScheduled && model.orderId == null) return;

                        if (model.alreadyScheduled && await removeOrder(model.orderId!, context)) {
                          setState(() {
                            model.alreadyScheduled = false;
                          });
                        }
                        else if (!model.alreadyScheduled && await postOrder(model, context)) {
                          setState(() {
                            model.alreadyScheduled = true;
                          });
                        }
                      },
                      child: Icon(
                        model.alreadyScheduled ? Icons.alarm_off : Icons.alarm,
                        color: model.alreadyScheduled && model.orderId == null ? Colors.grey : Colors.black,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    model.channelName != null ? model.channelName! : "",
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
                          model.start != null ? DateFormat("dd.MM.yyyy").format(model.start!) : "",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          model.start != null && model.stop != null ? DateFormat.Hm().format(model.start!) + " - " + DateFormat.Hm().format(model.stop!) : "",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        !model.favorite ? addFavorite(model.title ?? "") : removeFavorite(model.title ?? "");
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
