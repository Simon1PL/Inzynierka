import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

String url = "localhost:5000";

class Program {
  String channelName;
  DateTime start;
  DateTime stop;
  String title;
  String subtitle;
  String summary;
  String description;

  Program(this.channelName, int start, int stop, this.title, this.subtitle,
      this.summary, this.description)
      :
        this.start = new DateTime.fromMillisecondsSinceEpoch(start * 1000),
        this.stop = new DateTime.fromMillisecondsSinceEpoch(stop * 1000);
}

Future<List<Program>> getEpg(int tunerId) async {
  try{
    Response response = await get(Uri.parse(url + "/epg?id=" + tunerId.toString()));
    List<Program> programs = jsonDecode(response.body) as List<Program>;
    print(programs);
    return programs;
  }
  catch (e) {
    print(e);
    // 'can not get epg';
    return [];
  }
}
