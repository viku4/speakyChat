import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';

String? getOtherUsers(
  List<String> nicknamesList,
  List<String> userIdList,
  String authUser,
) {
  // Creating a new list that excludes the code at the found index.
  if (nicknamesList.length != userIdList.length) {
    throw ArgumentError(
        "The \"codes\" and \"words\" lists must be of the same length.");
  }

  int index = userIdList.indexOf(authUser);
  if (index == -1) {
    throw ArgumentError("\"targetWord\" not found in the \"words\" list.");
  }

  var otherCodes = List.of(nicknamesList)..removeAt(index);

  return otherCodes.join(', ');
}

DateTime? getCurrentUtcTimestamp() {
  return DateTime.now().toUtc();
}
