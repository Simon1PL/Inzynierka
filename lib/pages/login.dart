import 'package:flutter/material.dart';
import 'package:projekt/services/login_service.dart';
import 'package:projekt/widgets/app_bar.dart';
import 'package:projekt/widgets/button.dart';

class Login extends StatefulWidget {
  static const String routeName = '/login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: MyAppBar(
        text: "R-M DVB-T Tuner",
      ),
      body: Column(children: [
        MyButton("LOGIN", false, () {
          login(context, "admin", "admin");
        }),
      ]),
    );
  }
}
