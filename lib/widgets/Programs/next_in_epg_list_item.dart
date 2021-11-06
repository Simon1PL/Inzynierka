import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/models/program_model.dart';
import 'package:project/widgets/Programs/single_program_info.dart';

class NextInEpgListItem extends StatefulWidget {
  final ProgramModel model;
  final ProgramModel modelForChangedInfo;

  NextInEpgListItem(Key key, this.model, this.modelForChangedInfo) : super(key: key);

  @override
  _ProgramListItem createState() => _ProgramListItem(model, modelForChangedInfo);
}

class _ProgramListItem extends State<NextInEpgListItem> {
  final ProgramModel model;
  final ProgramModel modelForChangedInfo;

  _ProgramListItem(this.model, this.modelForChangedInfo);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: GestureDetector(
        onTap: () {
          model.favorite2 = modelForChangedInfo.favorite2;
          model.favorite = modelForChangedInfo.favorite;
          model.recordSize = modelForChangedInfo.recordSize;
          model.fileName = modelForChangedInfo.fileName;
          model.orderId = modelForChangedInfo.orderId;
          model.alreadyScheduled = modelForChangedInfo.alreadyScheduled;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SingleProgram(),
                  settings: RouteSettings(
                    arguments: model,
                  )));
        },
        child: Padding(
          padding:
              EdgeInsets.only(top: 15.0, right: 15.0, left: 15.0, bottom: 4.0),
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
              child: model.start != null
                  ? Wrap(
                alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      model.channelName != null
                          ? Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Text(
                        model.channelName!,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                        ),
                      ),
                          )
                          : SizedBox.shrink(),
                      Column(
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
            ),
          ),
        ),
      ),
    );
  }
}
