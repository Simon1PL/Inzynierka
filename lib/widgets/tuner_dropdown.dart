import 'package:flutter/material.dart';
import 'package:projekt/models/tuner_model.dart';
import 'package:projekt/services/globals.dart';
import 'package:projekt/services/tuners_service.dart';

class TunerDropdown extends StatefulWidget {
  TunerDropdown();

  @override
  TunerDropdownState createState() => TunerDropdownState();
}

class TunerDropdownState extends State<TunerDropdown> {
  String? tunerId;
  List<TunerModel> availableTuners = [];

  TunerDropdownState();

  Future<void> loadTuners() async {
    var tunerIdTmp = (await selectedTunerId).toString();
    var availableTunersTmp = await tuners;
    setState(() {
      tunerId = tunerIdTmp;
      availableTuners = availableTunersTmp;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTuners();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: tunerId,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Colors.blue,
      ),
      onChanged: (String? newValue) async {
        await setSelectedTunerId(newValue);
        if (activeTab != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, activeTab!, (route) => false);
        }
        setState(() {
          tunerId = newValue;
        });
      },
      items: availableTuners
          .map((tuner) => DropdownMenuItem<String>(
                value: tuner.tunerId.toString(),
                child: Text(tuner.name),
              ))
          .toList(),
    );
  }
}
