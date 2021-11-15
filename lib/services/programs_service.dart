import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:project/models/program_model.dart';
import 'package:project/services/globals.dart';
import 'package:project/services/tuners_service.dart';

import 'alert_service.dart';

Future<List<ProgramModel>?> getEpg() async {
  try {
    Response response =
        await serverGet("epg?id=" + (await selectedTunerId).toString());
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusCode.toString() +
          " - " +
          utf8.decode(response.bodyBytes));
    }

    List<dynamic> objects = response.bodyBytes.isNotEmpty
        ? jsonDecode(utf8.decode(response.bodyBytes))
        : response.bodyBytes;
    List<ProgramModel> programs = objects
        .map((p) => ProgramModel(
            channelName: p["channel_name"],
            channelId: p["channel_uuid"],
            start: p["start"],
            stop: p["stop"],
            title: p["title"],
            subtitle: p["subtitle"],
            summary: p["summary"],
            description: p["description"],
            genreInt: p["genre"] == null ? [] : p["genre"].cast<int>(),
            channelNumber: p["channel_number"]))
        .toList();
    return programs;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<List<ProgramModel>?> getScheduled() async {
  try {
    Response response =
        await serverGet("orders?id=" + (await selectedTunerId).toString());
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusCode.toString() +
          " - " +
          utf8.decode(response.bodyBytes));
    }

    List<dynamic> objects = response.bodyBytes.isNotEmpty
        ? jsonDecode(utf8.decode(response.bodyBytes))
        : response.bodyBytes;
    List<ProgramModel> programs = objects
        .map((p) => ProgramModel(
            channelName: p["channel_name"],
            channelId: p["channel_id"],
            start: p["start"],
            stop: p["stop"],
            title: p["title"],
            subtitle: p["subtitle"],
            summary: p["summary"],
            description: p["description"],
            recordSize: p["record_size"],
            fileName: p["file_name"],
            alreadyScheduled: true,
            orderId: p["order_id"],
            genreInt: p["genres"] == null ? [] : p["genres"].cast<int>(),
            channelNumber: p["channel_number"].toString()))
        .toList();
    return programs;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<List<ProgramModel>?> getRecorded() async {
  try {
    Response response =
        await serverGet("recorded?id=" + (await selectedTunerId).toString());
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusCode.toString() +
          " - " +
          utf8.decode(response.bodyBytes));
    }

    List<dynamic> objects = [];
    try {
      objects = response.bodyBytes.isNotEmpty
          ? jsonDecode(utf8.decode(response.bodyBytes))
          : response.bodyBytes;
    } catch (e) {
      dynamic object = response.bodyBytes.isNotEmpty
          ? jsonDecode(utf8.decode(response.bodyBytes))
          : response.bodyBytes;
      objects = [object];
    }
    List<ProgramModel> programs = objects
        .map((p) => ProgramModel(
            channelName: p["channel_name"],
            channelId: p["channel_uuid"],
            start: p["start"],
            stop: p["stop"],
            title: p["title"],
            subtitle: p["subtitle"],
            summary: p["summary"],
            description: p["description"],
            recordSize: p["record_size"],
            fileName: p["file_name"],
            alreadyScheduled: true,
            orderId: null /*, p["order_id"]*/,
            genreInt: p["genres"] == null ? [] : p["genres"].cast<int>(),
            channelNumber: p["channel_number"].toString()))
        .toList();
    return programs;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<bool> postOrder(ProgramModel program, BuildContext context) async {
  try {
    if (program.start == null) {
      showSnackBar("There is no " + program.title! + " in current epg");
      return false;
    }
    var body = jsonEncode([
      {
        "channel_id": program.channelId,
        "start": program.start!.millisecondsSinceEpoch / 1000,
        "stop": program.stop!.millisecondsSinceEpoch / 1000
      }
    ]);
    Response response = await serverPost(
        "orders?id=" + (await selectedTunerId).toString(), body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusCode.toString() +
          " - " +
          utf8.decode(response.bodyBytes));
    }
    dynamic object = response.bodyBytes.isNotEmpty
        ? jsonDecode(utf8.decode(response.bodyBytes))
        : response.bodyBytes;
    program.orderId = object["ids"][0];
    return true;
  } catch (e) {
    showAlert(title: "Can't schedule program", text: e.toString());
    return false;
  }
}

Future<bool> removeOrder(int orderId, BuildContext context) async {
  try {
    Response response = await serverDelete("orders?tuner_id=" +
        (await selectedTunerId).toString() +
        "&order_id=" +
        orderId.toString());
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusCode.toString() +
          " - " +
          utf8.decode(response.bodyBytes));
    }

    return true;
  } catch (e) {
    showAlert(title: "Error", text: e.toString());
    return false;
  }
}
