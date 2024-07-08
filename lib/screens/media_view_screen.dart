import 'dart:ffi';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:speaky_chat/api/api_services.dart';
import 'package:video_player/video_player.dart';

import '../controllers/media_view_controller.dart';

class MediaViewScreen extends StatefulWidget {
  @override
  State<MediaViewScreen> createState() => _MediaViewScreenState();
}

class _MediaViewScreenState extends State<MediaViewScreen> {
  var cont = Get.find<MediaViewController>();

  @override
  void dispose() {
    cont.videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              APIService.me != cont.user
                  ? cont.user.name != ''
                      ? cont.user.name
                      : cont.user.phone
                  : "You",
              style: const TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            Text(
              cont.msgTime.value,
              style: const TextStyle(color: Colors.white, fontSize: 11.0),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Display the image

          cont.isPhoto.value
              ? Image.file(File(cont.filePath.value))
              //     ? CachedNetworkImage(
              //   imageUrl: cont.filePath.value,
              //   placeholder: (context, url) =>
              //   const Padding(
              //     padding: EdgeInsets.all(8.0),
              //     child: CircularProgressIndicator(strokeWidth: 2),
              //   ),
              //   errorWidget: (context, url, error) =>
              //   const Icon(Icons.image, size: 70),
              // )
              : FutureBuilder(
                  future: cont.initVideoPlayer(),
                  builder: (context, state) {
                    if (state.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return VideoPlayer(cont.videoPlayerController!);
                    }
                  },
                ),
          // Overlay with bottom bar
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: Container(
          //     height: 80,
          //     color: Colors.black.withOpacity(0.5),
          //     child: Padding(
          //       padding: const EdgeInsets.all(16.0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             cont.user.name,
          //             style:
          //             const TextStyle(color: Colors.white, fontSize: 18.0),
          //           ),
          //           ElevatedButton(
          //             onPressed: () {
          //               cont.isPhoto.value ?
          //               APIService.sendChatImage(cont.user, cont.image!) :
          //               APIService.sendChatVideo(cont.user, cont.video!, cont.image!);
          //
          //               // In the screen where you want to clear previous screens
          //
          //               cont.isPhoto.value ? Get.back(result: cont.image) : Get.back(result: cont.video);
          //
          //               // Get.offUntil(
          //               //       ChatDetailPageRoute(),
          //               //       (route) => Get.routing.previous.length <= 2,
          //               // );
          //
          //               // Get.offUntil(
          //               //   ChatDetailWidget(),
          //               //       (route) => Get.routing.previous.length <= 3,
          //               // );
          //               // Get.to(()=>ChatDetailWidget(), arguments: [cont.user, cont.imagePath]);
          //             },
          //             child: const Text('Send'),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
