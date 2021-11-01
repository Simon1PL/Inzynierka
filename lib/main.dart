import 'package:flutter/material.dart';
import 'package:projekt/pages/Programs/favorites.dart';
import 'package:projekt/pages/Programs/single_program_info.dart';
import 'package:projekt/pages/Programs/tv_program.dart';
import 'package:projekt/pages/Tuners/add_tuner.dart';
import 'package:projekt/pages/login.dart';
import 'package:projekt/services/globals.dart';
import 'pages/Recordings/scheduled.dart';
import 'pages/home.dart';
import 'pages/Programs/explore.dart';
import 'pages/Recordings/recorded.dart';
import 'pages/Tuners/tuners.dart';

Future<void> main() async => runApp(MaterialApp(
        navigatorKey: navigatorKey,
        initialRoute: Login.routeName,
        routes: {
          Home.routeName: (context) => Home(),
          Login.routeName: (context) => Login(),
          '/tuners': (context) => Tuners(),
          '/tuners/add': (context) => AddTuner(),
          '/programs/tv_program': (context) => TvProgram(),
          '/programs/explore': (context) => Explore(),
          '/programs/favorites': (context) => Favorites(),
          '/recordings/recorded': (context) => Recorded(),
          '/recordings/scheduled': (context) => Scheduled(),
          SingleProgram.routeName: (context) => SingleProgram(),
        }));
