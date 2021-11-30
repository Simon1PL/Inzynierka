import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:project/enums/favorite_type.dart';
import 'package:project/models/program_model.dart';
import 'dart:convert';
import 'package:project/services/alert_service.dart';
import 'package:project/services/globals.dart';
import 'package:project/services/notifications_service.dart';
import 'package:project/widgets/Shared/favoriteAlert.dart';
import "package:collection/collection.dart";

Future<List<List<String>?>> getFavorites() async {
  try {
    Response response = await serverGet("favorites");
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Status code: " +
          response.statusCode.toString() +
          "\n" +
          utf8.decode(response.bodyBytes));
    }

    List<dynamic> objects = response.bodyBytes.isNotEmpty
        ? jsonDecode(utf8.decode(response.bodyBytes))
        : response.bodyBytes;
    List<List<dynamic>> favorites =
        objects.map((p) => List<dynamic>.from(p)).toList();
    Map<dynamic, List<List>> favoritesMap =
        groupBy(favorites, (List<dynamic> obj) => obj[1]);
    var favTitles = favoritesMap[FavoriteType.TITLE.index == 0 ? false : true]
            ?.map((e) => e[0].toString())
            .toList() ??
        [];
    var favEpisodes = favoritesMap[FavoriteType.EPISODE.index == 0 ? false : true]
            ?.map((e) => e[0].toString())
            .toList() ??
        [];
    return [favEpisodes, favTitles];
  } catch (e) {
    print(e);
    return [null, null];
  }
}

Future<FavoriteType?> addFavorite(String favorite,
    [FavoriteType? favoriteType]) async {
  try {
    if (favorite.isEmpty) {
      showSnackBar("Can't add empty favorite");
      return null;
    }
    int index = favorite.indexOf(RegExp(r'-|s\.|e\.|odc\.'));
    if (favoriteType == null && index != -1) {
      return showFavoriteAlert(favorite.substring(0, index).trim(), favorite);
    } else if (favoriteType == null) {
      favoriteType = FavoriteType.EPISODE;
    }

    Response response = await serverPost("favorites?name=" +
        favorite +
        "&series=" +
        favoriteType.index.toString());
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusCode.toString() +
          " - " +
          utf8.decode(response.bodyBytes));
    }

    NotificationService().afterFavoriteChangeRefreshNotification();
    return favoriteType;
  } catch (e) {
    if (e.toString().contains("already added")) {
      showSnackBar("$favorite is already in favorites");
      return favoriteType;
    } else {
      showSnackBar("Some error occurs, can't add favorite");
      print(e);
    }
    return null;
  }
}

Future<bool> removeFavorite(String favorite,
    [FavoriteType favoriteType = FavoriteType.EPISODE]) async {
  try {
    Response response = await serverDelete("favorites?name=" +
        favorite +
        "&series=" +
        favoriteType.index.toString());
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusCode.toString() +
          " - " +
          utf8.decode(response.bodyBytes));
    }

    return true;
  } catch (e) {
    print(e);
    showSnackBar("Some error occurs, can't remove favorite");
    return false;
  }
}

Future<FavoriteType?> showFavoriteAlert(String title, String episode) async {
  AlertDialog alert = AlertDialog(
    content: FavoriteAlert(title, episode),
  );

  FavoriteType? result = await showDialog(
    context: navigatorKey.currentContext!,
    builder: (BuildContext context) {
      return alert;
    },
  );

  return result;
}

Future<List<ProgramModel>> fillFavoritesDataInProgramList(
    List<ProgramModel> list) async {
  var tmp = await getFavorites();
  List<String>? favorites = tmp[0];
  if (favorites != null) {
    list.forEach((element) {
      if (favorites.contains(element.title)) element.favorite = true;
    });
  }

  List<String>? favorites2 = tmp[1];
  if (favorites2 != null) {
    list.forEach((element) {
      if (element.title != null &&
          favorites2.any(
              (e) => element.title!.toLowerCase().contains(e.toLowerCase())))
        element.favorite2 = true;
    });
  }

  return list;
}
