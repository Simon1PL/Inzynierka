import 'package:flutter/material.dart';
import 'package:project/services/globals.dart';
import 'package:project/widgets/Shared/loader.dart';

showSnackBar(String text) {
  ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(SnackBar(
    content: Text(text),
    action: SnackBarAction(
      label: 'Close',
      onPressed: () {
        ScaffoldMessenger.of(navigatorKey.currentContext!).clearSnackBars();
      },
    ),
  ));
}

showAlert({String title = "Alert", String text = "Sth goes wrong"}) {
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(navigatorKey.currentContext!).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(text),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: navigatorKey.currentContext!,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showLoadingDataFromServerAlert(String title) {
  AlertDialog alert = AlertDialog(
    title: Text(title, textAlign: TextAlign.center,),
    content: Container(width: 50, height: 50, child: Loader()),
  );

  showDialog(
    context: navigatorKey.currentContext!,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
