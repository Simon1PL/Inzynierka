import 'package:http/http.dart';
import 'dart:convert';

String url = "http://localhost:5000";

class Program {
  String channelName;
  String channelId;
  DateTime start;
  DateTime stop;
  String title;
  String subtitle;
  String summary;
  String description;
  bool favorite = false;
  bool alreadySaved;

  Program(this.channelName, int start, int stop, this.title, this.subtitle,
      this.summary, this.description, this.channelId, {this.alreadySaved = false})
      :
        this.start = new DateTime.fromMillisecondsSinceEpoch(start * 1000),
        this.stop = new DateTime.fromMillisecondsSinceEpoch(stop * 1000);
}

Future<List<Program>> getEpg(int tunerId) async {
  try{
    Response response = await get(Uri.parse(url + "/epg?id=" + tunerId.toString()));
    if (response.statusCode != 200) {
      throw Exception("Status code: " + response.statusCode.toString() + "\n" + utf8.decode(response.bodyBytes));
    }
    List<dynamic> objects = jsonDecode(utf8.decode(response.bodyBytes));
    List<Program> programs = objects.map((e) => Program(e["channelName"], e["start"], e["stop"], e["title"], e["subtitle"], e["summary"], e["description"], e["channelUuid"])).toList();
    return programs;
  }
  catch (e) {
    print(e);
    return [];
  }
}

Future<List<Program>> getScheduled(int tunerId) async {
  try{
    Response response = await get(Uri.parse(url + "/orders?id=" + tunerId.toString()));
    if (response.statusCode != 200) {
      throw Exception("Status code: " + response.statusCode.toString() + "\n" + utf8.decode(response.bodyBytes));
    }
    List<dynamic> objects = jsonDecode(utf8.decode(response.bodyBytes));
    // CHANGE AFTER ADDED NEW ENDPOINT:
    List<Program> programs = objects.map((e) => Program("channel id" + e["channel_id"], e["start"], e["end"], "title", "subtitle", "summary", "description", "channelUuid", alreadySaved: true)).toList();
    return programs;
  }
  catch (e) {
    print(e);
    return [];
  }
}

Future<bool> postOrder(int tunerId, Program program) async {
  try{
    Uri uri = Uri.parse(url + "/orders?id=" + tunerId.toString());
    // CHANGE AFTER FIX CHANNEL ID IN DB:
    var body = jsonEncode([{"channel_id": 0/*program.channelId*/, "start": program.start.millisecondsSinceEpoch/1000, "end": program.stop.millisecondsSinceEpoch/1000}]);
    Response response = await post(uri, body: body);
    if (response.statusCode != 200) {
      throw Exception("Status code: " + response.statusCode.toString() + "\n" + utf8.decode(response.bodyBytes));
    }
    return true;
  }
  catch (e) {
    print(e);
    return false;
  }
}
