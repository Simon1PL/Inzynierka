// ignore_for_file: unused_import, implementation_imports

import 'dart:ffi';
import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:io';
import 'package:isar/isar.dart';
import 'package:isar/src/isar_native.dart';
import 'package:isar/src/query_builder.dart';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as p;
import 'models/program_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:project/enums/isar_collection.dart';

const _utf8Encoder = Utf8Encoder();

final _schema =
    '[{"name":"ProgramModel","idProperty":"id","properties":[{"name":"id","type":3},{"name":"isarCollectionType","type":3},{"name":"orderId","type":3},{"name":"channelName","type":5},{"name":"channelId","type":5},{"name":"start","type":3},{"name":"stop","type":3},{"name":"title","type":5},{"name":"subtitle","type":5},{"name":"description","type":5},{"name":"recordSize","type":3},{"name":"fileName","type":5},{"name":"favorite","type":0},{"name":"favorite2","type":0},{"name":"alreadyScheduled","type":0},{"name":"genre","type":11},{"name":"summary","type":5},{"name":"channelNumber","type":5}],"indexes":[{"unique":false,"replace":false,"properties":[{"name":"title","indexType":2,"caseSensitive":true}]}],"links":[]}]';

Future<Isar> openIsar(
    {String name = 'isar',
    String? directory,
    int maxSize = 1000000000,
    Uint8List? encryptionKey}) async {
  final path = await _preparePath(directory);
  return openIsarInternal(
      name: name,
      directory: path,
      maxSize: maxSize,
      encryptionKey: encryptionKey,
      schema: _schema,
      getCollections: (isar) {
        final collectionPtrPtr = malloc<Pointer>();
        final propertyOffsetsPtr = malloc<Uint32>(18);
        final propertyOffsets = propertyOffsetsPtr.asTypedList(18);
        final collections = <String, IsarCollection>{};
        nCall(IC.isar_get_collection(isar.ptr, collectionPtrPtr, 0));
        IC.isar_get_property_offsets(
            collectionPtrPtr.value, propertyOffsetsPtr);
        collections['ProgramModel'] = IsarCollectionImpl<ProgramModel>(
          isar: isar,
          adapter: _ProgramModelAdapter(),
          ptr: collectionPtrPtr.value,
          propertyOffsets: propertyOffsets.sublist(0, 18),
          propertyIds: {
            'id': 0,
            'isarCollectionType': 1,
            'orderId': 2,
            'channelName': 3,
            'channelId': 4,
            'start': 5,
            'stop': 6,
            'title': 7,
            'subtitle': 8,
            'description': 9,
            'recordSize': 10,
            'fileName': 11,
            'favorite': 12,
            'favorite2': 13,
            'alreadyScheduled': 14,
            'genre': 15,
            'summary': 16,
            'channelNumber': 17
          },
          indexIds: {'title': 0},
          linkIds: {},
          backlinkIds: {},
          getId: (obj) => obj.id,
          setId: (obj, id) => obj.id = id,
        );
        malloc.free(propertyOffsetsPtr);
        malloc.free(collectionPtrPtr);

        return collections;
      });
}

Future<String> _preparePath(String? path) async {
  if (path == null || p.isRelative(path)) {
    WidgetsFlutterBinding.ensureInitialized();
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, path ?? 'isar');
  } else {
    return path;
  }
}

class _ProgramModelAdapter extends TypeAdapter<ProgramModel> {
  static const _IsarCollectionTypeConverter = IsarCollectionTypeConverter();

