import 'dart:developer';
import 'package:get/get.dart';
import 'o_t_p_login_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speaky_chat/index.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';


export 'o_t_p_login_model.dart';

class OTPLoginWidget extends StatefulWidget {
  const OTPLoginWidget({Key? key}) : super(key: key);

  @override
  _OTPLoginWidgetState createState() => _OTPLoginWidgetState();
}

class _OTPLoginWidgetState extends State<OTPLoginWidget> {
  late OTPLoginModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  var verificationId = "";
  bool isInProgress = false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences prefs;

  final animationsMap = {
    'textOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0.0, 70.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    init();
    _model = createModel(context, () => OTPLoginModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();
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

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 60.0,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).secondaryBackground,
            size: 30.0,
          ),
          onPressed: () async {
            context.pop();
          },
        ),
        actions: [],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
                  child: Text(
                    'Verify your Phone Number',
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily: 'Arial Rounded MT Bold',
                          fontSize: 22.0,
                          useGoogleFonts: false,
                        ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxWidth: 570.0,
                  ),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (responsiveVisibility(
                        context: context,
                        phone: false,
                        tablet: false,
                      ))
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 44.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 12.0, 0.0),
                                child: FlutterFlowIconButton(
                                  borderColor: Colors.transparent,
                                  borderRadius: 30.0,
                                  borderWidth: 1.0,
                                  buttonSize: 44.0,
                                  icon: Icon(
                                    Icons.arrow_back_rounded,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    context.pop();
                                  },
                                ),
                              ),
                              Text(
                                'Phone Sign In',
                                style:
                                    FlutterFlowTheme.of(context).headlineSmall,
                              ),
                            ],
                          ),
                        ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 50.0, 16.0, 0.0),
                              child: Text(
                                'Speaky will send an message to verify your phone number. Enter your country code and phone number',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Comfortaa',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w100,
                                    ),
                              ).animateOnPageLoad(
                                  animationsMap['textOnPageLoadAnimation']!),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 25.0, 0.0, 0.0),
                  child: FlutterFlowDropDown<String>(
                    controller: _model.dropDownValueController ??=
                        FormFieldController<String>(
                      _model.dropDownValue ??= '+91',
                    ),
                    options: List<String>.from(['+91', '+1']),
                    optionLabels: ['India', 'USA'],
                    onChanged: (val) =>
                        setState(() => _model.dropDownValue = val),
                    width: 300.0,
                    height: 50.0,
                    textStyle: FlutterFlowTheme.of(context).bodyMedium,
                    hintText: 'Country',
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      size: 24.0,
                    ),
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    elevation: 2.0,
                    borderColor:
                        FlutterFlowTheme.of(context).secondaryBackground,
                    borderWidth: 2.0,
                    borderRadius: 25.0,
                    margin:
                        EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                    hidesUnderline: true,
                    isSearchable: false,
                    isMultiSelect: false,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            width: 2.0,
                          ),
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Text(
                            _model.dropDownValue!,
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context).bodyMedium,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                        child: Container(
                          width: 197.0,
                          child: TextFormField(
                            controller: _model.textController3,
                            focusNode: _model.textFieldFocusNode3,
                            autofocus: true,
                            obscureText: false,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle:
                                  FlutterFlowTheme.of(context).bodyMedium,
                              hintStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                  ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            style: FlutterFlowTheme.of(context).bodyMedium,
                            keyboardType: TextInputType.number,
                            validator: _model.textController3Validator
                                .asValidator(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                  child: isInProgress
                      ? CircularProgressIndicator()
                      : FFButtonWidget(
                          onPressed: () async {
                            if (validate()) {
                              showGetDialog(
                                  "We Will Be Verifying Your Phone Number: \n${_model.dropDownValue!} ${_model.textController3.text}",
                                  "Is This Ok, Or Would You Like To Change The Phone Number?",
                                  true);
                              // context.pushNamed(
                              //   'OtpPin',
                              //   queryParameters: {
                              //     'otpnumber': serializeParam(
                              //       '${_model.dropDownValue} ${_model.textController3.text}',
                              //       ParamType.String,
                              //     ),
                              //   }.withoutNulls,
                              // );
                            }
                          },
                          text: 'NEXT',
                          options: FFButtonOptions(
                            width: 150.0,
                            height: 50.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Arial Rounded MT Bold',
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  fontWeight: FontWeight.w900,
                                  useGoogleFonts: false,
                                ),
                            elevation: 3.0,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Carrier SMS Charges May Apply",
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Comfortaa',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w100,
                      ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool validate() {
    if (_model.textController3.text.isEmpty) {
      Fluttertoast.showToast(msg: "Phone Number Can't Be Empty");
      return false;
    } else if (_model.textController3.text.length != 10) {
      showGetDialog(
          "${_model.dropDownValue!} ${_model.textController3.text}",
          "Is Not A Valid Mobile Number For The Country ${_model.dropDownValue == "+91" ? "India" : "USA"}",
          false);
      return false;
    }
    return true;
  }

  void showGetDialog(String mobileNumber, String message, bool isCorrect) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                mobileNumber,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: isCorrect,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        'EXIT',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(),
                  ElevatedButton(
                    onPressed: () async {
                      if (isCorrect) {
                        setState(() {
                          isInProgress = true;
                        });
                        Get.back();
                        await FirebaseAuth.instance.verifyPhoneNumber(
                            verificationCompleted:
                                (PhoneAuthCredential credential) {},
                            verificationFailed: (FirebaseAuthException e) {
                              log(e.toString());
                              // Fluttertoast.showToast(
                              //     msg: "Something Went Wrong!, Try Again");
                                  Fluttertoast.showToast(
                                  msg: e.toString());
                              // e.toString();
                              setState(() {
                                isInProgress = false;
                              });
                            },
                            codeSent: (String verId, int? resendToken) {
                               log("OTP Sent");
                              Fluttertoast.showToast(msg: "OTP Sent");
                              setState(() {
                                isInProgress = false;
                              });
                              verificationId = verId;
                              Get.to(() => OtpPinWidget(
                                    verId: verificationId,
                                    phoneNumber:
                                        "+91" + _model.textController3.text,
                                    phoneCode: _model.dropDownValue,
                                  ));
                            },
                            codeAutoRetrievalTimeout:
                                (String verificationId) {
                                   log("OTP Sent verificationId");
                                },
                            timeout: Duration(seconds: 60),
                            phoneNumber: mobileNumber);
                      } else {
                        Get.back();
                      }
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> init() async {
    prefs = await _prefs;
    bool isTermsAccepted = prefs.getBool("isLoggedIn") ?? false;
  }
}
