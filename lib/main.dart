import 'package:flutter/material.dart';
import './pages/home.dart';
import './pages/programs.dart';
import './pages/recordings.dart';
import './pages/loading.dart';

void main() => runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/loading': (context) => Loading(),
      '/home': (context) => Home(),
      '/programs': (context) => Programs(),
      '/recordings': (context) => Recordings(),
    }
));