import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:speaky_chat/api/api_services.dart';
import 'package:speaky_chat/chat/chat_detail/chat_detail_widget.dart';
import 'package:speaky_chat/controllers/chat_screen_cont.dart';
import 'package:speaky_chat/controllers/media_preview_controller.dart';
import 'package:speaky_chat/model/message_model.dart';
import 'package:video_player/video_player.dart';

class MediaPreviewScreen extends StatefulWidget {
  @override
  State<MediaPreviewScreen> createState() => _MediaPreviewScreenState();
}

class _MediaPreviewScreenState extends State<MediaPreviewScreen> {
  var cont = Get.find<MediaPreviewController>();

  @override
  void dispose() {
    cont.videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Display the image

          // cont.isPhoto.value
          //     ? Image.file(File(cont.filePath.value))
          //     : FutureBuilder(
          //         future: cont.initVideoPlayer(),
          //         builder: (context, state) {
          //           if (state.connectionState == ConnectionState.waiting) {
          //             return const Center(child: CircularProgressIndicator());
          //           } else {
          //             return VideoPlayer(cont.videoPlayerController!);
          //           }
          //         },
          //       ),

          Obx(()=> cont.isPhoto.value
                ? Image.file(File(cont.filePath.value))
                : !cont.isVideoLoaded.value
                    ? Center(child: CircularProgressIndicator())
                    : VideoPlayer(cont.videoPlayerController!),
          ),
          // Overlay with bottom bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              color: Colors.black.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cont.user.name,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        cont.isPhoto.value
                            ? APIService.sendChatImage(
                                cont.user, cont.image!, cont.list)
                            : APIService.sendChatVideo(
                                cont.user, cont.video!, cont.image!, cont.list);
                        // In the screen where you want to clear previous screens

                        cont.isPhoto.value
                            ? Get.back(result: cont.image)
                            : Get.back(result: cont.video);

                        // Get.offUntil(
                        //       ChatDetailPageRoute(),
                        //       (route) => Get.routing.previous.length <= 2,
                        // );

                        // Get.offUntil(
                        //   ChatDetailWidget(),
                        //       (route) => Get.routing.previous.length <= 3,
                        // );
                        // Get.to(()=>ChatDetailWidget(), arguments: [cont.user, cont.imagePath]);
                      },
                      child: const Text('Send'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
