import 'package:flutter/material.dart';
import 'package:project/enums/user_role_for_tuner.dart';
import 'package:project/models/tuner_model.dart';
import 'package:project/models/tuner_user_model.dart';
import 'package:project/services/alert_service.dart';
import 'package:project/services/globals.dart';
import 'package:project/services/tuners_service.dart';
import 'package:project/widgets/Shared/app_bar.dart';
import 'package:project/widgets/Shared/loader.dart';
import 'package:project/widgets/Shared/menu.dart';
import 'package:project/widgets/Tuners/tuners.dart';

class SingleTuner extends StatefulWidget {
  final TunerModel tunerModel;

  SingleTuner(this.tunerModel);

  @override
  _SingleTunerState createState() => _SingleTunerState(tunerModel);
}

class _SingleTunerState extends State<SingleTuner> {
  final TunerModel tunerModel;
  List<TunerUserModel> users = [];
  bool usersLoaded = false;
  final _userNameController = TextEditingController();
  final FocusNode addNewFocusNode = FocusNode();

  _SingleTunerState(this.tunerModel);

  void getTunerUsers() async {
    var usersTmp = await getUsersForTuner(tunerModel.tunerId) ?? [];
    setState(() {
      users = usersTmp;
      usersLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getTunerUsers();
  }

  @override
  void dispose() {
    addNewFocusNode.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: MyAppBar(
        text: tunerModel.name,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 8.0),
              child: Text("Tuner name: " + tunerModel.name),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Your role: " +
                  TunerModel.getUserRoleAsString(tunerModel.currentUserRole)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Tuner id: " + tunerModel.tunerId.toString()),
            ),
            if (tunerModel.currentUserRole == UserRoleForTuner.OWNER) Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      focusNode: addNewFocusNode,
                      controller: _userNameController,
                      keyboardType: TextInputType.name,
                      decoration: new InputDecoration(
                        hintText: "Invite user",
                        border: InputBorder.none,
                      ),
                      onFieldSubmitted: (val) async {
                        if (_userNameController.text.isEmpty) {
                          showSnackBar("Fill username to invite");
                          return;
                        }
                        var result = await inviteToTuner(_userNameController.text, tunerModel.tunerId, context);
                        if (result) {
                          _userNameController.clear();
                          getTunerUsers();
                        }
                        _userNameController.clear();
                        addNewFocusNode.requestFocus();
                      },
                    ),
                  ),
                  ButtonTheme(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                    child: OutlinedButton(
                      child: Text("Invite"),
                        onPressed: () async {
                          if (_userNameController.text.isEmpty) {
                            showSnackBar("Fill username to invite");
                            return;
                          }
                          var result = await inviteToTuner(_userNameController.text, tunerModel.tunerId, context);
                          if (result) {
                            _userNameController.clear();
                            getTunerUsers();
                          }
                          _userNameController.clear();
                          addNewFocusNode.requestFocus();
                        }),
                  ),
                ],
              ),
            ),
            if (usersLoaded) Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                    columnSpacing: 20.0,
                    columns: [
                      DataColumn(
                        label: Text('Tuner user'),
                      ),
                      DataColumn(
                        label: Text('Role'),
                      ),
                      if (tunerModel.currentUserRole == UserRoleForTuner.OWNER) DataColumn(
                        label: Text(''),
                      ),
                    ],
                    rows: List<DataRow>.generate(
                      users.length,
                          (int index) => DataRow(
                        key: ValueKey(index),
                        cells: [
                          DataCell(Container(width: 100, child: Text(users[index].username))),
                          DataCell(Text(TunerModel.getUserRoleAsString(
                              users[index].userRole))),
                          if (tunerModel.currentUserRole == UserRoleForTuner.OWNER) DataCell(
                            IconButton(
                                onPressed: () async {
                                  await removeUserFromTuner(
                                      users[index].username, tunerModel.tunerId);
                                  if (users[index].username == await username) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Tuners(),
                                        ));
                                  }
                                },
                                icon: Icon(Icons.delete)),
                          )
                        ],
                      ),
                    )),
              ),
            ),
            if (!usersLoaded) Loader(),
          ]),
        ],
      ),
      bottomNavigationBar: Menu(),
    );
  }
}
