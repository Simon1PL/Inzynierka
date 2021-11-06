import 'package:flutter/material.dart';
import 'package:project/enums/favorite_type.dart';
import 'package:project/services/favorite_service.dart';
import 'package:project/services/globals.dart';

class FavoriteAlert extends StatefulWidget {
  final String title, episode;

  FavoriteAlert(this.title, this.episode);

  @override
  FavoriteAlertState createState() =>
      FavoriteAlertState(this.title, this.episode);
}

class FavoriteAlertState extends State<FavoriteAlert> {
  final String title, episode;
  late final _titleController;
  FavoriteType favoriteType = FavoriteType.EPISODE;

  FavoriteAlertState(this.title, this.episode) {
    _titleController = TextEditingController()..text = title;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RadioListTile<FavoriteType>(
          title: Text('Add the exact episode\n($episode)'),
          value: FavoriteType.EPISODE,
          groupValue: favoriteType,
          onChanged: (FavoriteType? value) {
            setState(() {
              favoriteType = value!;
            });
          },
        ),
        RadioListTile<FavoriteType>(
          title: Text('Add title\n(' + _titleController.text! + ")"),
          value: FavoriteType.TITLE,
          groupValue: favoriteType,
          onChanged: (FavoriteType? value) {
            setState(() {
              favoriteType = value!;
            });
          },
        ),
        TextField(
          textInputAction: TextInputAction.next,
          controller: _titleController,
          autofocus: true,
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            filled: true,
          ),
        ),
        TextButton(
          child: Text(
            "Add",
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: () async {
            var text = favoriteType == FavoriteType.TITLE
                ? _titleController.text
                : episode;
            var res = await addFavorite(text, favoriteType);
            Navigator.pop(navigatorKey.currentContext!, res);
          },
        )
      ],
    );
  }
}
