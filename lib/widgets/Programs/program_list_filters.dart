import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:project/models/filters_model.dart';
import 'package:project/models/program_model.dart';

class ProgramListFilters extends StatefulWidget {
  final List<ProgramModel>? _notFilteredList;
  final FiltersModel filters;

  ProgramListFilters(this._notFilteredList, this.filters);

  @override
  _ProgramListFilters createState() =>
      _ProgramListFilters(this._notFilteredList, this.filters);
}

class _ProgramListFilters extends State<ProgramListFilters> {
  final List<ProgramModel>? _notFilteredList;
  final FiltersModel filters;
  late final List<String?> availableChannels, availableGenres;

  _ProgramListFilters(this._notFilteredList, this.filters) {
    availableChannels = _notFilteredList!.map((e) => e.channelName).toSet().toList();
    var tmpSet = new Set<String?>();
    _notFilteredList!.forEach((e) => tmpSet.addAll(e.genre));
    availableGenres = tmpSet.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 65,
        left: 12,
        right: 12,
        child: Container(
          height: 320,
          decoration: new BoxDecoration(
              color: Colors.white, border: Border.all(color: Colors.black)),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(bottom: 10.0)),
              Container(
                width: 150,
                child: DropdownButton<String?>(
                  isExpanded: true,
                  focusColor: Colors.white,
                  value: filters.genre,
                  style: TextStyle(color: Colors.white),
                  iconEnabledColor: Colors.black,
                  items: availableGenres
                      .map<DropdownMenuItem<String?>>((String? value) {
                    return DropdownMenuItem<String?>(
                      value: value,
                      child: Text(
                        value ?? "Choose genre",
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    "Choose genre",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      filters.genre = value;
                    });
                  },
                ),
              ),
              Container(
                width: 150,
                child: DropdownButton<String?>(
                  isExpanded: true,
                  focusColor: Colors.white,
                  value: filters.channelName,
                  style: TextStyle(color: Colors.white),
                  iconEnabledColor: Colors.black,
                  items: availableChannels
                      .map<DropdownMenuItem<String?>>((String? value) {
                    return DropdownMenuItem<String?>(
                      value: value,
                      child: Text(
                        value ?? "Choose channel",
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    "Choose channel",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      filters.channelName = value;
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Date from: "),
                  OutlinedButton(
                      onPressed: () {
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            minTime: _notFilteredList!
                                .map((e) => e.start!)
                                .reduce((a, b) => a.isBefore(b) ? a : b),
                            maxTime: _notFilteredList!
                                .map((e) => e.start!)
                                .reduce((a, b) => a.isAfter(b) ? a : b),
                            onCancel: () => setState(() {
                                  filters.dateTo = null;
                                }),
                            onChanged: (date) {},
                            onConfirm: (date) {
                              setState(() {
                                filters.dateFrom = date;
                              });
                            },
                            currentTime: DateTime.now(),
                            locale: LocaleType.pl);
                      },
                      child: Text(
                        (filters.dateFrom != null
                            ? DateFormat(" dd.MM.yyyy HH:mm")
                                .format(filters.dateFrom!)
                            : 'choose'),
                        style: TextStyle(color: Colors.blue),
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Date to: "),
                  OutlinedButton(
                      onPressed: () {
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            minTime: _notFilteredList!
                                .map((e) => e.start!)
                                .reduce((a, b) => a.isBefore(b) ? a : b),
                            maxTime: _notFilteredList!
                                .map((e) => e.start!)
                                .reduce((a, b) => a.isAfter(b) ? a : b),
                            onCancel: () => setState(() {
                                  filters.dateTo = null;
                                }),
                            onChanged: (date) {},
                            onConfirm: (date) {
                              setState(() {
                                filters.dateTo = date;
                              });
                            },
                            currentTime: DateTime.now(),
                            locale: LocaleType.pl);
                      },
                      child: Text(
                        (filters.dateTo != null
                            ? DateFormat(" dd.MM.yyyy HH:mm")
                                .format(filters.dateTo!)
                            : "choose"),
                        style: TextStyle(color: Colors.blue),
                      )),
                ],
              ),
              Container(
                width: 130,
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.all(0),
                  checkColor: Colors.white,
                  activeColor: Colors.blue,
                  title: Text("show past"),
                  value: filters.showPast,
                  onChanged: (newValue) {
                    setState(() {
                      filters.showPast = newValue!;
                    });
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
