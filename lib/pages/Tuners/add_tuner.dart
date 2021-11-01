import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:projekt/services/tuners_service.dart';
import 'package:projekt/widgets/app_bar.dart';
import 'package:projekt/widgets/menu.dart';

class AddTuner extends StatefulWidget {
  @override
  _AddTunerState createState() => _AddTunerState();
}

class _AddTunerState extends State<AddTuner> {
  final _tunerNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tunerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: MyAppBar(
        text: "R-M DVB-T Tuner",
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextField(
            textInputAction: TextInputAction.next,
            onSubmitted: (term) {
              createTuner(_tunerNameController.text);
              Navigator.pushNamed(context, "/tuners");
            },
            controller: _tunerNameController,
            autofocus: true,
            decoration: const InputDecoration(
              filled: true,
              border: InputBorder.none,
              labelText: "Name",
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20.0),
          ),
          ElevatedButton(
            onPressed: () async {
              await createTuner(_tunerNameController.text);
              Navigator.pushNamed(context, "/tuners");
            },
            child: Text(
              'Add tuner',
              style: TextStyle(fontSize: 25),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 100.0),
          ),
        ]),
      ),
      bottomNavigationBar: Menu(),
    );
  }
}
