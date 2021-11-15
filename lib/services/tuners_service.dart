import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:project/enums/user_role_for_tuner.dart';
import 'package:project/models/tuner_model.dart';
import 'package:project/models/tuner_user_model.dart';
import 'package:project/services/alert_service.dart';
import 'package:project/services/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<TunerModel>> get tuners async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getStringList("tuners")?.map((e) => TunerModel.fromJson(jsonDecode(e))).toList() ?? [];
}

Future<List<TunerModel>> get acceptedTuners async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getStringList("tuners")?.map((e) => TunerModel.fromJson(jsonDecode(e))).where((t) => t.currentUserRole == UserRoleForTuner.USER || t.currentUserRole == UserRoleForTuner.OWNER).toList() ?? [];
}

void removeTuner(tunerId) async { // unused
  SharedPreferences pref = await SharedPreferences.getInstance();
  var tmpTuners = await tuners;
  tmpTuners.removeWhere((t) => t.tunerId == tunerId);
  pref.setStringList("tuners", tmpTuners.map((t) => json.encode(t.toJson())).toList());
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
  pref.remove("tuners");
  pref.remove("selectedTunerId");
}

Future<bool> loadTunersFromServer() async {
  try{
    Response response = await serverGet("tuner/list");
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusCode.toString() + " - " + utf8.decode(response.bodyBytes));
    }

    List<dynamic> objects = response.bodyBytes.isNotEmpty ? jsonDecode(utf8.decode(response.bodyBytes)) : response.bodyBytes;
    List<TunerModel> tuners = objects.map((p) => TunerModel(p[0], p[1].toString(), p[2])).toList();
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList("tuners", tuners.map((t) => json.encode(t.toJson())).toList());
    var accepted = await acceptedTuners;
    accepted.isNotEmpty ? pref.setInt("selectedTunerId", accepted[0].tunerId) : pref.remove("selectedTunerId");
    return true;
  }
  catch (e) {
    print(e);
    return false;
  }
}

Future<List<TunerUserModel>?> getUsersForTuner(int tunerId) async {
  try{
    Response response = await serverGet("tuner/users/list?tuner_id=$tunerId");
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusCode.toString() + " - " + utf8.decode(response.bodyBytes));
    }

    List<dynamic> objects = response.bodyBytes.isNotEmpty ? jsonDecode(utf8.decode(response.bodyBytes)) : response.bodyBytes;
    List<TunerUserModel> users = objects.map((p) => TunerUserModel(p[0], p[1], p[2])).toList();
    return users;
  }
  catch (e) {
    print(e);
    return null;
  }
}

Future<bool> createTuner(String tunerName) async {
  try{
    Response response = await serverPost("tuner/create?tuner_name=$tunerName");
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusCode.toString() + " - " + utf8.decode(response.bodyBytes));
    }
    await loadTunersFromServer();
    return true;
  }
  catch (e) {
    showAlert(title: "Can't create tuner", text: e.toString());
    return false;
  }
}

Future<bool> inviteToTuner(String userName, int tunerId, BuildContext context) async {
  try{
    Response response = await serverPost("tuner/invite/add?user=$userName&tuner_id=$tunerId");
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusCode.toString() + " - " + utf8.decode(response.bodyBytes));
    }

    return true;
  }
  catch (e) {
    if (e.toString().contains("400 -")) showAlert(title: "Can't invite user", text: e.toString());
    else showAlert(title: "Can't invite user", text: "user doesn't exist"/*e.toString()*/);
    return false;
  }
}

Future<bool> acceptTuner(int tunerId) async {
  try{
    Response response = await serverPost("tuner/invite/accept?tuner_id=$tunerId");
    if (response.statusCode != 200 && response.statusCode != 201) {
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
    Response response = await serverPost("tuner/invite/decline?tuner_id=$tunerId");
    if (response.statusCode != 200 && response.statusCode != 201) {
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
    Response response = await serverPost("tuner/users/remove?user=$userName&tuner_id=$tunerId");
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Status code: " + response.statusCode.toString() + "\n" + utf8.decode(response.bodyBytes));
    }

    return true;
  }
  catch (e) {
    print(e);
    return false;
  }
}
