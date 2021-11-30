import 'package:flutter/material.dart';
import 'package:project/models/program_model.dart';
import 'package:project/services/alert_service.dart';
import 'package:project/services/db_service.dart';
import 'package:project/services/programs_service.dart';
import 'package:project/widgets/Shared/loader.dart';

class ScheduleIcon extends StatefulWidget {
  final ProgramModel program;

  ScheduleIcon(this.program);

  @override
  _ScheduleIcon createState() => _ScheduleIcon(program);
}

class _ScheduleIcon extends State<ScheduleIcon> {
  final ProgramModel program;
  bool loading = false;

  _ScheduleIcon(this.program);

  @override
  void initState() {
    super.initState();
  }

  Future<void> tryRemoveOrder() async {
    if (program.stop!.isBefore(DateTime.now())) {
      showSnackBar("Can't remove order, the program has already ended");
      return;
    }
    if (await removeOrder(program.orderId!)) {
      setState(() {
        program.alreadyScheduled = false;
      });
      await updateProgram(program);
    }
  }

  Future<void> tryPostOrder() async {
    if (await postOrder(program)) {
      setState(() {
        program.alreadyScheduled = true;
        program.orderId = program.orderId;
      });
      await updateProgram(program);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DbService().lastProgramsDbModificationDate = DateTime.now().millisecondsSinceEpoch;
        setState(() {
          loading = true;
        });
        if (program.alreadyScheduled) {
          await tryRemoveOrder();
        }
        else {
          await tryPostOrder();
        }
        setState(() {
          loading = false;
        });
      },
      child: loading ? Loader(30) : Icon(
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
