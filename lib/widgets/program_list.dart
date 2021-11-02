import 'package:flutter/material.dart';
import 'package:projekt/models/program_model.dart';
import 'package:projekt/widgets/program_list_item.dart';

class ProgramList extends StatefulWidget {
  final List<ProgramModel>? _list;
  final String _errorText;

  ProgramList(this._list, this._errorText);

  @override
  ProgramListState createState() =>
      ProgramListState(this._list, this._errorText);
}

class ProgramListState extends State<ProgramList> {
  List<ProgramModel>? _list, _notFilteredList;
  final String _errorText;
  final _searchController = TextEditingController();

  ProgramListState(this._list, this._errorText) {
    if (_list != null) {
      _notFilteredList = new List<ProgramModel>.from(_list!);
    }
  }

  void search() {
    if (this._notFilteredList == null) return;

    var searchedText = _searchController.text.toLowerCase();
    var searchByTitle = this
        ._notFilteredList!
        .where((element) =>
            element.title != null &&
            element.title!.toLowerCase().contains(searchedText))
        .toList();

    var searchNotByTitle = this
        ._notFilteredList!
        .where((element) =>
            element.title != null &&
            !element.title!.contains(searchedText) &&
            ((element.summary != null &&
                    element.summary!.contains(searchedText)) ||
                (element.description != null &&
                    element.description!.contains(searchedText)) ||
                (element.subtitle != null &&
                    element.subtitle!.contains(searchedText)) ||
                (element.channelName != null &&
                    element.channelName!.contains(searchedText)) ||
                element.start.toString().contains(searchedText) ||
                element.stop.toString().contains(searchedText)))
        .toList();

    var tmpList = <ProgramModel>[];
    tmpList.addAll(searchByTitle);
    tmpList.addAll(searchNotByTitle);

    setState(() {
      _list = tmpList;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_list == null) {
      return Center(
        child: Text(
          _errorText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else if (_list!.length > 0) {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: TextField(
              textInputAction: TextInputAction.search,
              onSubmitted: (term) {
                search();
              },
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    search();
                  },
                ),
                contentPadding: EdgeInsets.only(left: 10.0, top: 20.0),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _list!.length,
                itemBuilder: (context, index) {
                  return ProgramListItem(ValueKey(_list![index]), _list![index]);
                }),
          ),
        ],
      );
    } else {
      return Center(
        child: Text(
          "No data",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }
}
