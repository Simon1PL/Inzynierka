import 'package:http/http.dart';
import 'dart:convert';
import 'package:projekt/services/alert_service.dart';
import 'package:projekt/services/globals.dart';

Future<List<String>?> getFavorites() async {
  try {
    Response response = await serverGet("favorites");
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Status code: " +
          response.statusCode.toString() +
          "\n" +
          utf8.decode(response.bodyBytes));
    }

    List<dynamic> objects = response.bodyBytes.isNotEmpty
        ? jsonDecode(utf8.decode(response.bodyBytes))
        : response.bodyBytes;
    List<String> favorites = objects.map((p) => p[0].toString()).toList();
    return favorites;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<bool> addFavorite(String favorite) async {
  try {
    Response response = await serverPost("favorites?name=" + favorite);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusCode.toString() +
          " - " +
          utf8.decode(response.bodyBytes));
    }

    return true;
  } catch (e) {
    showAlert(title: "Can't add favorite", text: e.toString());
    return false;
  }
}

Future<bool> removeFavorite(String favorite) async {
  try {
    Response response = await serverDelete("favorites?name=" + favorite);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusCode.toString() +
          " - " +
          utf8.decode(response.bodyBytes));
    }

    return true;
  } catch (e) {
    showAlert(title: "Can't remove favorite", text: e.toString());
    return false;
  }
}
