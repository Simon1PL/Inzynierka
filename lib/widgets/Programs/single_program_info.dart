import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/enums/favorite_type.dart';
import 'package:project/models/program_model.dart';
import 'package:project/services/favorite_service.dart';
import 'package:project/services/programs_service.dart';
import 'package:project/widgets/Shared/app_bar.dart';
import 'package:project/widgets/Shared/menu.dart';

class SingleProgram extends StatefulWidget {
  static const String routeName = '/programs/program_info';

  @override
  _SingleProgram createState() => _SingleProgram();
}

class _SingleProgram extends State<SingleProgram> {
  @override
  Widget build(BuildContext context) {
    ProgramModel program =
        ModalRoute.of(context)!.settings.arguments as ProgramModel;

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
            child: SizedBox.expand(
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
                      GestureDetector(
                        onTap: () async {
                          if (!program.favorite) {
                            var res = await addFavorite(program.title ?? "");
                            if (res == FavoriteType.EPISODE)
                              setState(() {
                                program.favorite = true;
                              });
                            else if (res == FavoriteType.TITLE) {
                              setState(() {
                                program.favorite2 = true;
                              });
                            }
                          } else {
                            if (await removeFavorite(program.title ?? ""))
                              setState(() {
                                program.favorite = false;
                              });
                          }
                        },
                        child: Icon(
                          program.favorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 30,
                          color: program.favorite ? Colors.blue : Colors.black,
                        ),
                      ),
                    ],
                  ),
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
                  program.summary == null || program.summary == program.subtitle
                      ? SizedBox.shrink()
                      : Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text(
                            "Summary: " + program.summary!,
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                      ),
                  program.genre.length > 0
                      ? Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                        child: Text(
                            "Genre: " + program.genre.join(", "),
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                      )
                      : SizedBox.shrink(),
                  program.fileName != null
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Row(
                            children: [
                              Text(
                                "Downloaded file: ",
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              Icon(Icons.folder),
                              Text(
                                program.fileName! +
                                    " (" +
                                    (program.recordSize! / 1024 / 1024)
                                        .toStringAsFixed(2) +
                                    "MB)",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text(
                          "Description: " +
                              (program.description == null
                                  ? "Sorry, we have no description for this program"
                                  : program.description!),
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Text(
                      "Channel: " +
                          (program.channelName != null
                              ? program.channelName!
                              : "") +
                          (program.channelNumber != null
                              ? " (" + program.channelNumber! + ")"
                              : "-"),
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Text(
                      "Date: " +
                          (program.start != null && program.stop != null
                              ? DateFormat("dd.MM.yyyy").format(program.start!)
                              : "-"),
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Row(
                          children: [
                            Icon(Icons.access_time_filled),
                            Padding(padding: EdgeInsets.only(right: 5)),
                            Text(
                              program.start != null && program.stop != null
                                  ? DateFormat.Hm().format(program.start!) +
                                      " - " +
                                      DateFormat.Hm().format(program.stop!)
                                  : "00:00 - 00:00",
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (program.alreadyScheduled &&
                              program.orderId == null) return;

                          if (program.alreadyScheduled &&
                              await removeOrder(program.orderId!, context)) {
                            setState(() {
                              program.alreadyScheduled = false;
                            });
                          } else if (!program.alreadyScheduled &&
                              await postOrder(program, context)) {
                            setState(() {
                              program.alreadyScheduled = true;
                            });
                          }
                        },
                        child: Icon(
                          program.alreadyScheduled
                              ? Icons.alarm_off
                              : Icons.alarm,
                          color: (program.alreadyScheduled &&
                                      program.orderId == null) ||
                                  program.start == null
                              ? Colors.grey
                              : program.alreadyScheduled
                                  ? Colors.blue
                                  : Colors.black,
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
      ),
      bottomNavigationBar: Menu(),
    );
  }
}
