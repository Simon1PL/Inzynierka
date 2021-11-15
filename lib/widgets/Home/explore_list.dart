import 'package:flutter/material.dart';
import 'package:project/models/program_model.dart';
import 'package:project/widgets/Home/program_item.dart';
import 'package:project/services/favorite_service.dart';
import 'package:project/services/programs_service.dart';
import 'package:project/widgets/Shared/loader.dart';

class ExploreList extends StatefulWidget {

  @override
  _ExploreList createState() => _ExploreList();
}

class _ExploreList extends State<ExploreList> {
  List<ProgramModel>? liked;

  @override
  void initState() {
    super.initState();
  }

  Future<List<ProgramModel>> loadExplore() async {
    var programs = await getEpg() ?? [];
    programs = programs.where((p) => p.start!.isAfter(DateTime.now())).toList();
    var favorites = await getFavorites();
    var favTitles = favorites[1] ?? [];
    var favEpisodes = favorites[0] ?? [];
    var recordedOrScheduled = await getRecorded() ?? [];
    recordedOrScheduled.addAll(await getScheduled() ?? []);
    var notScheduled = programs.where((e) => !recordedOrScheduled.contains(e.title));
    var liked = notScheduled.where((e) => favTitles.any((favTitle) => e.title!.contains(favTitle))).toList();
    liked.forEach((element) {element.favorite2 = true;});
    var liked2 = notScheduled.where((e) => favEpisodes.contains(e.title)).toList();
    liked2.forEach((element) {element.favorite = true;});
    liked.addAll(liked2);
    liked.shuffle();
    var notLiked = notScheduled.toList().where((p) => !p.favorite && !p.favorite2).toList();
    notLiked.shuffle();
    liked.addAll(notLiked.take(250));
    return liked;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 185,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: FutureBuilder<List<ProgramModel>>(
          future: loadExplore(),
          builder: (BuildContext context, AsyncSnapshot<List<ProgramModel>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return Loader();
              default:
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                else
                  return ListView.builder(
                      primary: false,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ProgramHomeItem(ValueKey(snapshot.data![index]), snapshot.data![index]);
                      });
            }
          },
        )
      ),
    );
  }
}
