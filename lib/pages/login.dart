import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:projekt/services/login_service.dart';
import 'package:projekt/widgets/app_bar.dart';

import 'home.dart';

class Login extends StatefulWidget {
  static const String routeName = '/login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _showPassword = false;
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  late FocusNode passwordFocusNode = FocusNode();

  redirect() async {
    if (await isLoggedIn)
      Navigator.pushNamedAndRemoveUntil(
          context, Home.routeName, (route) => false);
  }

  @override
  void initState() {
    super.initState();
    redirect();
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: isLoggedIn,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == false) {
            return Scaffold(
                backgroundColor: Colors.grey[200],
                appBar: MyAppBar(
                  text: "R-M DVB-T Tuner",
                  showActions: false,
                ),
                body: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          textInputAction: TextInputAction.next,
                          onSubmitted: (term) {
                            passwordFocusNode.requestFocus();
                          },
                          controller: _loginController,
                          autofocus: true,
                          decoration: const InputDecoration(
                            filled: true,
                            border: InputBorder.none,
                            labelText: "Login",
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20.0),
                          child: TextField(
                            onSubmitted: (term) {
                              logIn(_loginController.text,
                                  _passwordController.text);
                            },
                            focusNode: passwordFocusNode,
                            controller: _passwordController,
                            obscureText: !_showPassword,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                              filled: true,
                              border: InputBorder.none,
                              labelText: "Password",
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              suffixIcon: IconButton(
                                  icon: Icon(!_showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _showPassword = !_showPassword;
                                    });
                                  }),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20.0),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            logIn(_loginController.text,
                                _passwordController.text);
                          },
                          child: Text(
                            'LOGIN',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account? "),
                            OutlinedButton(
                              onPressed: () {
                                register(_loginController.text,
                                    _passwordController.text);
                              },
                              child: Text('REGISTER'),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 100.0),
                        ),
                      ]),
                ));
          } else {
            return Center(
              child: SpinKitFadingCircle(
                color: Colors.grey[800],
                size: 50,
              ),
            );
          }
        });
  }
}
