import 'package:isar/isar.dart';

enum IsarCollectionType {
  NONE,
  EPG,
  RECORDED,
  SCHEDULED,
}

class IsarCollectionTypeConverter extends TypeConverter<IsarCollectionType, int> {
  const IsarCollectionTypeConverter(); // Converters need to have an empty const constructor

  @override
  IsarCollectionType fromIsar(int isarCollectionTypeIndex) {
    return IsarCollectionType.values[isarCollectionTypeIndex];
  }

  @override
  int toIsar(IsarCollectionType isarCollectionType) {
    return isarCollectionType.index;
  }
}