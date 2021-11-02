import 'package:flutter/material.dart';
import 'package:project/enums/user_role_for_tuner.dart';
import 'package:project/models/tuner_model.dart';
import 'package:project/widgets/Shared/loader.dart';
import 'package:project/widgets/Tuners/single_tuner.dart';
import 'package:project/services/tuners_service.dart';
import 'package:project/widgets/Shared/app_bar.dart';
import 'package:project/widgets/Shared/menu.dart';

class Tuners extends StatefulWidget {
  @override
  _TunersState createState() => _TunersState();
}

class _TunersState extends State<Tuners> {
  List<TunerModel> tunerList = [];
  bool dataLoaded = false;

  void getTuners() async {
    tunerList = await tuners;

    setState(() {
      dataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getTuners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: MyAppBar(
        text: "R-M DVB-T Tuner",
      ),
      body: dataLoaded
          ? Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: tunerList.length,
                  itemBuilder: (context, index) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(tunerList[index].name),
                          Text("   Role: " +
                              TunerModel.getUserRoleAsString(
                                  tunerList[index].currentUserRole)),
                          tunerList[index].currentUserRole ==
                                  UserRoleForTuner.INVITED
                              ? Row(
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          await acceptTuner(tunerList[index].tunerId);
                                          loadTunersFromServer();
                                          setState(() {
                                            tunerList[index].currentUserRole =
                                                UserRoleForTuner.USER;
                                          });
                                        },
                                        icon: Icon(Icons.done)),
                                    IconButton(
                                        onPressed: () async {
                                          await declineTuner(
                                              tunerList[index].tunerId);
                                          loadTunersFromServer();
                                          setState(() {
                                            tunerList.removeAt(index);
                                          });
                                        },
                                        icon: Icon(Icons.cancel))
                                  ],
                                )
                              : IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SingleTuner(tunerList[index]),
                                        ));
                                  },
                                  icon: Icon(Icons.edit))
                        ]);
                  }),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/tuners/add");
                },
                child: Text(
                  'Add new',
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ])
          : Loader(),
      bottomNavigationBar: Menu(),
    );
  }
}
