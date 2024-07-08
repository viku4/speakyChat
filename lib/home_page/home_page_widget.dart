import 'dart:async';
import 'package:get/get.dart';
import 'home_page_model.dart';
import '../api/api_services.dart';
import '../model/chat_model.dart';
import '../helpers/network_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '/flutter_flow/instant_timer.dart';
import '../service/permission_service.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/chat/chat_all/chat_all_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:back_pressed/back_pressed.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:speaky_chat/screens/settings.dart';
import 'package:speaky_chat/status/status_page.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speaky_chat/flutter_flow/permissions_util.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:speaky_chat/screens/starred_messages_screen.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:speaky_chat/onboarding/o_t_p_login/o_t_p_login_widget.dart';


export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key, this.chatmodels, this.sourchat})
      : super(key: key);
  final List<ChatModel>? chatmodels;
  final ChatModel? sourchat;

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with TickerProviderStateMixin {
  late HomePageModel _model;

  ChatModel? sourceChat;
  List<ChatModel> chatmodels = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String name = '';
  String profilePhoto = '';
  String about = '';
  String mobile = '';

  final NetworkCheck networkCheck = NetworkCheck();
  late StreamSubscription<ConnectivityResult> subscription;
  final PermissionService _permissionService = PermissionService();

  @override
  void initState() {
    super.initState();
    requestPermissions();
    _model = createModel(context, () => HomePageModel());
    setProfileDetails();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.instantTimer = InstantTimer.periodic(
        duration: Duration(milliseconds: 1000),
        callback: (timer) async {
          FFAppState().appOpenUTCtime = functions.getCurrentUtcTimestamp();
        },
        startImmediately: true,
      );
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => setState(() {}));

    subscription = networkCheck.connectionStream.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
        onNetworkRestored();
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (_){
        if(_model.tabBarController?.index!=0){
          _model.tabBarController?.index = 0;
        }else{
          _onWillPop(context);
        }
      } ,
      child: GestureDetector(
        onTap: () => _model.unfocusNode.canRequestFocus
            ? FocusScope.of(context).requestFocus(_model.unfocusNode)
            : FocusScope.of(context).unfocus(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Speaky Chat',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 22.0,
                      ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FFButtonWidget(
                      onPressed: () async {
                        GoRouter.of(context).prepareAuthEvent();
                        // await authManager.signOut();
                        GoRouter.of(context).clearRedirectLocation();

                        context.goNamedAuth('IntroPage', context.mounted);
                      },
                      text: 'Button',
                      options: FFButtonOptions(
                        height: 40.0,
                        padding:
                            EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.white,
                                ),
                        elevation: 3.0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 0.0),
                      child: Icon(
                        Icons.search_outlined,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        size: 26.0,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.bottomSheet(
                          _buildBottomSheet(),
                          backgroundColor: Colors.transparent,
                        );
                      },
                      child: Stack(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        children: [
                          Icon(
                            Icons.hexagon_outlined,
                            color:
                                FlutterFlowTheme.of(context).secondaryBackground,
                            size: 24.0,
                          ),
                          FaIcon(
                            FontAwesomeIcons.circle,
                            color:
                                FlutterFlowTheme.of(context).secondaryBackground,
                            size: 8.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [],
            centerTitle: false,
            elevation: 2.0,
          ),
          body: SafeArea(
            top: true,
            child: Column(
              children: [
                TabBar(
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.white,
                  ),
                  dividerColor: Colors.transparent,
                  labelStyle: FlutterFlowTheme.of(context).labelMedium,
                  // indicatorSize: TabBarIndicatorSize.tab,
                  unselectedLabelStyle: TextStyle(),
                  labelColor: FlutterFlowTheme.of(context).secondaryText,
                  unselectedLabelColor:
                      FlutterFlowTheme.of(context).secondaryBackground,
                  padding: EdgeInsets.all(4.0),
                  tabs: [
                    Tab(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white, width: 2)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("CONVO"),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white, width: 2)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("STORIES"),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white, width: 2)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("LOGS"),
                        ),
                      ),
                    ),
                  ],
                  controller: _model.tabBarController,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _model.tabBarController,
                    children: [
                      KeepAliveWidgetWrapper(
                        builder: (context) => wrapWithModel(
                          model: _model.chatAllModel,
                          updateCallback: () => setState(() {}),
                          child: ChatAllWidget(
                            chatmodels: chatmodels,
                            sourchat: sourceChat,
                          ),
                        ),
                      ),
                      KeepAliveWidgetWrapper(
                        builder: (context) => StatusPage()
                      ),
                      KeepAliveWidgetWrapper(
                        builder: (context) => Text(
                          'Tab View 4',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: ' Comic Sans MS',
                                fontSize: 32.0,
                                useGoogleFonts: false,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                border: Border(
                    bottom: BorderSide.none,
                    top: BorderSide(color: Colors.white))),
            child: Image.asset(
              'assets/images/img.png',
              height: 4,
            ),
          ),
          _buildBottomSheetButton('SETTINGS'),
          _buildBottomSheetButton('WALLPAPER'),
          _buildBottomSheetButton('ARCHIVED CONVOS'),
          _buildBottomSheetButton('MARK ALL READ'),
          _buildBottomSheetButton('NEW BROADCAST'),
          _buildBottomSheetButton('STARRED MESSAGES'),
        ],
      ),
    );
  }

  Widget _buildBottomSheetButton(String text) {
    return InkWell(
      child: Container(
          height: 46,
          child: Column(
            children: [
              Text(
                text,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 5,
              ),
              Divider()
            ],
          )),
      onTap: () {
        setProfileDetails();
        // Handle button tap
        if (text == "SETTINGS") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SettingsPage(
                        profile_pic: profilePhoto,
                      )));
        }else if (text == "STARRED MESSAGES") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => StarredMessagesScreen(
                    // profile_pic: profilePhoto,
                  )));
        } else {
          Get.back(); // Close the bottom sheet
        }
      },
    );
  }

  Future<void> setProfileDetails() async {
    var sessionManager = new SessionManager();
    name = await sessionManager.get("username");
    profilePhoto = await sessionManager.get("profile_pic");
    about = await sessionManager.get("about");
    mobile = await sessionManager.get("mobilenumber");
  }

  Future<bool> _onWillPop(BuildContext contexta) async {
    return (await showDialog(
      context: contexta,
      builder: (contexta) => AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to exit the App'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Get.back(),
          child: Text('No'),
        ),
        TextButton(
          onPressed: () {
           SystemNavigator.pop();
    },
          child: Text('Yes'),
        ),
      ],
    ),
    )) ??
    false;
  }

  Future<void> onNetworkRestored() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    var response = await APIService.login(prefs.getString('mobile') ?? '');
    await APIService.getProfile(FirebaseAuth.instance.currentUser!.uid);
    await Future.delayed(const Duration(milliseconds: 2000), () {});
    if(response['token'] != null){
      // Get.off(() => HomePageWidget());
      // Navigator.push(context, MaterialPageRoute(builder: (context) => SelectUser()));
    }else{
      Fluttertoast.showToast(msg: "Session Expired, Login Again!");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OTPLoginWidget()));
    }
  }

  void requestPermissions() async{
    await _permissionService.requestPermissions();
  }

}