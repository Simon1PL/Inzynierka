import 'package:flutter/material.dart';
import 'package:project/services/login_service.dart';
import 'package:project/widgets/Shared/app_bar.dart';
import 'package:project/widgets/Shared/loader.dart';

import 'home.dart';

class Login extends StatefulWidget {
  static const String routeName = '/login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _showPassword = false;
  String? _passwordError, _loginError;
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();

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

  bool _checkInputs() {
    String? passwordError, loginError;

    if (_loginController.text == "") {
      loginError = 'Username can\'t be empty';
    }

    if (_passwordController.text == "") {
        passwordError = 'Password can\'t be empty';
    }

    if (passwordError != null || loginError != null) {
      setState(() {
        _loginError = loginError;
        _passwordError = passwordError;
      });
      return false;
    }

    return true;
  }

  void _login() {
    if (!_checkInputs()) return;
    logIn(_loginController.text,
        _passwordController.text);
  }

  _register() {
    if (!_checkInputs()) return;
    register(_loginController.text,
        _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: isLoggedIn,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == false) {
            return Scaffold(
                resizeToAvoidBottomInset: false,
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
                          onChanged: (text) => setState(() {
                            _loginError = null;
                          }),
                          onSubmitted: (term) {
                            passwordFocusNode.requestFocus();
                          },
                          controller: _loginController,
                          autofocus: true,
                          decoration: InputDecoration(
                            filled: true,
                            border: InputBorder.none,
                            labelText: "Username",
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            errorText: _loginError,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20.0),
                          child: TextField(
                            onSubmitted: (term) {
                              logIn(_loginController.text,
                                  _passwordController.text);
                            },
                            onChanged: (text) => setState(() {
                              _passwordError = null;
                            }),
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
                              errorText: _passwordError,
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
                            _login();
                          },
                          child: Text(
                            'LOGIN',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20.0),
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text("Don't have an account? "),
                            OutlinedButton(
                              onPressed: () {
                                _register();
                              },
                              child: Text('REGISTER'),
                            ),
                            Text(" instead."),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 100.0),
                        ),
                      ]),
                ));
          } else {
            return Loader();
          }
        });
  }
}
