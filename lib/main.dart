import 'package:flutter/material.dart';
import 'package:projekt/pages/Programs/favorites.dart';
import 'package:projekt/pages/Programs/tv_program.dart';
import 'pages/Recordings/scheduled.dart';
import 'pages/home.dart';
import 'pages/Programs/explore.dart';
import 'pages/Recordings/recorded.dart';
import 'pages/loading.dart';

void main() => runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/loading': (context) => Loading(),
      '/home': (context) => Home(),
      '/programs/tv_program': (context) => TvProgram(),
      '/programs/explore': (context) => Explore(),
      '/programs/favorites': (context) => Favorites(),
      '/recordings/recorded': (context) => Recorded(),
      '/recordings/scheduled': (context) => Scheduled(),
    }
));