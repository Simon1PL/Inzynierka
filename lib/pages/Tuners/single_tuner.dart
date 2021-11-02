import 'package:flutter/material.dart';
import 'package:projekt/enums/user_role_for_tuner.dart';
import 'package:projekt/models/tuner_model.dart';
import 'package:projekt/models/tuner_user_model.dart';
import 'package:projekt/services/tuners_service.dart';
import 'package:projekt/widgets/app_bar.dart';
import 'package:projekt/widgets/menu.dart';

class SingleTuner extends StatefulWidget {
  final TunerModel tunerModel;

  SingleTuner(this.tunerModel);

  @override
  _SingleTunerState createState() => _SingleTunerState(tunerModel);
}

class _SingleTunerState extends State<SingleTuner> {
  final TunerModel tunerModel;
  List<TunerUserModel> users = [];
  final _userNameController = TextEditingController();

  _SingleTunerState(this.tunerModel);

  void getTunerUsers() async {
    if (tunerModel.currentUserRole == UserRoleForTuner.USER) return;

    var usersTmp = await getUsersForTuner(tunerModel.tunerId) ?? [];
    setState(() {
      users = usersTmp;
    });
  }

  @override
  void initState() {
    super.initState();
    getTunerUsers();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: MyAppBar(
        text: "R-M DVB-T Tuner",
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Tuner name: " + tunerModel.name),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Your role: " +
              TunerModel.getUserRoleAsString(tunerModel.currentUserRole)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Tuner users: "),
        ),
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: users.length,
            itemBuilder: (context, index) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(users[index].username),
                    Text("   Role: " +
                        TunerModel.getUserRoleAsString(users[index].userRole)),
                    if (tunerModel.currentUserRole == UserRoleForTuner.OWNER) IconButton(
                        onPressed: () {
                          removeUserFromTuner(
                              users[index].username, tunerModel.tunerId);
                        },
                        icon: Icon(Icons.delete))
                  ]);
            }),
        if (tunerModel.currentUserRole == UserRoleForTuner.OWNER) Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 200),
              child:
                TextField(
                  textInputAction: TextInputAction.next,
                  onSubmitted: (term) {
                    createTuner(_userNameController.text);
                    Navigator.pushNamed(context, "/tuners");
                  },
                  controller: _userNameController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    filled: true,
                    border: InputBorder.none,
                    labelText: "Name",
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                ),
            ),
            ElevatedButton(
              onPressed: () async {
                var result = await inviteToTuner(_userNameController.text, tunerModel.tunerId, context);
                if (result) {
                  _userNameController.clear();
                  getTunerUsers();
                }
              },
              child: Text(
                'Invite user',
                style: TextStyle(fontSize: 25),
              ),
            )
          ],
        ),
        Text("")
      ]),
      bottomNavigationBar: Menu(),
    );
  }
}
