import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:projekt/enums/login_result.dart';
import 'package:projekt/pages/home.dart';
import 'package:projekt/services/globals.dart';
import 'dart:convert';
import 'alert_service.dart';

Future<bool> login(BuildContext context, String _username, String _password) async {
  tunerIds = [1];
  selectedTunerId = tunerIds[0];
  username = _username;
  password = _password;
  Navigator.pushNamedAndRemoveUntil(context, Home.routeName, (route) => false);
  return true;
  try{
    Uri uri = Uri.parse(url + "/login");
    var body = jsonEncode([{"username": _username, "password": _password}]);
    Response response = await post(uri, body: body);
    if (response.statusCode != 200) {
      throw Exception("Status code: " + response.statusCode.toString() + "\n" + utf8.decode(response.bodyBytes));
    }
    dynamic responseObject = jsonDecode(utf8.decode(response.bodyBytes));
    if (responseObject.status == LoginResult.LoginSuccess.index) {
      username = _username;
      password = _password;
      tunerIds = responseObject.tunerIds;
      if (tunerIds.length == 0) {
        Navigator.pushNamedAndRemoveUntil(context, "/tuners/add", (route) => false);
      }
      selectedTunerId = tunerIds[0];
      Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
      return true;
    }
  }
  catch (e) {
    showAlertDialog(context, title: "Login error", text: e.toString());
  }
  return false;
}
