import 'package:flutter/material.dart';
import 'package:project/enums/favorite_type.dart';
import 'package:project/models/program_model.dart';
import 'package:project/services/db_service.dart';
import 'package:project/services/favorite_service.dart';

class FavoriteIcon extends StatefulWidget {
  final ProgramModel program;
  final Function() refreshParent;

  FavoriteIcon(this.program, this.refreshParent);

  @override
  _FavoriteIcon createState() => _FavoriteIcon(program, refreshParent);
}

class _FavoriteIcon extends State<FavoriteIcon> {
  final ProgramModel program;
  final Function() refreshParent;

  _FavoriteIcon(this.program, this.refreshParent);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!program.favorite) {
          var res = await addFavorite(program.title!);
          if (res == FavoriteType.EPISODE) {
            setState(() {
              program.favorite = true;
            });
          }
          else if (res == FavoriteType.TITLE) {
            setState(() {
              program.favorite2 = true;
            });
            refreshParent();
          }
        } else {
          if (await removeFavorite(program.title!)) {
            setState(() {
              program.favorite = false;
            });
          }
        }
        await updateProgram(program);
      },
      child: Icon(
        program.favorite
            ? Icons.favorite
            : Icons.favorite_border,
        size: 30,
        color: program.favorite ? Colors.blue : Colors.black,
      ),
    );
  }
}
