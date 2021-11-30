import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:project/services/notifications_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project/widgets/Home/home.dart';
import 'package:project/widgets/Home/login.dart';
import 'package:project/services/globals.dart';
import 'package:project/services/tuners_service.dart';
import 'package:project/services/alert_service.dart';

Future<void> logIn(String username, String password) async {
  await setUserCredential(username, password);

  try {
    Response response = await serverGet("login");

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusCode.toString() + " - " + utf8.decode(response.bodyBytes));
    }

    dynamic responseObject = jsonDecode(utf8.decode(response.bodyBytes));
    if (responseObject["status"]) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool("isLoggedIn", true);
      await loadTunersFromServer();
      NotificationService().scheduleProgramNotifications();
      (await selectedTunerId) == null ? Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!, "/tuners", (route) => false) : Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!, Home.routeName, (route) => false);
    }
    else {
      showAlert(title: "Login failed", text: "Wrong username or password");
    }
  }
  catch(e) {
    showAlert(title: "Can't login", text: e.toString());
  }
}

Future<void> logOff() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setBool("isLoggedIn", false);
  await setUserCredential("", "");
  await clearTuners();
  navigatorKey.currentState!.pushNamedAndRemoveUntil(Login.routeName, (route) => false);
  NotificationService().cancelAll();
}

Future<bool> get isLoggedIn async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getBool("isLoggedIn") ?? false;
}

Future<void> register(String username, String password) async {
  await setUserCredential(username, password);

  try {
    Response response = await serverPost("register");

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusCode.toString() + " - " + utf8.decode(response.bodyBytes));
    }

    dynamic responseObject = jsonDecode(utf8.decode(response.bodyBytes));
    if (responseObject["status"]) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool("isLoggedIn", true);
      await clearTuners();
      Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!, "/tuners", (route) => false);
    }
    else {
      showAlert(title: "Register failed", text: responseObject["text"]);
    }
  }
  catch(e) {
    showAlert(title: "Can't register", text: e.toString());
  }
}