import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:projekt/models/tuner_model.dart';
import 'package:projekt/pages/Tuners/single_tuner.dart';
import 'package:projekt/services/tuners_service.dart';
import 'package:projekt/widgets/app_bar.dart';
import 'package:projekt/widgets/menu.dart';

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
      body: dataLoaded ?
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: tunerList.length,
            itemBuilder: (context, index) {
              return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text(tunerList[index].name!),
                Text("   Role: " +
                    TunerModel.getUserRoleAsString(
                        tunerList[index].currentUserRole)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SingleTuner(tunerList[index]),
                          ));
                    },
                    icon: Icon(Icons.edit))
              ]);
            }),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                    context,
                    "/tuners/add");
              },
              child: Text(
                'Add new',
                style: TextStyle(fontSize: 25),
              ),
            ),
      ]) : Center(
        child: SpinKitFadingCircle(
          color: Colors.grey[800],
          size: 50,
        ),
      ),
      bottomNavigationBar: Menu(),
    );
  }
}
