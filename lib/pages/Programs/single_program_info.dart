import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projekt/models/program_model.dart';
import 'package:projekt/services/favorite_service.dart';
import 'package:projekt/services/programs_service.dart';
import 'package:projekt/widgets/app_bar.dart';
import 'package:projekt/widgets/menu.dart';

class SingleProgram extends StatefulWidget {
  static const String routeName = '/programs/program_info';

  @override
  _SingleProgram createState() => _SingleProgram();
}

class _SingleProgram extends State<SingleProgram> {
  @override
  Widget build(BuildContext context) {
    final ProgramModel program =
        ModalRoute.of(context)!.settings.arguments as ProgramModel;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: MyAppBar(
        text: "",
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    program.title != null ? program.title! : "No title!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  !program.favorite
                      ? addFavorite(program.title ?? "")
                      : removeFavorite(program.title ?? "");
                  setState(() {
                    program.favorite = !program.favorite;
                  });
                },
                child: Icon(
                  program.favorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ],
          ),
          Text(
            program.subtitle == null ? "" : program.subtitle!,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              height: 200,
              child: Text(
                program.description == null
                    ? "sorry, we have no description for this program"
                    : program.description!,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      program.channelName != null ? program.channelName! : "",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      program.start != null && program.stop != null
                          ? DateFormat("dd.MM.yyyy HH:mm")
                                  .format(program.start!) +
                              " - " +
                              DateFormat.Hm().format(program.stop!)
                          : "",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (program.alreadyScheduled && program.orderId == null)
                    return;

                  !program.alreadyScheduled
                      ? await postOrder(program, context)
                      : removeOrder(program.orderId!, context);

                  setState(() {
                    program.alreadyScheduled = !program.alreadyScheduled;
                  });
                },
                child: Icon(
                  program.alreadyScheduled ? Icons.alarm_off : Icons.alarm,
                  color: program.alreadyScheduled && program.orderId == null
                      ? Colors.grey
                      : Colors.black,
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Menu(),
    );
  }
}
