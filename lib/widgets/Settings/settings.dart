import 'package:flutter/material.dart';
import 'package:project/models/settings_model.dart';
import 'package:project/services/settings_service.dart';
import 'package:project/widgets/Shared/loader.dart';
import 'package:project/widgets/Shared/app_bar.dart';
import 'package:project/widgets/Shared/menu.dart';

class Settings extends StatefulWidget {
  @override
  _Settings createState() => _Settings();
}

class _Settings extends State<Settings> {
  SettingsModel? settings;
  bool dataLoaded = false;

  Future<void> getSettings() async {
    settings = await loadSettings();

    setState(() {
      dataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: MyAppBar(
        text: "Settings",
      ),
      body: dataLoaded
          ? Column(
            children: [
              DataTable(headingRowHeight: 0, columns: const [
                  DataColumn(
                    label: Text(''),
                  ),
                  DataColumn(
                    label: Text(''),
                  ),
                ], rows: [
        DataRow(cells: [DataCell(Text("Free space")), DataCell(Text(settings!.freeSpace.toString()))]),
        DataRow(cells: [DataCell(Text("Recording location")), DataCell(
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    initialValue: settings!.recordingLocation,
                    keyboardType: TextInputType.name,
                    decoration: new InputDecoration(
                      hintText: "e.g. /recordings/",
                      border: InputBorder.none,
                    ),
                    onChanged: (val) async {
                      settings!.recordingLocation = val;
                    },
                  ),
                ),
                )]),
        DataRow(cells: [DataCell(Text("Tvh username")), DataCell(
              SizedBox(
                width: 200,
                child: TextFormField(
                  initialValue: settings!.tvhUsername,
                  keyboardType: TextInputType.name,
                  decoration: new InputDecoration(
                    hintText: "tvh username",
                    border: InputBorder.none,
                  ),
                  onChanged: (val) async {
                    settings!.tvhUsername = val;
                  },
                ),
              ),
        )]),
        DataRow(cells: [DataCell(Text("Tvh password")), DataCell(
              SizedBox(
                width: 200,
                child: TextFormField(
                  initialValue: settings!.tvhPassword,
                  keyboardType: TextInputType.name,
                  decoration: new InputDecoration(
                    hintText: "if not changed, leave empty",
                    border: InputBorder.none,
                  ),
                  onChanged: (val) async {
                    settings!.tvhPassword = val;
                  },
                ),
              ),
        )]),
                ]),
              ElevatedButton(onPressed: () { saveSettings(settings!); }, child: Text("Save"))
            ],
          )
          : Loader(),
      bottomNavigationBar: Menu(),
    );
  }
}