  @override
  int serialize(IsarCollectionImpl<ProgramModel> collection, RawObject rawObj,
      ProgramModel object, List<int> offsets,
      [int? existingBufferSize]) {
    var dynamicSize = 0;
    final value0 = object.id;
    final _id = value0;
    final value1 = _ProgramModelAdapter._IsarCollectionTypeConverter.toIsar(
        object.isarCollectionType);
    final _isarCollectionType = value1;
    final value2 = object.orderId;
    final _orderId = value2;
    final value3 = object.channelName;
    Uint8List? _channelName;
    if (value3 != null) {
      _channelName = _utf8Encoder.convert(value3);
    }
    dynamicSize += _channelName?.length ?? 0;
    final value4 = object.channelId;
    Uint8List? _channelId;
    if (value4 != null) {
      _channelId = _utf8Encoder.convert(value4);
    }
    dynamicSize += _channelId?.length ?? 0;
    final value5 = object.start;
    final _start = value5;
    final value6 = object.stop;
    final _stop = value6;
    final value7 = object.title;
    Uint8List? _title;
    if (value7 != null) {
      _title = _utf8Encoder.convert(value7);
    }
    dynamicSize += _title?.length ?? 0;
    final value8 = object.subtitle;
    Uint8List? _subtitle;
    if (value8 != null) {
      _subtitle = _utf8Encoder.convert(value8);
    }
    dynamicSize += _subtitle?.length ?? 0;
    final value9 = object.description;
    Uint8List? _description;
    if (value9 != null) {
      _description = _utf8Encoder.convert(value9);
    }
    dynamicSize += _description?.length ?? 0;
    final value10 = object.recordSize;
    final _recordSize = value10;
    final value11 = object.fileName;
    Uint8List? _fileName;
    if (value11 != null) {
      _fileName = _utf8Encoder.convert(value11);
    }
    dynamicSize += _fileName?.length ?? 0;
    final value12 = object.favorite;
    final _favorite = value12;
    final value13 = object.favorite2;
    final _favorite2 = value13;
    final value14 = object.alreadyScheduled;
    final _alreadyScheduled = value14;
    final value15 = object.genre;
    dynamicSize += (value15.length) * 8;
    final bytesList15 = <Uint8List>[];
    for (var str in value15) {
      final bytes = _utf8Encoder.convert(str);
      bytesList15.add(bytes);
      dynamicSize += bytes.length;
    }
    final _genre = bytesList15;
    final value16 = object.summary;
    Uint8List? _summary;
    if (value16 != null) {
      _summary = _utf8Encoder.convert(value16);
    }
    dynamicSize += _summary?.length ?? 0;
    final value17 = object.channelNumber;
    Uint8List? _channelNumber;
    if (value17 != null) {
      _channelNumber = _utf8Encoder.convert(value17);
    }
    dynamicSize += _channelNumber?.length ?? 0;
    final size = dynamicSize + 125;

    late int bufferSize;
    if (existingBufferSize != null) {
      if (existingBufferSize < size) {
        malloc.free(rawObj.buffer);
        rawObj.buffer = malloc(size);
        bufferSize = size;
      } else {
        bufferSize = existingBufferSize;
      }
    } else {
      rawObj.buffer = malloc(size);
      bufferSize = size;
    }
    rawObj.buffer_length = size;
    final buffer = rawObj.buffer.asTypedList(size);
    final writer = BinaryWriter(buffer, 125);
    writer.writeLong(offsets[0], _id);
    writer.writeLong(offsets[1], _isarCollectionType);
    writer.writeLong(offsets[2], _orderId);
    writer.writeBytes(offsets[3], _channelName);
    writer.writeBytes(offsets[4], _channelId);
    writer.writeDateTime(offsets[5], _start);
    writer.writeDateTime(offsets[6], _stop);
    writer.writeBytes(offsets[7], _title);
    writer.writeBytes(offsets[8], _subtitle);
    writer.writeBytes(offsets[9], _description);
    writer.writeLong(offsets[10], _recordSize);
    writer.writeBytes(offsets[11], _fileName);
    writer.writeBool(offsets[12], _favorite);
    writer.writeBool(offsets[13], _favorite2);
    writer.writeBool(offsets[14], _alreadyScheduled);
    writer.writeStringList(offsets[15], _genre);
    writer.writeBytes(offsets[16], _summary);
    writer.writeBytes(offsets[17], _channelNumber);
    return bufferSize;
  }

  @override
  ProgramModel deserialize(IsarCollectionImpl<ProgramModel> collection,
      BinaryReader reader, List<int> offsets) {
    final object = ProgramModel();
    object.id = reader.readLongOrNull(offsets[0]);
    object.isarCollectionType =
        _ProgramModelAdapter._IsarCollectionTypeConverter.fromIsar(
            reader.readLong(offsets[1]));
    object.orderId = reader.readLongOrNull(offsets[2]);
    object.channelName = reader.readStringOrNull(offsets[3]);
    object.channelId = reader.readStringOrNull(offsets[4]);
    object.start = reader.readDateTimeOrNull(offsets[5]);
    object.stop = reader.readDateTimeOrNull(offsets[6]);
    object.title = reader.readStringOrNull(offsets[7]);
    object.subtitle = reader.readStringOrNull(offsets[8]);
    object.description = reader.readStringOrNull(offsets[9]);
    object.recordSize = reader.readLongOrNull(offsets[10]);
    object.fileName = reader.readStringOrNull(offsets[11]);
    object.favorite = reader.readBool(offsets[12]);
    object.favorite2 = reader.readBool(offsets[13]);
    object.alreadyScheduled = reader.readBool(offsets[14]);
    object.genre = reader.readStringList(offsets[15]) ?? [];
    object.summary = reader.readStringOrNull(offsets[16]);
    object.channelNumber = reader.readStringOrNull(offsets[17]);
    return object;
  }

