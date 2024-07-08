import 'package:flutter/material.dart';
import '/flutter_flow/instant_timer.dart';
import '/chat/chat_all/chat_all_widget.dart';
import '../chat/chat_all/chat_all_model.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_page_widget.dart' show HomePageWidget;

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  InstantTimer? instantTimer;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Model for chatAll component.
  late ChatAllModel chatAllModel;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    chatAllModel = createModel(context, () => ChatAllModel());
  }

  void dispose() {
    unfocusNode.dispose();
    instantTimer?.cancel();
    tabBarController?.dispose();
    chatAllModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
