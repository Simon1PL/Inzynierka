import 'package:flutter/material.dart';
import 'package:project/models/program_model.dart';
import 'package:project/services/db_service.dart';
import 'package:project/widgets/Home/recording_item.dart';
import 'package:project/widgets/Shared/loader.dart';

class RecordingList extends StatefulWidget {

  RecordingList();

  @override
  _RecordingList createState() => _RecordingList();
}

class _RecordingList extends State<RecordingList> {
  _RecordingList();

  Future<List<ProgramModel>> loadRecording() async {
    var result = await getScheduled();
    result.sort((a,b) => a.start!.compareTo(b.start!));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<ProgramModel>>(
        future: loadRecording(),
        builder: (BuildContext context, AsyncSnapshot<List<ProgramModel>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Loader(),
            );
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return Expanded(
                  child: ListView.builder(
                      primary: false,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return RecordingHomeItem(ValueKey(snapshot.data![index]), snapshot.data![index]);
                      }),
                );
          }
        },
      ),
    );
  }
}
