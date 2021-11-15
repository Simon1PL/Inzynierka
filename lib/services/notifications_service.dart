import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project/models/program_model.dart';
import 'package:project/services/favorite_service.dart';
import 'package:project/services/globals.dart';
import 'package:project/services/login_service.dart';
import 'package:project/services/programs_service.dart';
import 'package:project/widgets/Programs/single_program_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  //Singleton pattern
  static final NotificationService _notificationService = NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();

  //instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationDetails platformChannelSpecifics = NotificationDetails(android: AndroidNotificationDetails(
    'channel ID',
    'Basic notifications',
    channelDescription: 'Notification channel',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  ), iOS: IOSNotificationDetails());

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (
            int id,
            String? title,
            String? body,
            String? payload,
            ) async {
              // Some code
        });

    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (payload) async { onNotificationClick(payload); });

    tz.initializeTimeZones();
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> showNotification(String? title, String? body, String? payload) async {
    var randomId = new Random().nextInt(16);

    await flutterLocalNotificationsPlugin.show(
      randomId,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> scheduleNotification(String? title, String? body, String? payload, DateTime scheduledDate) async {
    var randomId = new Random().nextInt(16);
    await flutterLocalNotificationsPlugin.zonedSchedule(randomId, title, body, tz.TZDateTime.now(tz.local).add(scheduledDate.difference(DateTime.now())), platformChannelSpecifics, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, androidAllowWhileIdle: true, payload: payload);
  }

  Future<void> onNotificationClick(String? payload) async {
    if(payload != null) {
      var json = jsonDecode(payload);
      var value = ProgramModel.fromJson(jsonDecode(json["value"]));
      var type = json["type"];
      if (type == "singleProgram") {
        Navigator.of(navigatorKey.currentContext!).push(MaterialPageRoute(
            builder: (context) => SingleProgram(),
            settings: RouteSettings(
              arguments: value,
            )));
      }
    }
  }

  Future<void> scheduleProgramNotifications() async {
    if (!await isLoggedIn) return;
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? lastDate = pref.getInt("lastNotificationSetDate");
    if (lastDate == null) lastDate = DateTime.now().microsecondsSinceEpoch;
    DateTime dateFrom = DateTime.fromMicrosecondsSinceEpoch(max(lastDate, DateTime.now().microsecondsSinceEpoch));
    pref.setInt("lastNotificationSetDate", DateTime.now().microsecondsSinceEpoch);
    DateTime dateTo = DateTime.fromMicrosecondsSinceEpoch(DateTime.now().add(Duration(days: 2)).microsecondsSinceEpoch);
    var programs = await getEpg() ?? [];
    programs = programs.where((p) => p.start!.isAfter(dateFrom) && p.stop!.isBefore(dateTo)).toList();
    var favorites = await getFavorites();
    var favTitles = favorites[1] ?? [];
    var favEpisodes = favorites[0] ?? [];
    var recordedOrScheduled = await getRecorded() ?? [];
    recordedOrScheduled.addAll(await getScheduled() ?? []);
    var notScheduled = programs.where((e) => !recordedOrScheduled.contains(e.title)).toList();
    notScheduled.shuffle();
    var liked = notScheduled.where((e) => favTitles.any((favTitle) => favTitle.contains(e.title!)) || favEpisodes.contains(e.title)).toList();
    liked.shuffle();
    if (liked.length > 0) {
      for(var i = 0; i < min(10, liked.length); i++) {
        var program = liked[i];
        DateTime notificationDate = program.start!.add(Duration(hours: -10)).isAfter(DateTime.now()) ? program.start!.add(Duration(hours: -10)) : DateTime.now().add(Duration(minutes: 15));
        scheduleNotification(program.title!, "It will be on TV on " + program.start.toString(), jsonEncode(program), notificationDate);
      }
    }
    else {
      for (var i = 0; i < min(2, notScheduled.length); i++) {
        var program = notScheduled[i];
        DateTime notificationDate = program.start!
            .add(Duration(hours: -10))
            .isAfter(DateTime.now())
            ? program.start!.add(Duration(hours: -10))
            : DateTime.now().add(Duration(minutes: 15));
        scheduleNotification(
            program.title!, "It will be on TV on " + program.start.toString(), jsonEncode({ "value": jsonEncode(program), "type": "singleProgram" }), notificationDate);
      }
    }
  }

  cancelAll() async {
    flutterLocalNotificationsPlugin.cancelAll();
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("lastNotificationSetDate");
  }
}
