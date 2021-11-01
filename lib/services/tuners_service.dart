import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:projekt/models/tuner_model.dart';
import 'package:projekt/models/tuner_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'alert_service.dart';
import 'globals.dart';

Future<List<TunerModel>> get tuners async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getStringList("tuners")?.map((e) => TunerModel.fromJson(jsonDecode(e))).toList() ?? [];
}

Future<int?> get selectedTunerId async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt("selectedTunerId");
}

Future<void> setSelectedTunerId(String? tunerId) async {
  if (tunerId == null) return;
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setInt("selectedTunerId", int.parse(tunerId));
}

Future<void> clearTuners() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setStringList("tuners", []);
  pref.remove("selectedTunerId");
}

Future<bool> getTunersFromServer() async {
  try{
    Response response = await serverGet("tuner/list");
    if (response.statusCode != 200) {
      throw Exception("Status code: " + response.statusCode.toString() + "\n" + utf8.decode(response.bodyBytes));
    }

    List<dynamic> objects = response.bodyBytes.isNotEmpty ? jsonDecode(utf8.decode(response.bodyBytes)) : response.bodyBytes;
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<TunerModel> tuners = objects.map((p) => TunerModel(p[0], p[1].toString())).toList();
    tuners.isNotEmpty ? pref.setInt("selectedTunerId", tuners[0].tunerId) : pref.remove("selectedTunerId");
    pref.setStringList("tuners", tuners.map((t) => json.encode(t.toJson())).toList());
    return true;
  }
  catch (e) {
    print(e);
    return false;
  }
}

Future<List<TunerUserModel>?> getUsersForTuner(int tunerId) async {
  try{
    Response response = await serverGet("tuner/users/list?tuner_id=" + tunerId.toString());
    if (response.statusCode != 200) {
      throw Exception("Status code: " + response.statusCode.toString() + "\n" + utf8.decode(response.bodyBytes));
    }

    List<dynamic> objects = response.bodyBytes.isNotEmpty ? jsonDecode(utf8.decode(response.bodyBytes)) : response.bodyBytes;
    List<TunerUserModel> users = objects.map((p) => TunerUserModel(int.parse(p[0]), p[1], p[2])).toList();
    return users;
  }
  catch (e) {
    print(e);
    return null;
  }
}

Future<bool> createTuner(String tunerName) async {
  try{
    Response response = await serverPost("tuner/create?tuner_name=" + tunerName);
    if (response.statusCode != 200) {
      throw Exception("Status code: " + response.statusCode.toString() + "\n" + utf8.decode(response.bodyBytes));
    }
    await getTunersFromServer();
    return true;
  }
  catch (e) {
    print(e);
    return false;
  }
}

Future<bool> inviteToTuner(String userName, int tunerId, BuildContext context) async {
  try{
    Response response = await serverPost("tuner/invite/add?user=" + userName + "&tuner_id=" + tunerId.toString());
    if (response.statusCode != 200) {
      throw Exception("Status code: " + response.statusCode.toString() + "\n" + utf8.decode(response.bodyBytes));
    }

    return true;
  }
  catch (e) {
    showAlertDialog(context, title: "Error", text: e.toString());
    return false;
  }
}

Future<bool> acceptTuner(int tunerId) async {
  try{
    Response response = await serverPost("tuner/invite/accept?tuner_id=" + tunerId.toString());
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

Future<bool> declineTuner(int tunerId) async {
  try{
    Response response = await serverPost("tuner/invite/decline?tuner_id=" + tunerId.toString());
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

Future<bool> removeUserFromTuner(String userName, int tunerId) async {
  try{
    Response response = await serverPost("tuner/users/remove?user=" + userName + "&tuner_id=" + tunerId.toString());
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
