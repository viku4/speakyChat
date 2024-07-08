import 'dart:io';
import 'dart:async';
import 'package:get/get.dart';
import 'uploads_b_s_model.dart';
import '../model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../screens/camera_screen_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speaky_chat/model/chat_user.dart';
import 'package:speaky_chat/api/api_services.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:speaky_chat/screens/location_preview.dart';
import 'package:permission_handler/permission_handler.dart';

export 'uploads_b_s_model.dart';

class UploadsBSWidget extends StatefulWidget {
  final ChatUser chatUser;

  var cameras;
  final bool isFirstMessage;
  final RxList<Message> list;

  UploadsBSWidget(
      {Key? key,
      required this.chatUser,
      this.action,
      this.cameras,
      required this.isFirstMessage,
      required this.list})
      : super(key: key);

  final Future<dynamic> Function()? action;

  @override
  _UploadsBSWidgetState createState() => _UploadsBSWidgetState();
}

class _UploadsBSWidgetState extends State<UploadsBSWidget> {
  late UploadsBSModel _model;
  File? file;

  @override
  void initState() {
    super.initState();
    // Fluttertoast.showToast(msg: widget.isFirstMessage.toString());
    _model = createModel(context, () => UploadsBSModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // context.watch<FFAppState>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(5.0, 10.0, 5.0, 10.0),
        child: GridView(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 2.0,
            childAspectRatio: 1.0,
          ),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            InkWell(
              onTap: () {
                _pickFile(widget.list);
              },
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                child: Stack(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          width: 1.0,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit_document,
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          size: 40.0,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 3.0, 0.0, 0.0),
                          child: Text(
                            'DOCUMENTS',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Arial Rounded MT Bold',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 12.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  pickMedia(widget.list);
                },
                child: Stack(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          width: 1.0,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.perm_media,
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          size: 40.0,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 3.0, 0.0, 0.0),
                          child: Text(
                            'MEDIA',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Arial Rounded MT Bold',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 12.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
              child: InkWell(
                onTap: () async {
                  bool cameraPermissionGranted =
                      await checkCameraPermission(context);
                  Get.back();
                  if (cameraPermissionGranted) {
                    Get.to(() => CameraScreenWidget(
                          cameras: widget.cameras,
                          chatuser: widget.chatUser,
                          list: widget.list,
                        ));
                  }
                },
                child: Stack(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          width: 1.0,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          size: 40.0,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 3.0, 0.0, 0.0),
                          child: Text(
                            'CAMERA',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Arial Rounded MT Bold',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 12.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
              child: InkWell(
                onTap: () {
                  pickAudio(widget.list);
                },
                child: Stack(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          width: 1.0,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.headset_mic,
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          size: 40.0,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 3.0, 0.0, 0.0),
                          child: Text(
                            'MUSIC',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Arial Rounded MT Bold',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 12.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
              child: Stack(
                alignment: AlignmentDirectional(0.0, 0.0),
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.circular(25.0),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        width: 1.0,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _pickContact,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.contact_phone_rounded,
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          size: 40.0,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 3.0, 0.0, 0.0),
                          child: Text(
                            'CONTACT',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Arial Rounded MT Bold',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 12.0,
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
            InkWell(
              onTap: () {
                checkPermission();
              },
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                child: Stack(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          width: 1.0,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.share_location_sharp,
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          size: 40.0,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 3.0, 0.0, 0.0),
                          child: Text(
                            'LOCATION',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Arial Rounded MT Bold',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 12.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile(RxList<Message> list) async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    final storageStatus = android.version.sdkInt < 33
        ? await Permission.storage.request()
        : PermissionStatus.granted;

    if (_requestStoragePermissionStatus(storageStatus)) {
      // Permission granted, proceed with file picking
      final result = await FilePicker.platform.pickFiles(allowMultiple: false);

      Navigator.pop(context);

      setState(() {});
      if (result != null) {
        file = File(result.files.single.path!);
        // Process the picked file (e.g., display filename)
        final ext = file?.path.split('.').last;
        final name = file?.path.split('/').last;
        Fluttertoast.showToast(msg: 'Sending');

        if (widget.isFirstMessage) {
          // Fluttertoast.showToast(msg: 'Sending2');

          APIService.sendFirstDocument(
              widget.chatUser, file!, name!, ext, list);
        } else {
          APIService.sendChatDocument(widget.chatUser, file!, name!, ext, list);
        }
        print('Picked file: ${file!.path}');
      } else {
        // User canceled the picker
      }
    } else {
      // Permission denied or error
      print('Storage permission not granted');
    }
  }

  Future<bool> _requestStoragePermission() async {
    final status1 = await Permission.storage.request();
    var status = await Permission.storage.status;
    Fluttertoast.showToast(msg: status.toString());
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      // var result = await Permission.storage.request();
      final status = await Permission.storage.request();
      if (status == PermissionStatus.granted) {
        return true;
      }
      return false;
    } else if (status.isRestricted) {
      Fluttertoast.showToast(msg: 'msg2');
      // Handle restricted permission status (e.g., open app settings)
      await openAppSettings();
      return false;
    } else {
      Fluttertoast.showToast(msg: 'msg3');
      return false;
    }
  }

  Future<bool> checkCameraPermission(BuildContext context) async {
    PermissionStatus status = await Permission.camera.status;
    if (!status.isGranted) {
      // If camera permission is not granted, request permission
      PermissionStatus permissionStatus = await Permission.camera.request();
      return permissionStatus.isGranted;
    }
    return true;
  }

  bool _requestStoragePermissionStatus(PermissionStatus storageStatus) {
    if (storageStatus == PermissionStatus.granted) {
      return true;
    }
    if (storageStatus == PermissionStatus.denied) {
      return false;
    }
    if (storageStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
      return false;
    }
    return false;
  }

  Future<File> convertUint8ListToFile(Uint8List imageBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/fileName';
    final file = File(filePath);
    await file.writeAsBytes(imageBytes);
    return file;
  }

  Future<void> pickAudio(RxList<Message> list) async {
    File? pickedAudioFile;
    Navigator.pop(context);
    setState(() {});
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      final file = File(result.files.single.path!);
      if (result != null) {
        pickedAudioFile = File(result.files.single.path!);

        Fluttertoast.showToast(msg: 'Sending');
        if (widget.isFirstMessage) {
          APIService.uploadFirstMedia(
              widget.chatUser, pickedAudioFile.path, list);
        } else {
          APIService.uploadMedia(widget.chatUser, pickedAudioFile.path, list);
        }
      }
    }
  }

  Future<void> pickMedia(RxList<Message> list) async {
    File pickedMediaFile;
    String? pickedMediaExt;
    Navigator.pop(context);
    setState(() {});
    final result = await FilePicker.platform.pickFiles(type: FileType.media);
    if (result != null) {
      final file = File(result.files.single.path!);
      pickedMediaExt = result.files.single.extension;
      print('ext is$pickedMediaExt');
      pickedMediaFile = file;
      if (pickedMediaExt == 'jpg' ||
          pickedMediaExt == 'jpeg' ||
          pickedMediaExt == 'png' ||
          pickedMediaExt == 'webp' ||
          pickedMediaExt == 'gif' ||
          pickedMediaExt == 'bmp' ||
          pickedMediaExt == 'tiff') {
        // Fluttertoast.showToast(msg: singleMedia[0].getFile());
        Fluttertoast.showToast(msg: 'Sending');

        if (widget.isFirstMessage) {
          APIService.sendFirstChatImage(widget.chatUser, pickedMediaFile, list);
        } else {
          APIService.sendChatImage(widget.chatUser, pickedMediaFile, list);
        }
      } else {
        Fluttertoast.showToast(msg: 'Sending');

        String? thumbnailPath = await getThumbnailFile(pickedMediaFile.path)!;
        File thumbnail = File(thumbnailPath!);

        if (widget.isFirstMessage) {
          APIService.sendFirstChatVideo(
              widget.chatUser, pickedMediaFile, thumbnail, widget.list);
        } else {
          APIService.sendChatVideo(
              widget.chatUser, pickedMediaFile, thumbnail, widget.list);
        }
      }
    }
  }

  Future<String?> getThumbnailFile(String videoPath) async {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: (await getTemporaryDirectory()).path,
      // Path to save thumbnail
      imageFormat: ImageFormat.JPEG,
      // Choose desired format (JPEG, PNG)
      maxWidth: 1024,
      // Optional: Set maximum width for the thumbnail
      maxHeight: 512,
      // Optional: Set maximum height for the thumbnail
      quality: 75, // Optional: Set quality (0-100)
    );
    return thumbnailPath;
  }

  Future<void> checkPermission() async {
    final status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      Get.to(() => LocationPreviewPage(
            chatUser: widget.chatUser,
            list: widget.list,
          ));
    } else if (status == PermissionStatus.permanentlyDenied) {
      await Permission.location.request();
    } else {
      // Handle other permission status (denied, etc.)
      Get.snackbar("Permission Denied",
          "Location access is required for Location Sharing.");
    }
  }

  void _pickContact() async {
    // Request permission to access contacts
    // PermissionStatus permissionStatus = await ContactsService.requestPermission();
    PermissionStatus permissionStatus = await Permission.contacts.request();

    if (permissionStatus == PermissionStatus.granted) {
      // Pick a contact from the device's contact list
      Contact? contact = await ContactsService.openDeviceContactPicker();

      if (contact != null) {
        // Update text fields with picked contact details
        if (widget.isFirstMessage) {
          APIService.sendFirstMessage(
              widget.chatUser,
              encodeContact(
                  contact.displayName ?? '',
                  contact.phones!.isNotEmpty
                      ? contact.phones!.first.value ?? ''
                      : ''),
              Type.contact,
              widget.list);
        } else {
          int time = DateTime.now().millisecondsSinceEpoch;
          APIService.sendMessage(
              widget.chatUser,
              encodeContact(
                  contact.displayName ?? '',
                  contact.phones!.isNotEmpty
                      ? contact.phones!.first.value ?? ''
                      : ''),
              Type.contact,
              time,
              widget.list);
        }
        // nameController.text = contact.displayName ?? '';
        // phoneController.text = contact.phones!.isNotEmpty ? contact.phones!.first.value ?? '' : '';
      }
    } else {
      // Permission denied
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Permission Denied'),
            content: Text('Please grant permission to access contacts.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  String encodeContact(String name, String phone) {
    // Assuming ';' is not part of contact names or numbers
    return '$name;$phone';
  }
}
