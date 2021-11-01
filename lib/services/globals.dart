library globals;

import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:projekt/services/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _url = "http://localhost:5000";
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

Future<void> setUserCredential(String username, String password) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString("basicAuth", 'Basic ' + base64Encode(utf8.encode('$username:$password')));
}

Future<String> get _basicAuth async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString("basicAuth")!;
}

Future<Response> serverPost(String endpoint, [String body = ""]) async {
  Uri uri = Uri.parse('$_url/$endpoint');
  var result = await post(uri, headers: <String, String>{'authorization': await _basicAuth}, body: body);
  if (result.statusCode == 401) {
    logOff();
  }
  return result;
}

Future<Response> serverDelete(String endpoint, [String body = ""]) async {
  Uri uri = Uri.parse('$_url/$endpoint');
  var result = await delete(uri, headers: <String, String>{'authorization': await _basicAuth}, body: body);
  if (result.statusCode == 401) {
    logOff();
  }
  return result;
}

dynamic serverGet(String endpoint) async {
  Uri uri = Uri.parse('$_url/$endpoint');
  var result = await get(uri, headers: <String, String>{'authorization': await _basicAuth});
  if (result.statusCode == 401) {
    logOff();
  }
  return result;
}
