import 'package:flutter/material.dart';
import 'package:project/models/program_model.dart';
import 'package:project/services/alert_service.dart';
import 'package:project/services/db_service.dart';
import 'package:project/services/programs_service.dart';

class ScheduleIcon extends StatefulWidget {
  final ProgramModel program;

  ScheduleIcon(this.program);

  @override
  _ScheduleIcon createState() => _ScheduleIcon(program);
}

class _ScheduleIcon extends State<ScheduleIcon> {
  final ProgramModel program;

  _ScheduleIcon(this.program);

  @override
  void initState() {
    super.initState();
  }

  void tryRemoveOrder() async {
    if (program.stop!.isBefore(DateTime.now())) {
      showSnackBar("Can't remove order, the program has already ended");
      return;
    }
    if (!await removeOrder(program.orderId!)) {
      setState(() {
        program.alreadyScheduled = true;
      });
    }
    updateProgram(program);
  }

  void tryPostOrder() async {
    if (!await postOrder(program)) {
      setState(() {
        program.alreadyScheduled = false;
      });
    }
    else {
      setState(() {
        program.orderId = program.orderId;
      });
    }
    updateProgram(program);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          program.orderId = program.alreadyScheduled ? program.orderId : -1; // set order id to -1 before getting real order id from BE cause order id == null means program is already recorded
          program.alreadyScheduled = !program.alreadyScheduled;
        });
        if (!program.alreadyScheduled) {
          tryRemoveOrder();
        }
        else {
          tryPostOrder();
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
    );
  }
}
