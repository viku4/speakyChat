import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speaky_chat/home_page/home_page_widget.dart';

import '../../api/api_services.dart';
import '../../screens/sign_up_page.dart';
import '../onboarding/otp_pin/otp_pin_model.dart';
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

class SignUpPage extends StatefulWidget {
  const SignUpPage(
      {Key? key,
      required this.uid,
      required this.phoneNumber,
      required this.phoneCode})
      : super(key: key);

  final String? uid, phoneNumber, phoneCode;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late OtpPinModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isImageSelected = false;
  bool imageUploaded = false;
  ImagePicker _imagePicker = new ImagePicker();
  late XFile _pickedFile;
  TextEditingController name = TextEditingController();
  String profilePhoto = '';
  File? _image;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences prefs;

  void _selectImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
        _image = File(pickedFile.path);
        isImageSelected = true;
      });
      uploadImage();
    }
  }

  void _takePhoto() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
        _image = File(pickedFile.path);
        isImageSelected = true;
      });
      uploadImage();
    }
  }

  bool isInProgress = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OtpPinModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
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
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: Align(
          alignment: AlignmentDirectional(0.0, 0.0),
          child: SingleChildScrollView(
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
                            'User Info',
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
                            'Enter Your Name And Set Your Profile Picture',
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
                        SizedBox(height: 30,),
                        GestureDetector(
                          onTap: () {
                            _showImageOptions();
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Container(
                              color: isImageSelected ? null : Colors.white,
                              width: 120,
                              height: 120,
                              child: isImageSelected
                                  ? Image.file(
                                      // Display selected image
                                      File(_pickedFile.path),
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(
                                      Icons.add_a_photo_outlined,
                                      size: 60,
                                      color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30,),
                        Container(
                          width: MediaQuery.of(context).size.width * .85,
                          padding: EdgeInsets.only(top: 17),
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white, width: 1)
                          ),
                          child: TextField(
                            controller: name,
                            style: TextStyle(
                              color: Colors.white
                            ),
                            decoration: InputDecoration(
                              hintText: 'Type Your Name Here',
                              hintStyle: TextStyle(color: Colors.white, fontSize: 15),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.zero,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                          child: Visibility(
                            visible: imageUploaded,
                            child: FFButtonWidget(
                              onPressed: () async {
                                prefs = await _prefs;
                                if (validate()) {

                                  // var response = await APIService.signUp(
                                  //   widget.uid!,
                                  //   name.text,
                                  //   widget.phoneNumber!,
                                  //   profilePhoto);
                                  // if (response.statusCode == 200) {
                                  //   Map<String, dynamic> jsonMap = json.decode(
                                  //       await response.stream.bytesToString());
                                  //   print("resp$jsonMap");
                                  //   if (jsonMap['message'] ==
                                  //       'Face has been successfully recognized') {
                                  //     if(jsonMap['EmployeeData'] != null){
                                  //       success(jsonMap['EmployeeData']['firstName'] +" "+ jsonMap['EmployeeData']['lastName'], jsonMap['EmployeeData']['employeeId'], jsonMap['EmployeeData']['attenddanceType']);
                                  //       await Future.delayed(Duration(seconds: 3));
                                  //       // Close the dialog after 5 seconds
                                  //       Navigator.pop(context);
                                  //       setState(() {
                                  //         isLoading = false;
                                  //       });
                                  //     }else{
                                  //       Fluttertoast.showToast(msg: "Some Error Occurred, Try Again!");
                                  //       setState(() {
                                  //         isLoading = false;
                                  //       });
                                  //     }
                                  //   } else {
                                  //     Fluttertoast.showToast(
                                  //         msg: jsonMap['message']);
                                  //     setState(() {
                                  //       isLoading = false;
                                  //     });
                                  //     // controller!.resumePreview();
                                  //   }
                                  // } else {
                                  //   setState(() {
                                  //     isLoading = false;
                                  //   });
                                  //   // controller!.resumePreview();
                                  //   print(await response.stream.bytesToString());
                                  //   // Map<String, dynamic> jsonMap = json.decode(await response.stream.bytesToString());
                                  //   Fluttertoast.showToast(
                                  //       msg:
                                  //       "Make Sure Your Face is clearly visible, Try Again");
                                  //   // print(jsonMap);
                                  // }
                                  var response = await APIService.signUp(widget.uid!, name.text, profilePhoto, widget.phoneNumber!);
                                  if(response["error"] != "User already exists"){
                                    prefs.setBool("isLoggedIn", true);
                                    var response = await APIService.login(prefs.getString('mobile') ?? '');
                                    await APIService.getProfile(FirebaseAuth.instance.currentUser!.uid);
                                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePageWidget()));
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => HomePageWidget()),
                                          (Route<dynamic> route) => false,
                                    );
                                  }
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => HomePageWidget()),
                                        (Route<dynamic> route) => false,
                                  );
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
    if (name.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please Enter Name");
      return false;
    }
    return true;
  }

  Future<void> verifyOTP(verId, String otp) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verId,
      smsCode: otp,
    );

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
      Fluttertoast.showToast(msg: "Invalid OTP");
      print("Error verifying OTP: $e");
      // You can show an error message to the user here
    }
  }

  processForward(
    String mobileNumber,
    UserCredential userCredential,
  ) async {
    // var response = APIService.login(widget.phoneNumber!, widget.phoneCode!);
    //
    // if(await response == "Success"){
    //   Fluttertoast.showToast(msg: "Welcome Back :)");
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   prefs.setString('mobile', widget.phoneNumber!).then((value) => print(value));
    //   prefs.setString('phoneCode', widget.phoneCode!).then((value) => print(value));
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NavBarPage()));
    // }else if(await response == "Not Registered"){
    //   Fluttertoast.showToast(msg: "OTP Verified");
    //   Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => SignUpPage()));
    // }else{
    //   Fluttertoast.showToast(msg: "Request failed with error code $response");
    // }
  }

  void _showImageOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose an option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _selectImage();
                },
                child: Text("Choose from Gallery"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
                child: Text("Take Photo"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future uploadImage() async {
    if (_image == null) {
      // No image selected
      return;
    }

    try {
      // Get the current time to create a unique filename
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      // Create a reference to the image path in Firebase Storage
      var storageReference = FirebaseStorage.instance.ref().child('images/${widget.uid}.jpg');
      // Upload the file to Firebase Storage
      await storageReference.putFile(_image!);

      // Get the download URL of the uploaded image
      String imageUrl = await storageReference.getDownloadURL();

      // Print the download URL (you can save this URL in your database if needed)
      print('Image uploaded: $imageUrl');
      setState(() {
        imageUploaded = true;
        profilePhoto = imageUrl;
      });
    } on FirebaseException catch (e) {
      print('Error uploading image: $e');
    }
  }
}