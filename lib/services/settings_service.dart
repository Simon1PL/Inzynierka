import 'dart:convert';
import 'package:http/http.dart';
import 'package:project/models/settings_model.dart';
import 'package:project/services/alert_service.dart';
import 'package:project/services/globals.dart';
import 'package:project/services/tuners_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SettingsModel?> loadSettings() async {
  try {
    SettingsModel settings = new SettingsModel();
    var tunerId = await selectedTunerId;

    var response = await serverGet("settings?id=$tunerId");
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusCode.toString() + " - " +
          utf8.decode(response.bodyBytes));
    }

    var object = response.bodyBytes.isNotEmpty ? jsonDecode(utf8.decode(response.bodyBytes)) : response.bodyBytes;
    settings.recordingLocation = object["recording_location"];
    settings.tvhUsername = object["tvh_username"];
    settings.freeSpace = object["free_space"];
    if (settings.freeSpace != null) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setInt("freeSpace", settings.freeSpace!);
    }
    return settings;
  }
  catch (e) {
    print(e);
    return null;
  }
}

Future<bool> saveSettings(SettingsModel settings) async{
  try {
    if (!settings.recordingLocation.endsWith("/")) {
      settings.recordingLocation += "/";
    }

    var body = jsonEncode({
      "free_space": null,
      "recording_location": settings.recordingLocation,
      "tvh_username": settings.tvhUsername,
      "tvh_password": settings.tvhPassword,
    });
    Response response = await serverPost(
        "settings?id=" + (await selectedTunerId).toString(), body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusCode.toString() +
          " - " +
          utf8.decode(response.bodyBytes));
    }
    showSnackBar("Settings saved.");
    return false;
  }
  catch (e) {
    showSnackBar("Can't save settings\n" + e.toString());
    return false;
  }
}
