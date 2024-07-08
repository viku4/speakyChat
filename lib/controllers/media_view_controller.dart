import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../api/api_services.dart';
import '../model/chat_user.dart';

class MediaViewController extends GetxController {
  late ChatUser user;
  var filePath = ''.obs;
  var isPhoto = true.obs;
  var msgTime = ''.obs;
  File? image, video;
  VideoPlayerController? videoPlayerController;

  @override
  Future<void> onInit() async {
    super.onInit();
    if(Get.arguments != null){
      user = Get.arguments[0];
      isPhoto.value = Get.arguments[1];
      filePath.value = Get.arguments[2];
      msgTime.value = Get.arguments[3];
    }
    if(isPhoto.value){
      image = File(filePath.value);
    }else{
      video = File(filePath.value);
      // isPhoto.value =true;
    }
  }

  Future initVideoPlayer() async {
    // videoPlayerController = VideoPlayerController.file(video!);
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(filePath.value!));
    await videoPlayerController?.initialize();
    await videoPlayerController?.setLooping(true);
    await videoPlayerController?.play();
  }
}