import 'package:flutter/material.dart';
import 'package:project/services/db_service.dart';
import 'package:project/services/login_service.dart';
import 'package:project/widgets/Home/explore_list.dart';
import 'package:project/widgets/Home/login.dart';
import 'package:project/widgets/Home/recording_list.dart';
import 'package:project/widgets/Shared/app_bar.dart';
import 'package:project/widgets/Shared/loader.dart';
import 'package:project/widgets/Shared/menu.dart';
import 'package:project/widgets/Home/section_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool hasLoaded = true;

  @override
  void initState() {
    redirect();
    super.initState();
  }

  redirect() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var wasNeverLoaded = pref.getBool("wasNeverLoaded") == null;
    if (wasNeverLoaded) {
      setState(() {
        hasLoaded = false;
      });
      await loadProgramsFromDb();
    }
    else {
      loadProgramsFromDb();
    }

    if (!await isLoggedIn)
      Navigator.pushNamedAndRemoveUntil(
          context, Login.routeName, (route) => false);

    setState(() {
      hasLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: MyAppBar(
        text: "R-M DVB-T Tuner",
      ),
      body: hasLoaded ? Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        SectionTitle("Check this out"),
        ExploreList(),
        SectionTitle("Your recording list"),
        RecordingList(),
      ]) : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(padding: const EdgeInsets.all(25.0), child: Text("Your app is starting for the first time. It may take a while. (~10s)", textAlign: TextAlign.center)),
        Loader()
      ]),
      bottomNavigationBar: Menu(
        currentIndex: 0,
      ),
    );
  }
}
