import 'package:flutter/material.dart';
import 'package:project/enums/favorite_type.dart';
import 'package:project/services/favorite_service.dart';

class FavoriteTitles extends StatefulWidget {
  final List<String> favoriteTitles;

  FavoriteTitles(this.favoriteTitles);

  @override
  _FavoriteTitles createState() => _FavoriteTitles(favoriteTitles);
}

class _FavoriteTitles extends State<FavoriteTitles> {
  List<String> favoriteTitles = [];
  late final List<String> favoriteTitlesCopy;
  late final List<bool> selected;
  final TextEditingController newTitleController = TextEditingController();
  final FocusNode addNewFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  _FavoriteTitles(this.favoriteTitles) {
    selected = List<bool>.generate(favoriteTitles.length, (el) => false);
    favoriteTitlesCopy = favoriteTitles;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    newTitleController.dispose();
    addNewFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  search() {
    setState(() {
      favoriteTitles = favoriteTitlesCopy.where((element) => element.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 25),
          child: Text(
            'Your favorite titles:',
            textDirection: TextDirection.ltr,
            style: TextStyle(color: Colors.blue[600]!, fontSize: 25),
          ),
        ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: TextFormField(
                focusNode: addNewFocusNode,
                controller: newTitleController,
                keyboardType: TextInputType.name,
                decoration: new InputDecoration(
                  hintText: "New title",
                  border: InputBorder.none,
                ),
                onFieldSubmitted: (val) async {
                  if (await addFavorite(val, FavoriteType.TITLE) != null) {
                    setState(() {
                      favoriteTitles.insert(0, val);
                    });
                    newTitleController.clear();
                    addNewFocusNode.requestFocus();
                  }
                },
              ),
            ),
            IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: Icon(Icons.add_circle, size: 28,),
                onPressed: () async {
                  if (await addFavorite(
                          newTitleController.text, FavoriteType.TITLE) !=
                      null) {
                    setState(() {
                      favoriteTitles.insert(0, newTitleController.text);
                    });
                    newTitleController.clear();
                    addNewFocusNode.requestFocus();
                  }
                }),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: DataTable(
                headingRowHeight: 0,
                columns: const [
                  DataColumn(
                    label: Text(''),
                  ),
                  DataColumn(
                    label: Text(''),
                  ),
                ],
                rows: List<DataRow>.generate(
                  favoriteTitles.length,
                  (int index) => DataRow(
                    key: ValueKey(index),
                    cells: [
                      DataCell(Text(favoriteTitles[index])),
                      DataCell(IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            if (await removeFavorite(
                                favoriteTitles[index], FavoriteType.TITLE)) {
                              setState(() {
                                favoriteTitles.removeAt(index);
                              });
                            }
                          })),
                    ],
                  ),
                )),
          ),
        ),
      ],
    );
  }
}
