import 'package:flutter/material.dart';
import 'package:projekt/services/globals.dart';

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
