import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speaky_chat/screens/privacy.dart';

import '../api/api_services.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';

class UpdateProfilePage extends StatefulWidget {
  var name;

  var profile_pic;

  var about;

  var mobile;

  UpdateProfilePage(
      {super.key,
      required this.name,
      required this.profile_pic,
      required this.about,
      required this.mobile});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String lastSeen = 'Nobody';
  bool isImageSelected = false, isImageFetched = false;
  bool imageUploaded = false;
  ImagePicker _imagePicker = new ImagePicker();
  late XFile _pickedFile;
  TextEditingController name = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  String username = '';
  String profilePhoto = '';
  String about = '';
  File? _image;
  bool? _isUploading = false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences prefs;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_isUploading!) {
          Fluttertoast.showToast(msg: 'Please wait while the image uploads');
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
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
                    padding:
                        EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                    child: Column(
                      // mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 10.0, 0.0, 0.0),
                          child: Text(
                            'User Info',
                            style: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .override(
                                  fontFamily: 'Arial Rounded MT Bold',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            _showImageOptions();
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: _isUploading! ? CircularProgressIndicator() : isImageFetched
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: CachedNetworkImage(
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                              child: SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 1,
                                                    color: Colors.red,
                                                  ))),
                                      imageUrl: widget.profile_pic,
                                    ))
                                : Container(
                                    color:
                                        isImageSelected ? null : Colors.white,
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
                        SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () {
                            Get.bottomSheet(
                              _buildNameSheet(),
                              backgroundColor: Colors.transparent,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 18.0, right: 18, bottom: 3, top: 3),
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.user,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Name',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                      Text(username,
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.white)),
                                    ],
                                  ),
                                ),
                                Icon(
                                  FontAwesomeIcons.pencil,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                        InkWell(
                          onTap: () {
                            Get.bottomSheet(
                              _buildAboutSheet(),
                              backgroundColor: Colors.transparent,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 18.0, right: 18, bottom: 3, top: 3),
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.info,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'About',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                      Text(
                                        about,
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.white),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  FontAwesomeIcons.pencil,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 18.0, right: 18, bottom: 3, top: 3),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.phone,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Phone',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                    Text(
                                      widget.mobile,
                                      style: TextStyle(
                                          fontSize: 22, color: Colors.white),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        // Padding(
                        //   padding:
                        //   EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                        //   child: Visibility(
                        //     visible: imageUploaded,
                        //     child: FFButtonWidget(
                        //       onPressed: () async {
                        //         prefs = await _prefs;
                        //         if (validate()) {
                        //
                        //           // var response = await APIService.signUp(
                        //           //   widget.uid!,
                        //           //   name.text,
                        //           //   widget.phoneNumber!,
                        //           //   profilePhoto);
                        //           // if (response.statusCode == 200) {
                        //           //   Map<String, dynamic> jsonMap = json.decode(
                        //           //       await response.stream.bytesToString());
                        //           //   print("resp$jsonMap");
                        //           //   if (jsonMap['message'] ==
                        //           //       'Face has been successfully recognized') {
                        //           //     if(jsonMap['EmployeeData'] != null){
                        //           //       success(jsonMap['EmployeeData']['firstName'] +" "+ jsonMap['EmployeeData']['lastName'], jsonMap['EmployeeData']['employeeId'], jsonMap['EmployeeData']['attenddanceType']);
                        //           //       await Future.delayed(Duration(seconds: 3));
                        //           //       // Close the dialog after 5 seconds
                        //           //       Navigator.pop(context);
                        //           //       setState(() {
                        //           //         isLoading = false;
                        //           //       });
                        //           //     }else{
                        //           //       Fluttertoast.showToast(msg: "Some Error Occurred, Try Again!");
                        //           //       setState(() {
                        //           //         isLoading = false;
                        //           //       });
                        //           //     }
                        //           //   } else {
                        //           //     Fluttertoast.showToast(
                        //           //         msg: jsonMap['message']);
                        //           //     setState(() {
                        //           //       isLoading = false;
                        //           //     });
                        //           //     // controller!.resumePreview();
                        //           //   }
                        //           // } else {
                        //           //   setState(() {
                        //           //     isLoading = false;
                        //           //   });
                        //           //   // controller!.resumePreview();
                        //           //   print(await response.stream.bytesToString());
                        //           //   // Map<String, dynamic> jsonMap = json.decode(await response.stream.bytesToString());
                        //           //   Fluttertoast.showToast(
                        //           //       msg:
                        //           //       "Make Sure Your Face is clearly visible, Try Again");
                        //           //   // print(jsonMap);
                        //           // }
                        //           // var response = await APIService.signUp(widget.uid!, name.text, profilePhoto, widget.phoneNumber!);
                        //           // if(response["error"] != "User already exists"){
                        //           //   prefs.setBool("isLoggedIn", true);
                        //           //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePageWidget()));
                        //           // }
                        //           // Get.to(() => HomePageWidget());
                        //         }
                        //       },
                        //       text: 'NEXT',
                        //       options: FFButtonOptions(
                        //         width: 150.0,
                        //         height: 50.0,
                        //         padding: EdgeInsetsDirectional.fromSTEB(
                        //             0.0, 0.0, 0.0, 0.0),
                        //         iconPadding: EdgeInsetsDirectional.fromSTEB(
                        //             0.0, 0.0, 0.0, 0.0),
                        //         color: FlutterFlowTheme.of(context)
                        //             .secondaryBackground,
                        //         textStyle: FlutterFlowTheme.of(context)
                        //             .titleSmall
                        //             .override(
                        //           fontFamily: 'Arial Rounded MT Bold',
                        //           color: FlutterFlowTheme.of(context)
                        //               .secondaryText,
                        //           fontWeight: FontWeight.w900,
                        //           useGoogleFonts: false,
                        //         ),
                        //         elevation: 3.0,
                        //         borderSide: BorderSide(
                        //           color: Colors.transparent,
                        //           width: 1.0,
                        //         ),
                        //         borderRadius: BorderRadius.circular(50.0),
                        //       ),
                        //     ),
                        //   ),
                        // ),
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

  Future<void> uploadImage() async {
    if (_image == null) {
      // No image selected
      return;
    }

    // Show loading indicator
    setState(() {
      _isUploading = true;
    });

    try {
      // Get the current time to create a unique filename
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      // Create a reference to the image path in Firebase Storage
      var storageReference =
          FirebaseStorage.instance.ref().child('images/$uid.jpg');
      // Upload the file to Firebase Storage
      await storageReference.putFile(_image!);

      // Get the download URL of the uploaded image
      String imageUrl = await storageReference.getDownloadURL();

      // Print the download URL (you can save this URL in your database if needed)
      print('Image uploaded: $imageUrl');
      setState(() {
        imageUploaded = true;
        profilePhoto = imageUrl;
        _isUploading = false;
      });
      APIService.setProfilePic(imageUrl);
      var response = await APIService.updateProfile(
          uid,
          name.text.isNotEmpty ? name.text : widget.name,
          imageUrl,
          widget.mobile,
          about);
      SessionManager().set("profile_pic", imageUrl);
    } on FirebaseException catch (e) {
      print('Error uploading image: $e');
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _selectImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
        _image = File(pickedFile.path);
        isImageSelected = true;
        isImageFetched = false;
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
        isImageFetched = false;
      });
      uploadImage();
    }
  }

  bool validate() {
    if (name.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please Enter Name");
      return false;
    }
    return true;
  }

  void init() {
    if (widget.profile_pic != '') {
      setState(() {
        isImageFetched = true;
        profilePhoto = widget.profile_pic;
        username = widget.name;
        about = widget.about;
      });
    }
  }

  Widget _buildNameSheet() {
    name.text = username;
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
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
          Text(
            'Enter your name',
            style: TextStyle(color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 30.0, right: 30, bottom: 15, top: 15),
            child: TextField(
              controller: name,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter your name',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back(); // Close the dialog
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String enteredName = name.text;
                    // Do something with the entered name
                    print('Entered name: $enteredName');
                    username = enteredName;
                    var response = await APIService.updateProfile(
                        uid, username, profilePhoto, widget.mobile, about);
                    new SessionManager().set("username", username);
                    Get.back(); // Close the dialog
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAboutSheet() {
    aboutController.text = about;
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
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
          Text(
            'Enter About',
            style: TextStyle(color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 30.0, right: 30, bottom: 15, top: 15),
            child: TextField(
              controller: aboutController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter your about',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back(); // Close the dialog
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    about = aboutController.text;
                    var response = await APIService.updateProfile(
                        uid, username, profilePhoto, widget.mobile, about);
                    new SessionManager().set("about", about);
                    Get.back(); // Close the dialog
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
