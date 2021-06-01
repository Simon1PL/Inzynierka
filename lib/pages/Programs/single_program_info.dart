import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projekt/services/alert_service.dart';
import 'package:projekt/services/tuner_service.dart';
import 'package:projekt/widgets/app_bar.dart';
import 'package:projekt/widgets/menu.dart';

class SingleProgram extends StatefulWidget {
  static const String routeName = '/programs/program_info';

  @override
  _SingleProgram createState() =>  _SingleProgram();
}

class _SingleProgram extends State<SingleProgram> {

  @override
  Widget build(BuildContext context) {
    final Program program = ModalRoute.of(context)!.settings.arguments as Program;

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
                  padding: EdgeInsets.only(left: 40/*it has to be equal to favorite icon size + right padding to be in center*/, right: 10, bottom: 12.0),
                  child: Text(
                    program.title,
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
          Text(program.subtitle,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(program.description,
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(program.channelName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      DateFormat("dd.MM.yyyy HH:mm").format(program.start) + " - " + DateFormat.Hm().format(program.stop),
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
                  if (program.alreadySaved) return;
                  bool result = await postOrder(1, program);
                  if (result) {
                    setState(() {
                      program.alreadySaved = true;
                    });
                  }
                  else {
                    showAlertDialog(context, title: "Error", text: "Can not schedule the program");
                  }
                },
                child: Icon(
                  program.alreadySaved ? Icons.alarm_off : Icons.alarm,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Menu(
          currentIndex: 1
      ),
    );
  }
}