import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projekt/pages/home.dart';
import 'package:projekt/pages/login.dart';
import 'package:projekt/services/globals.dart';
import 'package:projekt/services/tuners_service.dart';
import 'package:projekt/services/alert_service.dart';

Future<void> logIn(BuildContext context, String username, String password) async {
  await setUserCredential(username, password);

  try {
    Response response = await serverGet("login");

    if (response.statusCode != 200) {
      throw Exception("Status code: " + response.statusCode.toString() + "\n" + utf8.decode(response.bodyBytes));
    }

    dynamic responseObject = jsonDecode(utf8.decode(response.bodyBytes));
    if (responseObject["status"]) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool("isLoggedIn", true);
      await getTunersFromServer();
      (await tuners).isEmpty ? Navigator.pushNamedAndRemoveUntil(context, "/tuners", (route) => false) : Navigator.pushNamedAndRemoveUntil(context, Home.routeName, (route) => false);
    }
    else {
      showAlertDialog(context, title: "Login failed", text: "Wrong username or password");
    }
  }
  catch(e) {
    showAlertDialog(context, title: "Error", text: e.toString());
  }
}

Future<void> logOff() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setBool("isLoggedIn", false);
  await setUserCredential("", "");
  await clearTuners();
  navigatorKey.currentState!.pushNamedAndRemoveUntil(Login.routeName, (route) => false);
}

Future<bool> get isLoggedIn async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getBool("isLoggedIn") ?? false;
}

Future<void> register(BuildContext context, String username, String password) async {
  await setUserCredential(username, password);

  try {
    Response response = await serverPost("register");

    if (response.statusCode != 200) {
      throw Exception("Status code: " + response.statusCode.toString() + "\n" + utf8.decode(response.bodyBytes));
    }

    dynamic responseObject = jsonDecode(utf8.decode(response.bodyBytes));
    if (responseObject["status"]) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool("isLoggedIn", true);
      await clearTuners();
      Navigator.pushNamedAndRemoveUntil(context, "/tuners", (route) => false);
    }
    else {
      showAlertDialog(context, title: "Register failed", text: responseObject["text"]);
    }
  }
  catch(e) {
    showAlertDialog(context, title: "Error", text: e.toString());
  }
}