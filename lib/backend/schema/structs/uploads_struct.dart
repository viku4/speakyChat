// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UploadsStruct extends BaseStruct {
  UploadsStruct({
    String? type,
    List<String>? pathStrings,
  })  : _type = type,
        _pathStrings = pathStrings;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  set type(String? val) => _type = val;
  bool hasType() => _type != null;

  // "path_strings" field.
  List<String>? _pathStrings;
  List<String> get pathStrings => _pathStrings ?? const [];
  set pathStrings(List<String>? val) => _pathStrings = val;
  void updatePathStrings(Function(List<String>) updateFn) =>
      updateFn(_pathStrings ??= []);
  bool hasPathStrings() => _pathStrings != null;

  static UploadsStruct fromMap(Map<String, dynamic> data) => UploadsStruct(
        type: data['type'] as String?,
        pathStrings: getDataList(data['path_strings']),
      );

  static UploadsStruct? maybeFromMap(dynamic data) =>
      data is Map ? UploadsStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'type': _type,
        'path_strings': _pathStrings,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'type': serializeParam(
          _type,
          ParamType.String,
        ),
        'path_strings': serializeParam(
          _pathStrings,
          ParamType.String,
          true,
        ),
      }.withoutNulls;

  static UploadsStruct fromSerializableMap(Map<String, dynamic> data) =>
      UploadsStruct(
        type: deserializeParam(
          data['type'],
          ParamType.String,
          false,
        ),
        pathStrings: deserializeParam<String>(
          data['path_strings'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'UploadsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is UploadsStruct &&
        type == other.type &&
        listEquality.equals(pathStrings, other.pathStrings);
  }

  @override
  int get hashCode => const ListEquality().hash([type, pathStrings]);
}

UploadsStruct createUploadsStruct({
  String? type,
}) =>
    UploadsStruct(
      type: type,
    );
