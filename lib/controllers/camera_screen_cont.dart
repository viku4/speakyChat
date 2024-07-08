
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrue/gotrue.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:record_mp3/record_mp3.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:speaky_chat/model/chat_user.dart';

import '../api/api_services.dart';
import '../model/message_model.dart';
import '../providers/chats_provider.dart';

class CameraScreenController extends GetxController{

  late CameraController cameraController;
  late Future<void> cameraValue;
  var imagesList = [].obs;
  var isFlashOn = false.obs;
  var isRearCamera = true.obs;
  var isRecording = false.obs;
  Timer? _timer;
  var _currentTime = 0.obs;

  @override
  void onInit() {
    super.onInit();

    // if(Get.arguments != null){
    //   cameras = Get.arguments[0];
    // }
    // startCamera(0);

    // connect();
    // chatProvider = Get.put(ChatProvider());
  }

  String get formattedTime {
    int minutes = _currentTime ~/ 60;
    int seconds = _currentTime.value % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
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
  }

  // void startCamera(int camera) {
  //   cameraController = CameraController(
  //     cameras[camera],
  //     ResolutionPreset.high,
  //     enableAudio: false,
  //   );
  //   cameraValue = cameraController.initialize();
  // }

  Future<void> startRecording() async {
    isRecording.value = true;
    startTimer();
  }

  Future<void> stopRecording() async {

    isRecording.value = false;
    stopTimer();
  }

  void startTimer() {
    _currentTime.value = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _currentTime++;
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _currentTime.value = 0;
  }
}