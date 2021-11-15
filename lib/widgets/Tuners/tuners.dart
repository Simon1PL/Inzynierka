import 'package:flutter/material.dart';
import 'package:project/enums/user_role_for_tuner.dart';
import 'package:project/models/tuner_model.dart';
import 'package:project/services/alert_service.dart';
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
  final _tunerNameController = TextEditingController();
  final FocusNode addNewFocusNode = FocusNode();

  Future<void> getTuners() async {
    await loadTunersFromServer();
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
  void dispose() {
    _tunerNameController.dispose();
    addNewFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: MyAppBar(
        text: "Your Tuners",
      ),
      body: dataLoaded
          ? Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: TextFormField(
                  focusNode: addNewFocusNode,
                  controller: _tunerNameController,
                  keyboardType: TextInputType.name,
                  decoration: new InputDecoration(
                    hintText: "New tuner name",
                    border: InputBorder.none,
                  ),
                  onFieldSubmitted: (val) async {
                    if (_tunerNameController.text.isEmpty) {
                      showSnackBar("Tuner name can't be empty");
                      return;
                    }
                    await createTuner(_tunerNameController.text);
                    getTuners();
                    _tunerNameController.clear();
                    addNewFocusNode.requestFocus();
                  },
                ),
              ),
              IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.add_circle, size: 28,),
                  onPressed: () async {
                    if (_tunerNameController.text.isEmpty) {
                      showSnackBar("Tuner name can't be empty");
                      return;
                    }
                    await createTuner(_tunerNameController.text);
                    getTuners();
                    _tunerNameController.clear();
                    addNewFocusNode.requestFocus();
                  }),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: DataTable(
                columnSpacing: 20.0,
                columns: const [
                  DataColumn(
                    label: Text('Tuner name'),
                  ),
                  DataColumn(
                    label: Text('Your role'),
                  ),
                  DataColumn(
                    label: Text('Id'),
                  ),
                  DataColumn(
                    label: Text(''),
                  ),
                ],
                rows: List<DataRow>.generate(
                  tunerList.length,
                      (int index) => DataRow(
                    key: ValueKey(index),
                    cells: [
                      DataCell(Container(width: 100, child: Text(tunerList[index].name))),
                      DataCell(Text(TunerModel.getUserRoleAsString(
                              tunerList[index].currentUserRole))),
                      DataCell(Text(tunerList[index].tunerId.toString())),
                      DataCell(tunerList[index].currentUserRole ==
                          UserRoleForTuner.INVITED
                          ? Row(
                        children: [
                          IconButton(
                              constraints: BoxConstraints(),
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
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
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
                          icon: Icon(Icons.edit))),
                    ],
                  ),
                )),
          ),
        ),
            ])
          : Loader(),
      bottomNavigationBar: Menu(),
    );
  }
}
