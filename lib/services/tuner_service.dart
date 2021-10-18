import 'package:http/http.dart';
import 'package:projekt/models/program_model.dart';
import 'dart:convert';
import 'package:projekt/services/globals.dart';

Future<List<ProgramModel>?> getEpg() async {
  try{
    Response response = await get(Uri.parse(url + "/epg?id=" + selectedTunerId.toString()));
    if (response.statusCode != 200) {
      throw Exception("Status code: " + response.statusCode.toString() + "\n" + utf8.decode(response.bodyBytes));
    }
    List<dynamic> objects = jsonDecode(utf8.decode(response.bodyBytes));
    List<ProgramModel> programs = objects.map((p) => ProgramModel(p["channelName"], p["channelUuid"], p["start"], p["stop"], p["title"], p["subtitle"], p["summary"], p["description"], p["recordSize"], p["fileName"], p["favorite"], p["alreadyScheduled"])).toList();
    return programs;
  }
  catch (e) {
    print(e);
    return null;
  }
}

Future<List<ProgramModel>> getScheduled() async {
  try{
    Response response = await get(Uri.parse(url + "/orders?id=" + selectedTunerId.toString()));
    if (response.statusCode != 200) {
      throw Exception("Status code: " + response.statusCode.toString() + "\n" + utf8.decode(response.bodyBytes));
    }
    List<dynamic> objects = jsonDecode(utf8.decode(response.bodyBytes));
    List<ProgramModel> programs = objects.map((p) => ProgramModel(p["channelName"], p["channelUuid"], p["start"], p["stop"], p["title"], p["subtitle"], p["summary"], p["description"], p["recordSize"], p["fileName"], p["favorite"], true)).toList();
    return programs;
  }
  catch (e) {
    print(e);
    return [];
  }
}

Future<List<ProgramModel>> getRecorded() async {
  try{
    Response response = await get(Uri.parse(url + "/recorded?id=" + selectedTunerId.toString()));
    if (response.statusCode != 200) {
      throw Exception("Status code: " + response.statusCode.toString() + "\n" + utf8.decode(response.bodyBytes));
    }
    List<dynamic> objects = jsonDecode(utf8.decode(response.bodyBytes));
    List<ProgramModel> programs = objects.map((p) => ProgramModel(p["channelName"], p["channelUuid"], p["start"], p["stop"], p["program_name"], p["subtitle"], p["summary"], p["description"], p["recordSize"], p["program_name"], p["favorite"], true)).toList();
    return programs;
  }
  catch (e) {
    print(e);
    return [];
  }
}

Future<bool> postOrder(ProgramModel program) async {
  try{
    Uri uri = Uri.parse(url + "/orders?id=" + selectedTunerId.toString());
    var body = jsonEncode([{"channel_id": program.channelId, "start": program.start!.millisecondsSinceEpoch/1000, "end": program.stop!.millisecondsSinceEpoch/1000}]);
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
