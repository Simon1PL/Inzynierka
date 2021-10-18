import 'package:flutter/material.dart';
import 'package:projekt/models/program_model.dart';
import 'package:projekt/services/tuner_service.dart';
import 'package:projekt/widgets/app_bar.dart';
import 'package:projekt/widgets/app_bar_buttons.dart';
import 'package:projekt/widgets/button.dart';
import 'package:projekt/widgets/loading_list.dart';
import 'package:projekt/widgets/menu.dart';

class Recorded extends StatefulWidget {
  @override
  _Recordings createState() => _Recordings();
}

class _Recordings extends State<Recorded> {
  List<ProgramModel>? programs;
  bool dataLoaded = false;

  @override
  void initState() {
    super.initState();
    loadRecorded();
  }

  loadRecorded() async {
    List<ProgramModel> programsTmp = await getRecorded();
    setState(() {
      this.programs = programsTmp;
      this.dataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: MyAppBarWithButtons(
        buttons: [
          MyButton(
            "Recorded",
            true,
          ),
          MyButton("Scheduled", false, () {
            Navigator.pushNamedAndRemoveUntil(
                context, "/recordings/scheduled", (route) => false);
          }),
        ],
      ),
      body: getView(programs, dataLoaded,
          "Something goes wrong, can not load scheduled programs"),
      bottomNavigationBar: Menu(currentIndex: 1),
    );
  }
}
