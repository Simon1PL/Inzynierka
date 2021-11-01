import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:projekt/services/alert_service.dart';
import 'dart:convert';
import 'package:projekt/services/globals.dart';

Future<List<String>?> getFavorites() async {
  try{
    Response response = await serverGet("favorites");
    if (response.statusCode != 200) {
      throw Exception("Status code: " + response.statusCode.toString() + "\n" + utf8.decode(response.bodyBytes));
    }

    List<dynamic> objects = response.bodyBytes.isNotEmpty ? jsonDecode(utf8.decode(response.bodyBytes)) : response.bodyBytes;
    List<String> favorites = objects.map((p) => p[0].toString()).toList();
    return favorites;
  }
  catch (e) {
    print(e);
    return null;
  }
}

Future<bool> addFavorite(String favorite, BuildContext context) async {
  try{
    Response response = await serverPost("favorites?name=" + favorite);
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

Future<bool> removeFavorite(String favorite, BuildContext context) async {
  try{
    Response response = await serverDelete("favorites?name=" + favorite);
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
