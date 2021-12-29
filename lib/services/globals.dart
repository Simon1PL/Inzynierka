library globals;

import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:project/services/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// String URL = "http://localhost:5000";
const String DEFAULT_URL = "https://damp-springs-89170.herokuapp.com/";

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

String? activeTab;

Future<String> getServerUrl() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString("serverUrl") != null ? pref.getString("serverUrl")! : DEFAULT_URL;
}

Future<void> setServerUrl(String url) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.setString("serverUrl", url);
}

Future<void> setUserCredential(String username, String password) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString(
      "basicAuth", 'Basic ' + base64Encode(utf8.encode('$username:$password')));
  pref.setString("username", username);
}

Future<String> get _basicAuth async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString("basicAuth")!;
}

Future<String> get username async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString("username")!;
}

Future<Response> serverPost(String endpoint, [String body = ""]) async {
  Uri uri = Uri.parse(await getServerUrl() + '/$endpoint');
  var result = await post(uri,
      headers: <String, String>{'authorization': await _basicAuth}, body: body);
  if (result.statusCode == 401) {
    logOff();
  }
  return result;
}

Future<Response> serverDelete(String endpoint, [String body = ""]) async {
  Uri uri = Uri.parse(await getServerUrl() + '/$endpoint');
  var result = await delete(uri,
      headers: <String, String>{'authorization': await _basicAuth}, body: body);
  if (result.statusCode == 401) {
    logOff();
  }
  return result;
}

dynamic serverGet(String endpoint) async {
  Uri uri = Uri.parse(await getServerUrl() + '/$endpoint');
  print(uri);
  var result = await get(uri,
      headers: <String, String>{'authorization': await _basicAuth});
  if (result.statusCode == 401) {
    logOff();
  }
  return result;
}
