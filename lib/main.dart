import 'package:flutter/material.dart';
import 'package:project/widgets/Favorites/favorites.dart';
import 'package:project/widgets/Programs/single_program_info.dart';
import 'package:project/widgets/Programs/tv_program.dart';
import 'package:project/widgets/Tuners/add_tuner.dart';
import 'package:project/widgets/Home/login.dart';
import 'package:project/services/globals.dart';
import 'package:project/widgets/Recordings/scheduled.dart';
import 'package:project/widgets/Home/home.dart';
import 'package:project/widgets/Programs/explore.dart';
import 'package:project/widgets/Recordings/recorded.dart';
import 'package:project/widgets/Tuners/tuners.dart';

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
