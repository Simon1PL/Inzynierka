import 'package:http/http.dart';
import 'dart:convert';

String url = "https://damp-springs-89170.herokuapp.com";

class Program {
  String channelName;
  String channelId;
  DateTime start;
  DateTime stop;
  String title;
  String? subtitle;
  String? summary;
  String? description;
  bool favorite;
  bool alreadySaved;

  Program(this.channelName, int start, int stop, this.title, this.subtitle,
      this.summary, this.description, this.channelId, this.alreadySaved, this.favorite)
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
    List<Program> programs = objects.map((e) => Program(e["channelName"], e["start"], e["stop"], e["title"], e["subtitle"], e["summary"], e["description"], e["channelUuid"], false, false)).toList();
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
    List<Program> programs = objects.map((e) => Program(e["channelName"], e["start"], e["stop"], e["title"], e["subtitle"], e["summary"], e["description"], e["channelUuid"], e["alreadySaved"], e["favorite"])).toList();
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
    var body = jsonEncode([{"channelUuid": program.channelId, "start": program.start.millisecondsSinceEpoch/1000, "stop": program.stop.millisecondsSinceEpoch/1000, "channelName": program.channelName, "title": program.title, "subtitle": program.subtitle, "summary": program.summary, "description": program.description, "favorite": program.favorite, "alreadySaved": program.alreadySaved}]);
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
