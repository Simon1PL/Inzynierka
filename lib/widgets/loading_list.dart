import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:projekt/models/program_model.dart';
import 'package:projekt/widgets/single_item_vertical_list.dart';

getView(List<ProgramModel>? list, bool dataLoaded, String errorText) {
  if (!dataLoaded) {
    return Center(
      child: SpinKitFadingCircle(
        color: Colors.grey[800],
        size: 50,
      ),
    );
  }
  else if (list == null) {
    return Center(
      child: Text(errorText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  else if (list.length > 0) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return SingleItemVerticalList(list[index]);
        }
    );
  }
  else {
    return Center(
      child: Text("No data",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}