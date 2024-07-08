import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:async';
import 'uploads_b_s_widget.dart' show UploadsBSWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UploadsBSModel extends FlutterFlowModel<UploadsBSWidget> {
  ///  Local state fields for this component.

  int? loopinitial = 0;

  int? loopmax;

  ///  State fields for stateful widgets in this component.

  bool isDataUploading = false;
  List<FFUploadedFile> uploadedLocalFiles = [];
  List<String> uploadedFileUrls = [];

  // Stores action output result for [Backend Call - Insert Row] action in Stack widget.
  // AChatMessagesRow? insertChatMessages;
  // Stores action output result for [Backend Call - Insert Row] action in Stack widget.
  // AMediaRow? insertMedia;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {}

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
