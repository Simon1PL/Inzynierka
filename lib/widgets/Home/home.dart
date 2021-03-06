import 'package:flutter/material.dart';
import 'package:project/services/login_service.dart';
import 'package:project/widgets/Home/explore_list.dart';
import 'package:project/widgets/Home/login.dart';
import 'package:project/widgets/Home/recording_list.dart';
import 'package:project/widgets/Shared/app_bar.dart';
import 'package:project/widgets/Shared/menu.dart';
import 'package:project/widgets/Home/section_title.dart';

class Home extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    redirect();
    super.initState();
  }

  redirect() async {
    if (!await isLoggedIn)
      Navigator.pushNamedAndRemoveUntil(
          context, Login.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: MyAppBar(
        text: "R-M DVB-T Tuner",
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        SectionTitle("Check this out"),
        ExploreList(),
        SectionTitle("Your recording list"),
        RecordingList(),
      ]),
      bottomNavigationBar: Menu(
        currentIndex: 0,
      ),
    );
  }
}
