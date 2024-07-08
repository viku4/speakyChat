import 'package:flutter/material.dart';
import 'flutter_flow/request_manager.dart';
import '/backend/schema/structs/index.dart';
import 'backend/api_requests/api_manager.dart';
import 'backend/supabase/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  DateTime? _appOpenUTCtime;
  DateTime? get appOpenUTCtime => _appOpenUTCtime;
  set appOpenUTCtime(DateTime? _value) {
    _appOpenUTCtime = _value;
  }

  // final _chatdetailApplevelManager =
  //     FutureRequestManager<List<AChatSummaryViewRow>>();
  // Future<List<AChatSummaryViewRow>> chatdetailApplevel({
  //   String? uniqueQueryKey,
  //   bool? overrideCache,
  //   required Future<List<AChatSummaryViewRow>> Function() requestFn,
  // }) =>
  //     _chatdetailApplevelManager.performRequest(
  //       uniqueQueryKey: uniqueQueryKey,
  //       overrideCache: overrideCache,
  //       requestFn: requestFn,
  //     );
  // void clearChatdetailApplevelCache() => _chatdetailApplevelManager.clear();
  // void clearChatdetailApplevelCacheKey(String? uniqueKey) =>
  //     _chatdetailApplevelManager.clearRequest(uniqueKey);

  // final _chatdetailsApplevelManager =
  //     FutureRequestManager<List<AChatMessagesInfoViewRow>>();
  // Future<List<AChatMessagesInfoViewRow>> chatdetailsApplevel({
  //   String? uniqueQueryKey,
  //   bool? overrideCache,
  //   required Future<List<AChatMessagesInfoViewRow>> Function() requestFn,
  // }) =>
  //     _chatdetailsApplevelManager.performRequest(
  //       uniqueQueryKey: uniqueQueryKey,
  //       overrideCache: overrideCache,
  //       requestFn: requestFn,
  //     );
  // void clearChatdetailsApplevelCache() => _chatdetailsApplevelManager.clear();
  // void clearChatdetailsApplevelCacheKey(String? uniqueKey) =>
  //     _chatdetailsApplevelManager.clearRequest(uniqueKey);
}

LatLng? _latLngFromString(String? val) {
  if (val == null) {
    return null;
  }
  final split = val.split(',');
  final lat = double.parse(split.first);
  final lng = double.parse(split.last);
  return LatLng(lat, lng);
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
