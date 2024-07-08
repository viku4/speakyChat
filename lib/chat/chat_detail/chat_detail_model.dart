// import '/auth/supabase_auth/auth_util.dart';
// import '/backend/supabase/supabase.dart';
// import '/chat/chat_messages/chat_messages_widget.dart';
// import '/chat/delete_dialog/delete_dialog_widget.dart';
// import '/chat/user_list_small/user_list_small_widget.dart';
// import '/components/audiorec_b_s_widget.dart';
// import '/components/uploads_b_s_widget.dart';
// import '/flutter_flow/flutter_flow_animations.dart';
// import '/flutter_flow/flutter_flow_icon_button.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import '/flutter_flow/instant_timer.dart';
// import 'dart:async';
// import '/flutter_flow/custom_functions.dart' as functions;
// import '/flutter_flow/request_manager.dart';
//
// import 'chat_detail_widget.dart' show ChatDetailWidget;
// import 'dart:async';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
//
// class ChatDetailModel extends FlutterFlowModel<ChatDetailWidget> {
//   ///  Local state fields for this page.
//
//   String textMsg = '';
//
//   DateTime? inchatTime;
//
//   ///  State fields for stateful widgets in this page.
//
//   final unfocusNode = FocusNode();
//   final formKey = GlobalKey<FormState>();
//   InstantTimer? instantTimer;
//   bool requestCompleted = false;
//   String? requestLastUniqueKey;
//   // State field(s) for TextField widget.
//   FocusNode? textFieldFocusNode;
//   TextEditingController? textController;
//   String? Function(BuildContext, String?)? textControllerValidator;
//   // Stores action output result for [Backend Call - Insert Row] action in IconButton widget.
//   AChatMessagesRow? insertChatsMessages;
//   // Stores action output result for [Backend Call - Update Row] action in IconButton widget.
//   List<AChatsRow>? updateChats;
//   // Model for user_ListSmall component.
//   late UserListSmallModel userListSmallModel;
//   // Model for deleteDialog component.
//   late DeleteDialogModel deleteDialogModel;
//
//   /// Query cache managers for this widget.
//
//   final _useridPagelevelManager = FutureRequestManager<List<AUsersInfoRow>>();
//   Future<List<AUsersInfoRow>> useridPagelevel({
//     String? uniqueQueryKey,
//     bool? overrideCache,
//     required Future<List<AUsersInfoRow>> Function() requestFn,
//   }) =>
//       _useridPagelevelManager.performRequest(
//         uniqueQueryKey: uniqueQueryKey,
//         overrideCache: overrideCache,
//         requestFn: requestFn,
//       );
//   void clearUseridPagelevelCache() => _useridPagelevelManager.clear();
//   void clearUseridPagelevelCacheKey(String? uniqueKey) =>
//       _useridPagelevelManager.clearRequest(uniqueKey);
//
//   /// Initialization and disposal methods.
//
//   void initState(BuildContext context) {
//     userListSmallModel = createModel(context, () => UserListSmallModel());
//     deleteDialogModel = createModel(context, () => DeleteDialogModel());
//   }
//
//   void dispose() {
//     unfocusNode.dispose();
//     instantTimer?.cancel();
//     textFieldFocusNode?.dispose();
//     textController?.dispose();
//
//     userListSmallModel.dispose();
//     deleteDialogModel.dispose();
//
//     /// Dispose query cache managers for this widget.
//
//     clearUseridPagelevelCache();
//   }
//
//   /// Action blocks are added here.
//
//   /// Additional helper methods are added here.
//
//   Future waitForRequestCompleted({
//     double minWait = 0,
//     double maxWait = double.infinity,
//   }) async {
//     final stopwatch = Stopwatch()..start();
//     while (true) {
//       await Future.delayed(Duration(milliseconds: 50));
//       final timeElapsed = stopwatch.elapsedMilliseconds;
//       final requestComplete = requestCompleted;
//       if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
//         break;
//       }
//     }
//   }
// }