  @override
  P deserializeProperty<P>(BinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case 0:
        return (reader.readLongOrNull(offset)) as P;
      case 1:
        return (_ProgramModelAdapter._IsarCollectionTypeConverter.fromIsar(
            reader.readLong(offset))) as P;
      case 2:
        return (reader.readLongOrNull(offset)) as P;
      case 3:
        return (reader.readStringOrNull(offset)) as P;
      case 4:
        return (reader.readStringOrNull(offset)) as P;
      case 5:
        return (reader.readDateTimeOrNull(offset)) as P;
      case 6:
        return (reader.readDateTimeOrNull(offset)) as P;
      case 7:
        return (reader.readStringOrNull(offset)) as P;
      case 8:
        return (reader.readStringOrNull(offset)) as P;
      case 9:
        return (reader.readStringOrNull(offset)) as P;
      case 10:
        return (reader.readLongOrNull(offset)) as P;
      case 11:
        return (reader.readStringOrNull(offset)) as P;
      case 12:
        return (reader.readBool(offset)) as P;
      case 13:
        return (reader.readBool(offset)) as P;
      case 14:
        return (reader.readBool(offset)) as P;
      case 15:
        return (reader.readStringList(offset) ?? []) as P;
      case 16:
        return (reader.readStringOrNull(offset)) as P;
      case 17:
        return (reader.readStringOrNull(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }
}

extension GetCollection on Isar {
  IsarCollection<ProgramModel> get programModels {
    return getCollection('ProgramModel');
  }
}

extension ProgramModelQueryWhereSort on QueryBuilder<ProgramModel, QWhere> {
  QueryBuilder<ProgramModel, QAfterWhere> anyId() {
    return addWhereClause(WhereClause(indexName: 'id'));
  }
}

extension ProgramModelQueryWhere on QueryBuilder<ProgramModel, QWhereClause> {
  QueryBuilder<ProgramModel, QAfterWhereClause> titleWordEqualTo(
      String? title) {
    return addWhereClause(WhereClause(
      indexName: 'title',
      upper: [title],
      includeUpper: true,
      lower: [title],
      includeLower: true,
    ));
  }

  QueryBuilder<ProgramModel, QAfterWhereClause> titleWordStartsWith(
      String? value) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addWhereClause(WhereClause(
      indexName: 'title',
      lower: [convertedValue],
      upper: ['$convertedValue\u{FFFFF}'],
      includeLower: true,
      includeUpper: true,
    ));
  }
}

extension ProgramModelQueryFilter
    on QueryBuilder<ProgramModel, QFilterCondition> {
  QueryBuilder<ProgramModel, QAfterFilterCondition> idIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> idEqualTo(int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> idGreaterThan(int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> idLessThan(int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> idBetween(
      int? lower, int? upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'id',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> isarCollectionTypeEqualTo(
      IsarCollectionType value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'isarCollectionType',
      value: _ProgramModelAdapter._IsarCollectionTypeConverter.toIsar(value),
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition>
      isarCollectionTypeGreaterThan(IsarCollectionType value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'isarCollectionType',
      value: _ProgramModelAdapter._IsarCollectionTypeConverter.toIsar(value),
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> isarCollectionTypeLessThan(
      IsarCollectionType value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'isarCollectionType',
      value: _ProgramModelAdapter._IsarCollectionTypeConverter.toIsar(value),
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> isarCollectionTypeBetween(
      IsarCollectionType lower, IsarCollectionType upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'isarCollectionType',
      lower: _ProgramModelAdapter._IsarCollectionTypeConverter.toIsar(lower),
      upper: _ProgramModelAdapter._IsarCollectionTypeConverter.toIsar(upper),
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> orderIdIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'orderId',
      value: null,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> orderIdEqualTo(int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'orderId',
      value: value,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> orderIdGreaterThan(
      int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'orderId',
      value: value,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> orderIdLessThan(
      int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'orderId',
      value: value,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> orderIdBetween(
      int? lower, int? upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'orderId',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> channelNameIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'channelName',
      value: null,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> channelNameEqualTo(
      String? value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'channelName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> channelNameStartsWith(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.StartsWith,
      property: 'channelName',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> channelNameEndsWith(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.EndsWith,
      property: 'channelName',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> channelNameContains(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'channelName',
      value: '*$convertedValue*',
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> channelNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'channelName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> channelIdIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'channelId',
      value: null,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> channelIdEqualTo(
      String? value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'channelId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> channelIdStartsWith(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.StartsWith,
      property: 'channelId',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> channelIdEndsWith(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.EndsWith,
      property: 'channelId',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> channelIdContains(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'channelId',
      value: '*$convertedValue*',
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> channelIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'channelId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> startIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'start',
      value: null,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> startEqualTo(
      DateTime? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'start',
      value: value,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> startGreaterThan(
      DateTime? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'start',
      value: value,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> startLessThan(
      DateTime? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'start',
      value: value,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> startBetween(
      DateTime? lower, DateTime? upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'start',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> stopIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'stop',
      value: null,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> stopEqualTo(
      DateTime? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'stop',
      value: value,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> stopGreaterThan(
      DateTime? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'stop',
      value: value,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> stopLessThan(
      DateTime? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'stop',
      value: value,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> stopBetween(
      DateTime? lower, DateTime? upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'stop',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> titleIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'title',
      value: null,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> titleEqualTo(String? value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'title',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> titleStartsWith(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.StartsWith,
      property: 'title',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> titleEndsWith(String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.EndsWith,
      property: 'title',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> titleContains(String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'title',
      value: '*$convertedValue*',
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> titleMatches(String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'title',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> subtitleIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'subtitle',
      value: null,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> subtitleEqualTo(
      String? value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'subtitle',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> subtitleStartsWith(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.StartsWith,
      property: 'subtitle',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> subtitleEndsWith(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.EndsWith,
      property: 'subtitle',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> subtitleContains(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'subtitle',
      value: '*$convertedValue*',
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> subtitleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'subtitle',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> descriptionIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'description',
      value: null,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> descriptionEqualTo(
      String? value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'description',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> descriptionStartsWith(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.StartsWith,
      property: 'description',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> descriptionEndsWith(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.EndsWith,
      property: 'description',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> descriptionContains(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'description',
      value: '*$convertedValue*',
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'description',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> recordSizeIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'recordSize',
      value: null,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> recordSizeEqualTo(
      int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'recordSize',
      value: value,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> recordSizeGreaterThan(
      int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'recordSize',
      value: value,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> recordSizeLessThan(
      int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'recordSize',
      value: value,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> recordSizeBetween(
      int? lower, int? upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'recordSize',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> fileNameIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'fileName',
      value: null,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> fileNameEqualTo(
      String? value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'fileName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> fileNameStartsWith(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.StartsWith,
      property: 'fileName',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> fileNameEndsWith(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.EndsWith,
      property: 'fileName',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> fileNameContains(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'fileName',
      value: '*$convertedValue*',
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> fileNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'fileName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> favoriteEqualTo(
      bool value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'favorite',
      value: value,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> favorite2EqualTo(
      bool value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'favorite2',
      value: value,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> alreadyScheduledEqualTo(
      bool value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'alreadyScheduled',
      value: value,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> summaryIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'summary',
      value: null,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> summaryEqualTo(
      String? value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'summary',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> summaryStartsWith(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.StartsWith,
      property: 'summary',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> summaryEndsWith(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.EndsWith,
      property: 'summary',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> summaryContains(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'summary',
      value: '*$convertedValue*',
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> summaryMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'summary',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> channelNumberIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'channelNumber',
      value: null,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> channelNumberEqualTo(
      String? value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'channelNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> channelNumberStartsWith(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.StartsWith,
      property: 'channelNumber',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> channelNumberEndsWith(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.EndsWith,
      property: 'channelNumber',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> channelNumberContains(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'channelNumber',
      value: '*$convertedValue*',
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProgramModel, QAfterFilterCondition> channelNumberMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'channelNumber',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension ProgramModelQueryLinks
    on QueryBuilder<ProgramModel, QFilterCondition> {}

extension ProgramModelQueryWhereSortBy on QueryBuilder<ProgramModel, QSortBy> {
  QueryBuilder<ProgramModel, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByIsarCollectionType() {
    return addSortByInternal('isarCollectionType', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByIsarCollectionTypeDesc() {
    return addSortByInternal('isarCollectionType', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByOrderId() {
    return addSortByInternal('orderId', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByOrderIdDesc() {
    return addSortByInternal('orderId', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByChannelName() {
    return addSortByInternal('channelName', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByChannelNameDesc() {
    return addSortByInternal('channelName', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByChannelId() {
    return addSortByInternal('channelId', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByChannelIdDesc() {
    return addSortByInternal('channelId', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByStart() {
    return addSortByInternal('start', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByStartDesc() {
    return addSortByInternal('start', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByStop() {
    return addSortByInternal('stop', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByStopDesc() {
    return addSortByInternal('stop', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByTitle() {
    return addSortByInternal('title', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByTitleDesc() {
    return addSortByInternal('title', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortBySubtitle() {
    return addSortByInternal('subtitle', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortBySubtitleDesc() {
    return addSortByInternal('subtitle', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByDescription() {
    return addSortByInternal('description', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByDescriptionDesc() {
    return addSortByInternal('description', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByRecordSize() {
    return addSortByInternal('recordSize', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByRecordSizeDesc() {
    return addSortByInternal('recordSize', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByFileName() {
    return addSortByInternal('fileName', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByFileNameDesc() {
    return addSortByInternal('fileName', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByFavorite() {
    return addSortByInternal('favorite', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByFavoriteDesc() {
    return addSortByInternal('favorite', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByFavorite2() {
    return addSortByInternal('favorite2', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByFavorite2Desc() {
    return addSortByInternal('favorite2', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByAlreadyScheduled() {
    return addSortByInternal('alreadyScheduled', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByAlreadyScheduledDesc() {
    return addSortByInternal('alreadyScheduled', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortBySummary() {
    return addSortByInternal('summary', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortBySummaryDesc() {
    return addSortByInternal('summary', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByChannelNumber() {
    return addSortByInternal('channelNumber', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> sortByChannelNumberDesc() {
    return addSortByInternal('channelNumber', Sort.Desc);
  }
}

extension ProgramModelQueryWhereSortThenBy
    on QueryBuilder<ProgramModel, QSortThenBy> {
  QueryBuilder<ProgramModel, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByIsarCollectionType() {
    return addSortByInternal('isarCollectionType', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByIsarCollectionTypeDesc() {
    return addSortByInternal('isarCollectionType', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByOrderId() {
    return addSortByInternal('orderId', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByOrderIdDesc() {
    return addSortByInternal('orderId', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByChannelName() {
    return addSortByInternal('channelName', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByChannelNameDesc() {
    return addSortByInternal('channelName', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByChannelId() {
    return addSortByInternal('channelId', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByChannelIdDesc() {
    return addSortByInternal('channelId', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByStart() {
    return addSortByInternal('start', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByStartDesc() {
    return addSortByInternal('start', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByStop() {
    return addSortByInternal('stop', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByStopDesc() {
    return addSortByInternal('stop', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByTitle() {
    return addSortByInternal('title', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByTitleDesc() {
    return addSortByInternal('title', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenBySubtitle() {
    return addSortByInternal('subtitle', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenBySubtitleDesc() {
    return addSortByInternal('subtitle', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByDescription() {
    return addSortByInternal('description', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByDescriptionDesc() {
    return addSortByInternal('description', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByRecordSize() {
    return addSortByInternal('recordSize', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByRecordSizeDesc() {
    return addSortByInternal('recordSize', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByFileName() {
    return addSortByInternal('fileName', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByFileNameDesc() {
    return addSortByInternal('fileName', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByFavorite() {
    return addSortByInternal('favorite', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByFavoriteDesc() {
    return addSortByInternal('favorite', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByFavorite2() {
    return addSortByInternal('favorite2', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByFavorite2Desc() {
    return addSortByInternal('favorite2', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByAlreadyScheduled() {
    return addSortByInternal('alreadyScheduled', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByAlreadyScheduledDesc() {
    return addSortByInternal('alreadyScheduled', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenBySummary() {
    return addSortByInternal('summary', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenBySummaryDesc() {
    return addSortByInternal('summary', Sort.Desc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByChannelNumber() {
    return addSortByInternal('channelNumber', Sort.Asc);
  }

  QueryBuilder<ProgramModel, QAfterSortBy> thenByChannelNumberDesc() {
    return addSortByInternal('channelNumber', Sort.Desc);
  }
}

extension ProgramModelQueryWhereDistinct
    on QueryBuilder<ProgramModel, QDistinct> {
  QueryBuilder<ProgramModel, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<ProgramModel, QDistinct> distinctByIsarCollectionType() {
    return addDistinctByInternal('isarCollectionType');
  }

  QueryBuilder<ProgramModel, QDistinct> distinctByOrderId() {
    return addDistinctByInternal('orderId');
  }

  QueryBuilder<ProgramModel, QDistinct> distinctByChannelName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('channelName', caseSensitive: caseSensitive);
  }

  QueryBuilder<ProgramModel, QDistinct> distinctByChannelId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('channelId', caseSensitive: caseSensitive);
  }

  QueryBuilder<ProgramModel, QDistinct> distinctByStart() {
    return addDistinctByInternal('start');
  }

  QueryBuilder<ProgramModel, QDistinct> distinctByStop() {
    return addDistinctByInternal('stop');
  }

  QueryBuilder<ProgramModel, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('title', caseSensitive: caseSensitive);
  }

  QueryBuilder<ProgramModel, QDistinct> distinctBySubtitle(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('subtitle', caseSensitive: caseSensitive);
  }

  QueryBuilder<ProgramModel, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('description', caseSensitive: caseSensitive);
  }

  QueryBuilder<ProgramModel, QDistinct> distinctByRecordSize() {
    return addDistinctByInternal('recordSize');
  }

  QueryBuilder<ProgramModel, QDistinct> distinctByFileName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('fileName', caseSensitive: caseSensitive);
  }

  QueryBuilder<ProgramModel, QDistinct> distinctByFavorite() {
    return addDistinctByInternal('favorite');
  }

  QueryBuilder<ProgramModel, QDistinct> distinctByFavorite2() {
    return addDistinctByInternal('favorite2');
  }

  QueryBuilder<ProgramModel, QDistinct> distinctByAlreadyScheduled() {
    return addDistinctByInternal('alreadyScheduled');
  }

  QueryBuilder<ProgramModel, QDistinct> distinctBySummary(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('summary', caseSensitive: caseSensitive);
  }

  QueryBuilder<ProgramModel, QDistinct> distinctByChannelNumber(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('channelNumber', caseSensitive: caseSensitive);
  }
}

extension ProgramModelQueryProperty
    on QueryBuilder<ProgramModel, QQueryProperty> {
  QueryBuilder<int?, QQueryOperations> idProperty() {
    return addPropertyName('id');
  }

  QueryBuilder<IsarCollectionType, QQueryOperations>
      isarCollectionTypeProperty() {
    return addPropertyName('isarCollectionType');
  }

  QueryBuilder<int?, QQueryOperations> orderIdProperty() {
    return addPropertyName('orderId');
  }

  QueryBuilder<String?, QQueryOperations> channelNameProperty() {
    return addPropertyName('channelName');
  }

  QueryBuilder<String?, QQueryOperations> channelIdProperty() {
    return addPropertyName('channelId');
  }

  QueryBuilder<DateTime?, QQueryOperations> startProperty() {
    return addPropertyName('start');
  }

  QueryBuilder<DateTime?, QQueryOperations> stopProperty() {
    return addPropertyName('stop');
  }

  QueryBuilder<String?, QQueryOperations> titleProperty() {
    return addPropertyName('title');
  }

  QueryBuilder<String?, QQueryOperations> subtitleProperty() {
    return addPropertyName('subtitle');
  }

  QueryBuilder<String?, QQueryOperations> descriptionProperty() {
    return addPropertyName('description');
  }

  QueryBuilder<int?, QQueryOperations> recordSizeProperty() {
    return addPropertyName('recordSize');
  }

  QueryBuilder<String?, QQueryOperations> fileNameProperty() {
    return addPropertyName('fileName');
  }

  QueryBuilder<bool, QQueryOperations> favoriteProperty() {
    return addPropertyName('favorite');
  }

  QueryBuilder<bool, QQueryOperations> favorite2Property() {
    return addPropertyName('favorite2');
  }

  QueryBuilder<bool, QQueryOperations> alreadyScheduledProperty() {
    return addPropertyName('alreadyScheduled');
  }

  QueryBuilder<List<String>, QQueryOperations> genreProperty() {
    return addPropertyName('genre');
  }

  QueryBuilder<String?, QQueryOperations> summaryProperty() {
    return addPropertyName('summary');
  }

  QueryBuilder<String?, QQueryOperations> channelNumberProperty() {
    return addPropertyName('channelNumber');
  }
}
