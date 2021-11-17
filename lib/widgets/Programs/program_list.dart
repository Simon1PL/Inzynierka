import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/models/filters_model.dart';
import 'package:project/models/program_model.dart';
import 'package:project/widgets/Programs/program_list_filters.dart';
import 'package:project/widgets/Programs/program_list_item.dart';

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
  final _controller = ScrollController();
  final filters = FiltersModel();
  bool openFilters = false;

  ProgramListState(this._list, this._errorText) {
    if (_list != null) {
      _notFilteredList = new List<ProgramModel>.from(_list!);
    }
  }

  void search() {
    if (this._notFilteredList == null) return;

    var tmpList = <ProgramModel>[];

    if (_list!.length > 0) {
      _controller.animateTo(
        0.0,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }

    _list = _notFilteredList!.toList();

    if (filters.channelName != null) {
      _list =
          _list!.where((e) => e.channelName == filters.channelName).toList();
    }

    if (filters.showPast == false) {
      _list = _list!.where((e) => e.stop!.isAfter(DateTime.now())).toList();
    }

    if (filters.dateFrom != null) {
      _list = _list!.where((e) => e.stop!.isAfter(filters.dateFrom!)).toList();
    }

    if (filters.dateTo != null) {
      _list = _list!.where((e) => e.start!.isBefore(filters.dateTo!)).toList();
    }

    if (filters.genre != null) {
      _list =
          _list!.where((e) => e.genre.contains(filters.genre)).toList();
    }

    var searchedText = _searchController.text.toLowerCase();
    if (searchedText.isNotEmpty) {
      var searchByTitle = this
          ._list!
          .where((element) =>
              element.title != null &&
              element.title!.toLowerCase().contains(searchedText))
          .toList();

      var searchNotByTitle = this
          ._list!
          .where((element) =>
              element.title != null &&
              !element.title!.toLowerCase().contains(searchedText) &&
              ((element.summary != null &&
                      element.summary!.toLowerCase().contains(searchedText)) ||
                  (element.description != null &&
                      element.description!
                          .toLowerCase()
                          .contains(searchedText)) ||
                  (element.subtitle != null &&
                      element.subtitle!.toLowerCase().contains(searchedText)) ||
                  (element.channelName != null &&
                      element.channelName!
                          .toLowerCase()
                          .contains(searchedText)) ||
                  (element.start != null &&
                      element.stop != null &&
                      ((DateFormat.Hm().format(element.start!) +
                                  " - " +
                                  DateFormat.Hm().format(element.stop!))
                              .contains(searchedText) ||
                          DateFormat("dd.MM.yyyy")
                              .format(element.start!)
                              .contains(searchedText)))))
          .toList();

      tmpList.addAll(searchByTitle);
      tmpList.addAll(searchNotByTitle);
    } else {
      tmpList = _list!;
    }

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
      return Stack(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, left: 10),
                    child: IconButton(
                        icon: Icon(Icons.filter_alt),
                        iconSize: 33,
                        onPressed: () => setState(() {
                              openFilters = !openFilters;
                            })),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
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
                          contentPadding:
                              EdgeInsets.only(left: 10.0, top: 20.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: ListView.builder(
                      primary: false,
                      controller: _controller,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: _list!.length,
                      itemBuilder: (context, index) {
                        return ProgramListItem(
                            ValueKey(_list![index]), _list![index]);
                      }),
                ),
              ),
            ],
          ),
          if (openFilters) ProgramListFilters(_notFilteredList, filters),
          if (openFilters)
            Positioned(
              top: 65,
              right: 10,
              child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => setState(() {
                        openFilters = false;
                      })),
            ),
          if (openFilters)
            Positioned(
                top: 320,
                right: 0,
                left: 0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          filters.reset();
                          setState(() {
                            filters;
                          });
                        },
                        child: Text("Reset filters"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          search();
                          setState(() {
                            openFilters = false;
                          });
                        },
                        child: Text("Apply filters"),
                      )
                    ])),
        ],
      );
    } else {
      return Stack(
        children: [
          Column(children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 10),
                  child: IconButton(
                    icon: Icon(Icons.filter_alt),
                    iconSize: 33,
                    onPressed: () => setState(() {
                      openFilters = !openFilters;
                    }),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
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
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
            ),
            Center(
              child: Text(
                "No data",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ]),
          if (openFilters) ProgramListFilters(_notFilteredList, filters),
          if (openFilters)
            Positioned(
              top: 65,
              right: 10,
              child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => setState(() {
                    openFilters = false;
                  })),
            ),
          if (openFilters)
            Positioned(
                top: 320,
                right: 0,
                left: 0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          filters.reset();
                          setState(() {
                            filters;
                          });
                        },
                        child: Text("Reset filters"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          search();
                          setState(() {
                            openFilters = false;
                          });
                        },
                        child: Text("Apply filters"),
                      )
                    ])),
        ],
      );
    }
  }
}
