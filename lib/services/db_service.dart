import 'package:isar/isar.dart';
import 'package:project/enums/isar_collection.dart';
import 'package:project/isar.g.dart';
import 'package:project/models/program_model.dart';
import 'package:project/services/favorite_service.dart';
import 'package:project/services/programs_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


// !!! command to start build_runner: dart run build_runner build

class DbService {
  //Singleton pattern
  static final DbService _dbService = DbService._internal();
  late final Isar isar;

  factory DbService() {
    return _dbService;
  }

  DbService._internal();

  Future init() async {
    isar = await openIsar();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var wasNeverLoaded = pref.getBool("isLoadingProgramsFromDb") == null;
    if (wasNeverLoaded) await loadProgramsFromDb();
    else loadProgramsFromDb();
  }
}

Future<void> updateProgram(ProgramModel program) async {
  await DbService().isar.writeTxn((isar) => isar.programModels.where().filter().channelIdEqualTo(program.channelId).and().startEqualTo(program.start).deleteFirst());
  await DbService().isar.writeTxn((isar) => isar.programModels.put(program));
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

Future<void> loadProgramsFromDb() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var isLoading = pref.getBool("isLoadingProgramsFromDb");
  if (isLoading == true) return;

  pref.setBool("isLoadingProgramsFromDb", true);

  var oldProgramsIds = await DbService().isar.programModels.where().idProperty().findAll();
  List<ProgramModel> epg = await loadEpgFromDb() ?? [];
  epg.forEach((e)=>e.isarCollectionType = IsarCollectionType.EPG);
  List<ProgramModel> recorded = await loadRecordedFromDb() ?? [];
  recorded.forEach((e)=>e.isarCollectionType = IsarCollectionType.RECORDED);
  List<ProgramModel> scheduled = await loadScheduledFromDb() ?? [];
  scheduled.forEach((e)=>e.isarCollectionType = IsarCollectionType.SCHEDULED);
  var programs = [...recorded, ...scheduled, ...epg];
  programs = await fillFavoritesDataInProgramList(programs);
  savePrograms(programs);
  removePrograms(oldProgramsIds.cast<int>());

  pref.setBool("isLoadingProgramsFromDb", false);
}
