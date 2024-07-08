import 'dart:io';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:speaky_chat/call/video_call.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:speaky_chat/status/trim_status.dart';
import 'package:speaky_chat/status/status_view.dart';
import 'package:speaky_chat/flutter_flow/flutter_flow_util.dart';
import 'package:speaky_chat/flutter_flow/flutter_flow_theme.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  List status = [
    {
      "image":
          "https://i.pinimg.com/736x/f9/a0/fe/f9a0fe6066adf7affb08b41b4ebe636f.jpg",
      "name": "Prakash",
      "date": "2022-09-20 10:27:21.240752"
    },
    {
      "image":
          "https://i.pinimg.com/736x/f9/a0/fe/f9a0fe6066adf7affb08b41b4ebe636f.jpg",
      "name": "Vishal",
      "date": "2022-09-20 10:27:21.240752"
    },
    {
      "image":
          "https://i.pinimg.com/736x/f9/a0/fe/f9a0fe6066adf7affb08b41b4ebe636f.jpg",
      "name": "Subham",
      "date": "2022-09-20 21:27:21.240752"
    },
    {
      "image":
          "https://i.pinimg.com/736x/f9/a0/fe/f9a0fe6066adf7affb08b41b4ebe636f.jpg",
      "name": "Vinay",
      "date": "2024-07-01 10:27:21.240752"
    },
    {
      "image":
          "https://i.pinimg.com/736x/f9/a0/fe/f9a0fe6066adf7affb08b41b4ebe636f.jpg",
      "name": "Prakash",
      "date": "2022-09-20 10:27:21.240752"
    },
    {
      "image":
          "https://i.pinimg.com/736x/f9/a0/fe/f9a0fe6066adf7affb08b41b4ebe636f.jpg",
      "name": "Vishal",
      "date": "2022-09-20 10:27:21.240752"
    },
    {
      "image":
          "https://i.pinimg.com/736x/f9/a0/fe/f9a0fe6066adf7affb08b41b4ebe636f.jpg",
      "name": "Subham",
      "date": "2022-09-20 21:27:21.240752"
    },
    {
      "image":
          "https://i.pinimg.com/736x/f9/a0/fe/f9a0fe6066adf7affb08b41b4ebe636f.jpg",
      "name": "Vinay",
      "date": "2024-07-01 10:27:21.240752"
    },
    {
      "image":
          "https://i.pinimg.com/736x/f9/a0/fe/f9a0fe6066adf7affb08b41b4ebe636f.jpg",
      "name": "Prakash",
      "date": "2022-09-20 10:27:21.240752"
    },
    {
      "image":
          "https://i.pinimg.com/736x/f9/a0/fe/f9a0fe6066adf7affb08b41b4ebe636f.jpg",
      "name": "Vishal",
      "date": "2022-09-20 10:27:21.240752"
    },
    {
      "image":
          "https://i.pinimg.com/736x/f9/a0/fe/f9a0fe6066adf7affb08b41b4ebe636f.jpg",
      "name": "Subham",
      "date": "2022-09-20 21:27:21.240752"
    },
    {
      "image":
          "https://i.pinimg.com/736x/f9/a0/fe/f9a0fe6066adf7affb08b41b4ebe636f.jpg",
      "name": "Vinay",
      "date": "2024-07-01 10:27:21.240752"
    },
    {
      "image":
          "https://i.pinimg.com/736x/f9/a0/fe/f9a0fe6066adf7affb08b41b4ebe636f.jpg",
      "name": "Prakash",
      "date": "2022-09-20 10:27:21.240752"
    },
    {
      "image":
          "https://i.pinimg.com/736x/f9/a0/fe/f9a0fe6066adf7affb08b41b4ebe636f.jpg",
      "name": "Vishal",
      "date": "2022-09-20 10:27:21.240752"
    },
    {
      "image":
          "https://i.pinimg.com/736x/f9/a0/fe/f9a0fe6066adf7affb08b41b4ebe636f.jpg",
      "name": "Subham",
      "date": "2022-09-20 21:27:21.240752"
    },
    {
      "image":
          "https://i.pinimg.com/736x/f9/a0/fe/f9a0fe6066adf7affb08b41b4ebe636f.jpg",
      "name": "Vinay",
      "date": "2024-07-01 10:27:21.240752"
    },
  ];

  List data = [
    {
      "file": "https://video-links.b-cdn.net/media/videolinks/video/haida.MP4",
      "titile": "Still sampling",
      "type": "video",
    },
    {
      "file": "this is the",
      "titile": "Still sampling",
      "type": "text",
    },
    {
      "file":
          "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
      "titile": "Still sampling",
      "type": "image",
    },
    {
      "file":
          "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
      "titile": "Still sampling",
      "type": "image",
    },
    {
      "file":
          "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
      "titile": "Still sampling",
      "type": "image",
    },
    {
      "file":
          "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
      "titile": "Still sampling",
      "type": "image",
    },
  ];
  List<StoryItem> stories = [];
  File? galleryFile;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      dataAdd();
    });
  }

  dataAdd() {
    for (var storyData in data) {
      if (storyData["type"] == "text") {
        stories.add(StoryItem.text(
          title: storyData["file"],
          backgroundColor: Colors.black,
        ));
      } else if (storyData["type"] == "image") {
        stories.add(StoryItem.pageImage(
          url: storyData["file"],
          controller: storyController,
        ));
      } else if (storyData["type"] == "video") {
        stories.add(StoryItem.pageVideo(
          storyData["file"],
          controller: storyController,
        ));
      }
    }
  }

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VideoCall(
                    // type: "text",
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: FlutterFlowTheme.of(context).secondary,
              ),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              _showPicker(context: context);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: FlutterFlowTheme.of(context).primary,
              ),
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              _showPicker(context: context);
            },
            trailing: Container(
              height: 50,
              width: 50,
              color: Colors.white,
            ),
            leading: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.green,
                  width: 2,
                ),
              ),
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(
                        "https://i.pinimg.com/736x/f9/a0/fe/f9a0fe6066adf7affb08b41b4ebe636f.jpg"),
                  ),
                  Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        backgroundColor: FlutterFlowTheme.of(context).primary,
                        radius: 10,
                        child: const Icon(
                          Icons.add_a_photo,
                          size: 10,
                          color: Colors.white,
                        ),
                      ))
                ],
              ),
            ),
            title: Text(
              "My status",
              style: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Readex Pro',
                    color: Colors.white,
                  ),
              // style: Theme.of(context).textTheme.headline6,
            ),
            subtitle: Text(
              "2024-07-01",
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: ' Comic Sans MS',
                    fontSize: 12,
                    useGoogleFonts: false,
                  ),
              // style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: status.length,
              itemBuilder: (BuildContext context, int index) {
                final date = DateTime.tryParse(status[index]["date"] ?? '');
                final data = DateFormat('hh:mm a').format(date!);
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StatusView(storyItems: stories),
                      ),
                    );
                  },
                  trailing: Container(
                    height: 50,
                    width: 50,
                    color: Colors.white,
                  ),
                  leading: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.green,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(status[index]["image"]),
                    ),
                  ),
                  title: Text(
                    status[index]["name"],
                    style: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Readex Pro',
                          color: Colors.white,
                        ),
                  ),
                  subtitle: Text(
                    data.toString(),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: ' Comic Sans MS',
                          fontSize: 12,
                          useGoogleFonts: false,
                        ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  // String dateConverter(String myDate) {
  //   String date;
  //   DateTime convertedDate = DateFormat("DD/MM/YYYY").parse(myDate.toString());
  //   final now = DateTime.now();
  //   final today = DateTime(now.year, now.month, now.day);
  //   final yesterday = DateTime(now.year, now.month, now.day - 1);
  //   final tomorrow = DateTime(now.year, now.month, now.day + 1);

  //   final dateToCheck = convertedDate;
  //   final checkDate =
  //       DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
  //   if (checkDate == today) {
  //     date = "Today";
  //   } else if (checkDate == yesterday) {
  //     date = "Yesterday";
  //   } else if (checkDate == tomorrow) {
  //     date = "Tomorrow";
  //   } else {
  //     date = myDate;
  //   }
  //   return date;
  // }

  void _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              const ListTile(
                title: Text(
                  'Choose Image/Video which you want to upload.',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                ),
                title: const Text('Camera',
                    style: TextStyle(
                      color: Colors.black,
                    )),
                onTap: () {
                  Navigator.of(context).pop();
                  getImage(ImageSource.camera, "photo");
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Colors.black,
                ),
                title: const Text('Gallery',
                    style: TextStyle(
                      color: Colors.black,
                    )),
                onTap: () {
                  Navigator.of(context).pop();
                  getImage(ImageSource.gallery, "photo");
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.video_library,
                  color: Colors.black,
                ),
                title: const Text('Video',
                    style: TextStyle(
                      color: Colors.black,
                    )),
                onTap: () {
                  Navigator.of(context).pop();
                  getImage(ImageSource.gallery, "video");
                },
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        );
      },
    );
  }

  Future getImage(ImageSource img, String type) async {
    final pickedFile = (type == "video")
        ? await picker.pickVideo(source: img)
        : await picker.pickImage(source: img);
    if ((pickedFile.runtimeType == XFile) && (pickedFile != null)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TrimmerView(
            file: File(pickedFile.path),
            type: type,
          ),
        ),
      );

      galleryFile = File(pickedFile.path);

      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
          const SnackBar(content: Text('Nothing is selected')));
    }
  }
}
