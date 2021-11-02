import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:project/models/program_model.dart';
import 'package:project/services/globals.dart';
import 'package:project/services/tuners_service.dart';

import 'alert_service.dart';

Future<List<ProgramModel>?> getEpg() async {
  try{
    Response response = await serverGet("epg?id=" + (await selectedTunerId).toString());
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusCode.toString() + " - " + utf8.decode(response.bodyBytes));
    }

    List<dynamic> objects = response.bodyBytes.isNotEmpty ? jsonDecode(utf8.decode(response.bodyBytes)) : response.bodyBytes;
    List<ProgramModel> programs = objects.map((p) => ProgramModel(p["channel_name"], p["channel_uuid"], p["start"], p["stop"], p["title"], p["subtitle"], p["summary"], p["description"], p["recordSize"], p["fileName"], p["favorite"], p["alreadyScheduled"])).toList();
    return programs;
  }
  catch (e) {
    print(e);
    return null;
  }
}

Future<List<ProgramModel>?> getScheduled() async {
  try{
    Response response = await serverGet("orders?id=" + (await selectedTunerId).toString());
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusCode.toString() + " - " + utf8.decode(response.bodyBytes));
    }

    List<dynamic> objects = response.bodyBytes.isNotEmpty ? jsonDecode(utf8.decode(response.bodyBytes)) : response.bodyBytes;
    List<ProgramModel> programs = objects.map((p) => ProgramModel(p["channel_name"], p["channel_id"], p["start"], p["stop"], p["title"], p["subtitle"], p["summary"], p["description"], p["record_size"], p["file_name"], p["favorite"], true, p["order_id"])).toList();
    return programs;
  }
  catch (e) {
    print(e);
    return null;
  }
}

Future<List<ProgramModel>?> getRecorded() async {
  try {
    Response response = await serverGet("recorded?id=" + (await selectedTunerId).toString());
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusCode.toString() + " - " + utf8.decode(response.bodyBytes));
    }

    List<dynamic> objects = [];
    try {
      objects = response.bodyBytes.isNotEmpty ? jsonDecode(utf8.decode(response.bodyBytes)) : response.bodyBytes;
    }
    catch(e) {
      dynamic object = response.bodyBytes.isNotEmpty ? jsonDecode(utf8.decode(response.bodyBytes)) : response.bodyBytes;
      objects = [object];
    }
    List<ProgramModel> programs = objects.map((p) => ProgramModel(p["channel_name"], p["channel_uuid"], p["start"], p["stop"], p["title"], p["subtitle"], p["summary"], p["description"], p["record_size"], p["file_name"], p["favorite"], true/*, p["order_id"]*/)).toList();
    return programs;
  }
  catch (e) {
    print(e);
    return null;
  }
}

Future<bool> postOrder(ProgramModel program, BuildContext context) async {
  try{
    var body = jsonEncode([{"channel_id": program.channelId, "start": program.start!.millisecondsSinceEpoch/1000, "end": program.stop!.millisecondsSinceEpoch/1000}]);
    Response response = await serverPost("orders?id=" + (await selectedTunerId).toString(), body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusCode.toString() + " - " + utf8.decode(response.bodyBytes));
    }
    dynamic object = response.bodyBytes.isNotEmpty ? jsonDecode(utf8.decode(response.bodyBytes)) : response.bodyBytes;
    program.orderId = object["ids"][0];
    return true;
  }
  catch (e) {
    showAlert(title: "Can't schedule program", text: e.toString());
    return false;
  }
}

Future<bool> removeOrder(int orderId, BuildContext context) async {
  try{
    Response response = await serverDelete("orders?tuner_id=" + (await selectedTunerId).toString() + "&order_id=" + orderId.toString());
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusCode.toString() + " - " + utf8.decode(response.bodyBytes));
    }

    return true;
  }
  catch (e) {
    showAlert(title: "Error", text: e.toString());
    return false;
  }
}
