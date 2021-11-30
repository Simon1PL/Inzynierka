import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:project/enums/isar_collection.dart';
import 'package:project/isar.g.dart';
import 'package:project/models/program_model.dart';
import 'package:project/services/alert_service.dart';
import 'package:project/services/favorite_service.dart';
import 'package:project/services/globals.dart';
import 'package:project/services/programs_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


// !!! command to start build_runner: dart run build_runner build

class DbService {
  //Singleton pattern
  static final DbService _dbService = DbService._internal();
  late final Isar isar;
  int lastProgramsDbModificationDate = 0;

  factory DbService() {
    return _dbService;
  }

  DbService._internal();

  Future<bool> init() async {
    isar = await openIsar();
    loadProgramsFromDb(true);
    return true;
  }
}

Future<void> updateProgram(ProgramModel program) async {
  DbService().lastProgramsDbModificationDate = DateTime.now().millisecondsSinceEpoch;

  var sameFromEpg = await DbService().isar.programModels.where().filter().channelIdEqualTo(program.channelId).and().startEqualTo(program.start).and().isarCollectionTypeEqualTo(IsarCollectionType.EPG).findFirst();

  await DbService().isar.writeTxn((isar) => isar.programModels.where().filter().channelIdEqualTo(program.channelId).and().startEqualTo(program.start).deleteAll());

  if (program.alreadyScheduled && program.orderId != null) {
    program.id = null;
    program.isarCollectionType = IsarCollectionType.SCHEDULED;
    await DbService().isar.writeTxn((isar) => isar.programModels.put(program));
    print(program.id);
  }
  if (program.alreadyScheduled && program.orderId == null) {
    program.id = null;
    program.isarCollectionType = IsarCollectionType.RECORDED;
    await DbService().isar.writeTxn((isar) => isar.programModels.put(program));
  }
  if (sameFromEpg != null) {
    program.id = sameFromEpg.id;
    program.isarCollectionType = IsarCollectionType.EPG;
    await DbService().isar.writeTxn((isar) => isar.programModels.put(program));
  }

  DbService().lastProgramsDbModificationDate = DateTime.now().millisecondsSinceEpoch;
}

Future<void> savePrograms(List<ProgramModel> programs) async {
  await DbService().isar.writeTxn((isar) => isar.programModels.putAll(programs));
}

Future<void> removePrograms(List<int> programsIds) async {
  await DbService().isar.writeTxn((isar) => isar.programModels.deleteAll(programsIds));
}

Future<List<ProgramModel>> getPrograms() async {
  return await DbService().isar.programModels.where().findAll();
}

Future<List<ProgramModel>> getEpg() async {
  return await DbService().isar.programModels.where().filter().isarCollectionTypeEqualTo(IsarCollectionType.EPG).findAll();
}

Future<List<ProgramModel>> getScheduled() async {
  return await DbService().isar.programModels.where().filter().isarCollectionTypeEqualTo(IsarCollectionType.SCHEDULED).findAll();
}

Future<List<ProgramModel>> getRecorded() async {
  return await DbService().isar.programModels.where().filter().isarCollectionTypeEqualTo(IsarCollectionType.RECORDED).findAll();
}

Future<bool> loadProgramsFromDb([bool recursive = false]) async {
  print("LOADING DATA FROM SERVER");
  var loadProgramsDate = DateTime.now().millisecondsSinceEpoch;
  DbService().lastProgramsDbModificationDate = loadProgramsDate - 1;
  var oldProgramsIds = await DbService().isar.programModels.where().idProperty().findAll();
  List<ProgramModel> epg = await loadEpgFromDb() ?? [];
  epg.forEach((e)=>e.isarCollectionType = IsarCollectionType.EPG);
  List<ProgramModel> recorded = await loadRecordedFromDb() ?? [];
  recorded.forEach((e)=>e.isarCollectionType = IsarCollectionType.RECORDED);
  List<ProgramModel> scheduled = await loadScheduledFromDb() ?? [];
  scheduled.forEach((e)=>e.isarCollectionType = IsarCollectionType.SCHEDULED);
  var programs = [...recorded, ...scheduled, ...epg];
  programs = await fillFavoritesDataInProgramList(programs);

  if (!recursive || DbService().lastProgramsDbModificationDate < loadProgramsDate) {
    await savePrograms(programs);
    await removePrograms(oldProgramsIds.cast<int>());
    print("DATA FROM SERVER LOADED");
    if (recursive) {
      Timer(Duration(seconds: 15), () => loadProgramsFromDb(true));
    }
    return true;
  }

  if (recursive) {
    Timer(Duration(seconds: 10), () => loadProgramsFromDb(true));
  }
  return false;
}

dataFromServerRequired([String alertText = "Loading data from server, please wait..."]) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setBool("needsDataFromServer", true);
  showLoadingDataFromServerAlert(alertText);
  await loadProgramsFromDb();
  pref.setBool("needsDataFromServer", false);
  Navigator.of(navigatorKey.currentContext!).pop();
}
