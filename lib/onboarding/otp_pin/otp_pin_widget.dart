import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speaky_chat/index.dart';

import '../../api/api_services.dart';
import '../../screens/sign_up_page.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'otp_pin_model.dart';
export 'otp_pin_model.dart';

class OtpPinWidget extends StatefulWidget {
  const OtpPinWidget(
      {Key? key,
      required this.verId,
      required this.phoneNumber,
      required this.phoneCode})
      : super(key: key);

  final String? verId, phoneNumber, phoneCode;

  @override
  _OtpPinWidgetState createState() => _OtpPinWidgetState();
}

class _OtpPinWidgetState extends State<OtpPinWidget> {
  late OtpPinModel _model;
  int _start = 60;
  late Timer _timer;
  var opacity = 0.4;
  late String verficationId;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isInProgress = false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences prefs;

  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  @override
  void initState() {
    super.initState();
    init();
    _model = createModel(context, () => OtpPinModel());
    startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    _timer.cancel();
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

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
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
              Get.back();
            },
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * .8,
                  constraints: BoxConstraints(
                    maxWidth: 570.0,
                  ),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                    child: Column(
                      // mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                          child: Text(
                            'Verify ${widget.phoneNumber}',
                            style: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .override(
                                  fontFamily: 'Arial Rounded MT Bold',
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 30.0, 16.0, 0.0),
                          child: Text(
                            'Waiting to automatically detect an SMS sent to.',
                            textAlign: TextAlign.start,
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  fontFamily: 'Comfortaa',
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 13.0,
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 10.0, 16.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${widget.phoneNumber}',
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Comfortaa',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize: 14.0,
                                    ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Text(
                                  '. Change Number?',
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: 'Comfortaa',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 14.0,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 24.0, 16.0, 0.0),
                          child: PinCodeTextField(
                            autoDisposeControllers: false,
                            appContext: context,
                            length: 6,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Readex Pro',
                                  color: FlutterFlowTheme.of(context).primaryText,
                                ),
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            enableActiveFill: false,
                            autoFocus: true,
                            enablePinAutofill: true,
                            errorTextSpace: 16.0,
                            showCursor: true,
                            cursorColor: FlutterFlowTheme.of(context).primaryText,
                            obscureText: false,
                            hintCharacter: '-',
                            keyboardType: TextInputType.number,
                            pinTheme: PinTheme(
                              fieldHeight: 50.0,
                              fieldWidth: 50.0,
                              borderWidth: 2.0,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(60.0),
                                bottomRight: Radius.circular(60.0),
                                topLeft: Radius.circular(60.0),
                                topRight: Radius.circular(60.0),
                              ),
                              shape: PinCodeFieldShape.box,
                              activeColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              inactiveColor: colorFromCssString(
                                _model.otperrorcolor,
                                defaultColor: Colors.black,
                              ),
                              activeFillColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              inactiveFillColor: colorFromCssString(
                                _model.otperrorcolor,
                                defaultColor: Colors.black,
                              ),
                            ),
                            controller: _model.pinCodeController,
                            onChanged: (_) {},
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: _model.pinCodeControllerValidator
                                .asValidator(context),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 8.0, 16.0, 15.0),
                          child: Text(
                            'Enter Six-digit code',
                            textAlign: TextAlign.start,
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  fontFamily: 'Comfortaa',
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 12.0,
                                ),
                          ),
                        ),
                        Divider(
                          thickness: 1.0,
                          color: FlutterFlowTheme.of(context).accent4,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Opacity(
                              opacity: opacity,
                              child: InkWell(
                                onTap: () async {
                                  setState(() {
                                    isInProgress = true;
                                  });
                                  await FirebaseAuth.instance.verifyPhoneNumber(
                                      verificationCompleted:
                                          (PhoneAuthCredential credential) {},
                                      verificationFailed: (FirebaseAuthException e) {
                                        Fluttertoast.showToast(
                                            msg: "Something Went Wrong!, Try Again");
                                        //     Fluttertoast.showToast(
                                        //     msg: e.toString());
                                        // e.toString();
                                        setState(() {
                                          isInProgress = false;
                                        });
                                      },
                                      codeSent: (String verId, int? resendToken) {
                                        Fluttertoast.showToast(msg: "OTP Sent");
                                        setState(() {
                                          isInProgress = false;
                                          verficationId = verId;
                                        });
                                      },
                                      codeAutoRetrievalTimeout:
                                          (String verificationId) {},
                                      timeout: Duration(seconds: 60),
                                      phoneNumber: widget.phoneNumber);
                                },
                                child: isInProgress ? Center(child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: SizedBox(width:18, height:18,child: CircularProgressIndicator()),
                                )) :Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.telegram_outlined,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      size: 24.0,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        'Resend code',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Comfortaa',
                                              fontSize: 12.0,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              timerText,
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                        if (_model.otperrorcolor == '#FF0000')
                          Stack(
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Color(0xFFFF0000),
                                      size: 24.0,
                                    ),
                                    Text(
                                      'Invalid OTP code',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Comfortaa',
                                            color: Color(0xFFFF0000),
                                            fontSize: 12.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Opacity(
                                opacity: 0.25,
                                child: Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Container(
                                    width: 140.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFF0000),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        Expanded(child: SizedBox()),
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                          child: isInProgress ? Center(child: CircularProgressIndicator()) : FFButtonWidget(
                            onPressed: () async {
                              if (validate()) {
                                setState(() {
                                  isInProgress = true;
                                });
                                verifyOTP(
                                    widget.verId, _model.pinCodeController.text);
                              }
                              // if (_model.pinCodeController!.text == '1234') {
                              //   setState(() {
                              //     _model.otperrorcolor = '#FFFFFF';
                              //   });
                              //   GoRouter.of(context).prepareAuthEvent();
                              //   if ('${_model.pinCodeController!.text}KPar@' !=
                              //       '${_model.pinCodeController!.text}KPar@') {
                              //     ScaffoldMessenger.of(context).showSnackBar(
                              //       SnackBar(
                              //         content: Text(
                              //           'Passwords don\'t match!',
                              //         ),
                              //       ),
                              //     );
                              //     return;
                              //   }
                              //
                              //   final user =
                              //   await authManager.createAccountWithEmail(
                              //     context,
                              //     'Speaky${(String var1) {
                              //       return var1.split(' ').length > 1
                              //           ? var1.split(' ')[1]
                              //           : '  ';
                              //     }(widget.phoneNumber!)}@gmail.com',
                              //     '${_model.pinCodeController!.text}KPar@',
                              //   );
                              //   print("email is: Speaky${(String var1) {
                              //     return var1.split(' ').length > 1
                              //         ? var1.split(' ')[1]
                              //         : '  ';
                              //   }(widget.phoneNumber!)}@gmail.com");
                              //   if (user == null) {
                              //     print("Error occured");
                              //     return;
                              //   }
                              //   context.goNamedAuth('HomePage', context.mounted);
                              // } else {
                              //   setState(() {
                              //     _model.otperrorcolor = '#FF0000';
                              //   });
                              //   setState(() {
                              //     _model.pinCodeController?.clear();
                              //   });
                              //   ScaffoldMessenger.of(context).clearSnackBars();
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(
                              //       content: Text(
                              //         'Incorrect OTP',
                              //         style: TextStyle(
                              //           color: FlutterFlowTheme.of(context).error,
                              //         ),
                              //       ),
                              //       duration: Duration(milliseconds: 1000),
                              //       backgroundColor:
                              //           FlutterFlowTheme.of(context).alternate,
                              //     ),
                              //   );
                              //   return;
                              // }
                              // context.goNamedAuth('HomePage', context.mounted);
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validate() {
    if (_model.pinCodeController.text.length < 6) {
      Fluttertoast.showToast(msg: "Code Length Can't be less than 6");
      return false;
    }
    return true;
  }

  Future<void> verifyOTP(verId, String otp) async {
    prefs = await _prefs;
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verId,
      smsCode: otp,
    );

    // if(otp == '123456'){
    //   processForward(widget.phoneNumber!);
    // }
    try {
      await FirebaseAuth.instance
          .signInWithCredential(phoneAuthCredential)
          .then((userCredential) {
        if (userCredential.user != null) {
          processForward(widget.phoneNumber!, userCredential);
        }
      });
    } catch (e) {
      // Incorrect OTP, display error to the user
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Incorrect OTP',
            style: TextStyle(
              color: FlutterFlowTheme.of(context).error,
            ),
          ),
          duration: Duration(milliseconds: 1000),
          backgroundColor: FlutterFlowTheme.of(context).alternate,
        ),
      );
      print("Error verifying OTP: $e");
      // You can show an error message to the user here
    }
  }

  processForward(
    String mobileNumber,
    UserCredential userCredential,
  ) async {
    var response = await APIService.login(widget.phoneNumber!);
    prefs = await _prefs;

    print(response["error"]);

    if(response["token"] != null){
      Fluttertoast.showToast(msg: "Welcome Back :)");
      prefs.setString('mobile', widget.phoneNumber!).then((value) => print(value));
      prefs.setString('phoneCode', widget.phoneCode!).then((value) => print(value));
      prefs.setString('token', response["token"]).then((value) => print(value));
      await APIService.getProfile(FirebaseAuth.instance.currentUser!.uid);
      prefs.setBool("isLoggedIn", true);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePageWidget()),
            (Route<dynamic> route) => false,
      );
      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePageWidget()));
    }else if(response["error"] == "Invalid credentials"){
      Fluttertoast.showToast(msg: "OTP Verified");
      prefs.setString('mobile', widget.phoneNumber!).then((value) => print(value));
      prefs.setString('phoneCode', widget.phoneCode!).then((value) => print(value));
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SignUpPage(uid: FirebaseAuth.instance.currentUser?.uid, phoneNumber: widget.phoneNumber, phoneCode: widget.phoneCode,)));
    }else{
      Fluttertoast.showToast(msg: "Request failed with error code $response");
    }
  }

  Future<void> init() async {
    verficationId = widget.verId!;
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          // Handle timer completion here
          print('Timer complete');
          setState(() {
            opacity = 1.0;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }
}
