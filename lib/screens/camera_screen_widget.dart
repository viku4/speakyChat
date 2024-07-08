import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:speaky_chat/controllers/camera_screen_cont.dart';
import 'package:speaky_chat/model/chat_user.dart';
import 'package:speaky_chat/screens/media_preview_screen.dart';
import '../model/message_model.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CameraScreenWidget extends StatefulWidget {
  List<CameraDescription> cameras;
  final List<Message> list;
  var chatuser;

  CameraScreenWidget({super.key, required this.cameras, this.chatuser, required this.list});

  @override
  State<CameraScreenWidget> createState() => _CameraScreenWidgetState();
}

class _CameraScreenWidgetState extends State<CameraScreenWidget> {
  late final List<CameraDescription> cameras;
  late CameraController cameraController;
  late Future<void> cameraValue;
  var imagesList = [].obs;
  bool isFlashOn = false;
  bool isRearCamera = true;
  Timer? _timer;
  int _currentTime = 0;

  var cont = Get.find<CameraScreenController>();

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
    // chatProvider.clearChat();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return Scaffold(
      // key: scaffoldKey,
      // backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: SafeArea(
        // top: true,
        child: Stack(
          children: [
            FutureBuilder(
              future: cameraValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        isRearCamera = !isRearCamera;
                        isRearCamera ? startCamera(0) : startCamera(1);
                      });
                    },
                    child: SizedBox(
                      width: size.width,
                      height: size.height,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: 100,
                          child: CameraPreview(cameraController),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5, top: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: GestureDetector(
                          onTap: () {
                            cont.isFlashOn.value = !cont.isFlashOn.value;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(50, 0, 0, 0),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white),
                            ),
                            child: Obx(
                              () => Padding(
                                padding: const EdgeInsets.all(10),
                                child: cont.isFlashOn.value
                                    ? const Icon(
                                        Icons.flash_on,
                                        color: Colors.white,
                                        size: 21,
                                      )
                                    : const Icon(
                                        Icons.flash_off,
                                        color: Colors.white,
                                        size: 21,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(
                      () => cont.isRecording.value
                          ? SizedBox()
                          : Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(50, 0, 0, 0),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SizedBox(width: 25, height: 25),
                              ),
                            ),
                    ),
                    GestureDetector(
                      onTap: () {
                        takePicture();
                      },
                      onLongPressStart: (_) {
                        startRecording();
                      },
                      onLongPressEnd: (details) {
                        stopRecording();
                      },
                      child: Container(
                          padding: EdgeInsets.all(12),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Obx(
                                () => Icon(
                                  Icons.fiber_manual_record,
                                  color: cont.isRecording.value
                                      ? Colors.red
                                      : Colors.white,
                                ),
                              ),
                              Obx(
                                () => Icon(
                                  Icons.circle_outlined,
                                  color: Colors.white,
                                  size: cont.isRecording.value ? 80 : 60,
                                ),
                              ),
                            ],
                          )),
                    ),
                    Obx(
                      () => cont.isRecording.value
                          ? SizedBox()
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  isRearCamera = !isRearCamera;
                                  isRearCamera
                                      ? startCamera(0)
                                      : startCamera(1);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(50, 0, 0, 0),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Icon(
                                    Icons.flip_camera_ios_outlined,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Obx(
                () => Visibility(
                  visible: cont.isRecording.value,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(25)),
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 9, bottom: 9),
                      child: Text(
                        cont.formattedTime,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void init() {
    cameras = widget.cameras;
    startCamera(0);
  }

  Future<File> saveImage(XFile image) async {
    final downlaodPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File('$downlaodPath/$fileName');

    try {
      await file.writeAsBytes(await image.readAsBytes());
    } catch (_) {}

    return file;
  }

  void takePicture() async {
    XFile? image;

    if (cameraController.value.isTakingPicture ||
        !cameraController.value.isInitialized) {
      return;
    }

    if (isFlashOn == false) {
      await cameraController.setFlashMode(FlashMode.off);
    } else {
      await cameraController.setFlashMode(FlashMode.torch);
    }
    image = await cameraController.takePicture();

    if (cameraController.value.flashMode == FlashMode.torch) {
      cameraController.setFlashMode(FlashMode.off);
    }

    final file = await saveImage(image);
    imagesList.add(file);
    MediaScanner.loadMedia(path: file.path);
    var result = await Get.to(() => MediaPreviewScreen(),
        arguments: [widget.chatuser, true, file.path, widget.list]);
    if (result != null) {
      Get.back(result: result);
    }
  }

  void startCamera(int camera) {
    cameraController = CameraController(
      cameras[camera],
      ResolutionPreset.high,
      enableAudio: false,
    );
    cameraValue = cameraController.initialize();
  }

  Future<void> startRecording() async {
    await cameraController.prepareForVideoRecording();
    await cameraController.startVideoRecording();
    cont.isRecording.value = true;
    cont.startTimer();
    // setState(() {});
  }

  Future<void> stopRecording() async {
    final file = await cameraController.stopVideoRecording();
    cont.isRecording.value = false;
    cont.stopTimer();
    var result = await Get.to(() => MediaPreviewScreen(),
        arguments: [widget.chatuser, false, file.path, widget.list]);
    print(">>>>>>>>>>>>>>>");
    if (result != null) {
      Get.back(result: result);
    }
  }
}
