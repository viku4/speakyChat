import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../api/api_services.dart';
import '../model/chat_user.dart';
import '../model/message_model.dart';

class MediaPreviewController extends GetxController {
  late ChatUser user;
  var filePath = ''.obs;
  var thumbnailPath = ''.obs;
  var isPhoto = true.obs;
  File? image, video;
  VideoPlayerController? videoPlayerController;
  var isVideoLoaded = false.obs;
  // RxList<Message> list = [].obs;
  var list = <Message>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    if (Get.arguments != null) {
      user = Get.arguments[0];
      isPhoto.value = Get.arguments[1];
      filePath.value = Get.arguments[2];
      list = Get.arguments[3];
    }
    if (await _hasAcceptedPermissions()) {
      if (isPhoto.value) {
        image = File(filePath.value);
      } else {
        video = File(filePath.value);
        thumbnailPath.value = (await getThumbnailFile(filePath.value))!;
        image = File(thumbnailPath.value);
        await initVideoPlayer();
      }
    } else {
      Get.snackbar('Permissions Denied', 'Storage permissions are required to save and access media.');
    }
  }

  Future<void> initVideoPlayer() async {
    try {
      videoPlayerController = VideoPlayerController.file(video!);
      await videoPlayerController?.initialize();
      await videoPlayerController?.setLooping(true);

      if(videoPlayerController!=null){
        await videoPlayerController?.play();
        isVideoLoaded.value = true;
      }
    } catch (e) {
      print('Error initializing video player: $e');
    }
  }

  Future<String?> getThumbnailFile(String videoPath) async {
    try {
      final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: (await getTemporaryDirectory()).path, // Path to save thumbnail
        imageFormat: ImageFormat.JPEG, // Choose desired format (JPEG, PNG)
        maxWidth: 1024, // Optional: Set maximum width for the thumbnail
        maxHeight: 512, // Optional: Set maximum height for the thumbnail
        quality: 75, // Optional: Set quality (0-100)
      );
      return thumbnailPath;
    } catch (e) {
      print('Error generating thumbnail: $e');
      return null;
    }
  }

  Future<bool> _hasAcceptedPermissions() async {
    if (Platform.isAndroid) {
      bool android13OrHigher = await _isAndroid13OrHigher();
      List<Permission> android13Permissions = [
        Permission.photos,
        Permission.videos,
        Permission.audio,
      ];
      // Permissions for earlier versions of Android
      List<Permission> legacyPermissions = [
        Permission.storage,
        Permission.accessMediaLocation,
        Permission.manageExternalStorage,
      ];
      return await _requestPermissions(
          android13OrHigher ? android13Permissions : legacyPermissions);

      // return await _requestPermission(Permission.storage) &&
      //     await _requestPermission(Permission.accessMediaLocation) &&
      //     await _requestPermission(Permission.manageExternalStorage);
    } else if (Platform.isIOS) {
      return await _requestPermissions([Permission.photos]);
    } else {
      return false;
    }
  }

  Future<bool> _requestPermissions(List<Permission> permissions) async {
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    bool allGranted = statuses.values.every((status) => status.isGranted);

    if (!allGranted) {
      bool permanentlyDenied =
      statuses.values.any((status) => status.isPermanentlyDenied);
      if (permanentlyDenied) {
        // Show a dialog or redirect to app settings
        return _showPermissionDialog();
      }

    }
    return allGranted;
  }

  Future<bool> _isAndroid13OrHigher() async {
    final int sdkVersion = await _getAndroidSdkVersion();
    return sdkVersion >= 33; // Android 13 is SDK 33
  }

  Future<int> _getAndroidSdkVersion() async {
    if (!Platform.isAndroid) {
      return 0;
    }
    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      int sdkInt = androidInfo.version.sdkInt;
      return sdkInt;
    } catch (e) {
      return 0;
    }
  }

  Future<bool> _showPermissionDialog() async {
    return await Get.dialog(
      AlertDialog(
        title: Text('Permissions Required'),
        content: const Text(
            'This app requires permissions to function properly. Please grant permissions from app settings.'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Get.back(result: true);
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
      barrierDismissible: false,
    ) ?? false;
  }
}