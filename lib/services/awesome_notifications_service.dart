import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

initAwesomeNotifications() {
  AwesomeNotifications().initialize(
      'resource://drawable/app_icon',
      [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel',
            channelShowBadge: true, // shows number on application icon, nope, donno what it does
            importance: NotificationImportance.High,
            playSound: true,
            // soundSource: src,
            // defaultRingtoneType: DefaultRingtoneType.Alarm, // only for android
            enableVibration: true,
            enableLights: false,
            ledColor: Colors.white,
            ledOnMs: 10, // Determines the time, in milliseconds, that the LED lights must be on	int
            ledOffMs: 10,
            groupKey: "someKey", // Determines the common key used to group notifications in a compact form
            groupSort: GroupSort.Desc,
            groupAlertBehavior: GroupAlertBehavior.All,
            defaultPrivacy: NotificationPrivacy.Private,
            // icon: src,
            defaultColor: Colors.blue,
            locked: false, // Determines if the user cannot manually dismiss the notification
            onlyAlertOnce: false, // Determines if the notification should alert once, when created
            vibrationPattern: lowVibrationPattern,
        ),
      ],
      debug: false
  );

  AwesomeNotifications().actionStream.listen((event) {
    print('event received!');
    print(event.toMap()["payload"]["uuid"]);
    print(event.toMap().toString());
    // do something based on event...
  });
}

createAwesomeNotificationWithButtons() async {
  var scheduleTime = DateTime.now().toUtc().add(const Duration(seconds: 1 ));
  var random = Random();
  var randomId = random.nextInt(16);

  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: randomId,
        channelKey: 'basic_channel',
        title: 'Simple Notification',
        body: 'Simple body',
        ticker: "Hello there",
        // color: ,
        // backgroundColor: ,
        notificationLayout: NotificationLayout.Default,
        // progress: 50, // for notificationLayout == progress
        largeIcon: "https://media.fstatic.com/kdNpUx4VBicwDuRBnhBrNmVsaKU=/full-fit-in/290x478/media/artists/avatar/2013/08/neil-i-armstrong_a39978.jpeg",
        bigPicture: "https://www.dw.com/image/49519617_303.jpg",
        showWhen: true,
        autoDismissable: true,
        summary: "Private",
        payload: {'uuid': 'user-profile-uuid'}),
      actionButtons: [
        /*NotificationActionButton(
            key: 'DISCARD',
            label: 'Discard',
            isDangerousOption: true,
            autoDismissable: true,
            buttonType: ActionButtonType.DisabledAction // this does not work!
        ),*/
        NotificationActionButton(
            key: 'SCHEDULE', // Text key to identifies what action the user took when tapped the notification. Whatever here?
            icon: null,
            label: 'Schedule it',
            //color: 0x0000FF, // label color
            autoDismissable: true, // default true
            enabled: true, // default true, false -> disabled
            showInCompactView: true, // default true, For MediaPlayer notifications on Android, sets the button as visible in compact view
            buttonType: ActionButtonType.Default)
      ],
      schedule: NotificationCalendar.fromDate(date: scheduleTime, allowWhileIdle: true));
}
