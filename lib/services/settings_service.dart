import 'dart:convert';
import 'package:http/http.dart';
import 'package:project/models/settings_model.dart';
import 'package:project/services/alert_service.dart';
import 'package:project/services/globals.dart';
import 'package:project/services/tuners_service.dart';

Future<SettingsModel?> loadSettings() async {
  try {
    SettingsModel settings = new SettingsModel();
    var tunerId = await selectedTunerId;

    settings.freeSpace = await getFreeSpace();

    var response = await serverGet("settings?id=$tunerId");
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusCode.toString() + " - " +
          utf8.decode(response.bodyBytes));
    }

    var object = response.bodyBytes.isNotEmpty ? jsonDecode(utf8.decode(response.bodyBytes)) : response.bodyBytes;
    settings.recordingLocation = object["recording_location"];
    settings.tvhUsername = object["tvh_username"];
    return settings;
  }
  catch (e) {
    print(e);
    return null;
  }
}

Future<bool> saveSettings(SettingsModel settings) async{
  showSnackBar("Not implemented yet");
  throw new UnimplementedError();
}

Future<int?> getFreeSpace() async {
  try {
    var tunerId = await selectedTunerId;
    Response response = await serverGet("status?id=$tunerId");

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusCode.toString() + " - " +
          utf8.decode(response.bodyBytes));
    }

    dynamic object = response.bodyBytes.isNotEmpty ? jsonDecode(
        utf8.decode(response.bodyBytes)) : response.bodyBytes;
    return object["free_space"];
  }
  catch (e) {
    print(e);
    return null;
  }
}