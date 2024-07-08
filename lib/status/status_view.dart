import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:speaky_chat/flutter_flow/flutter_flow_theme.dart';

final storyController = StoryController();

class StatusView extends StatefulWidget {
  final List<StoryItem?>? storyItems;
  const StatusView({super.key, required this.storyItems});

  @override
  State<StatusView> createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Vikash",
          style: FlutterFlowTheme.of(context).titleSmall.override(
                fontFamily: 'Readex Pro',
                color: Colors.white,
              ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: StoryView(
        storyItems: widget.storyItems ??
            [
              StoryItem.pageImage(
                url:
                    "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
                caption: const Text(
                  "Still sampling",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                controller: storyController,
              ),
              StoryItem.pageImage(
                  url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
                  caption: const Text(
                    "Working with gifs",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  controller: storyController),
              StoryItem.pageImage(
                url:
                    "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
                caption: const Text(
                  "Hello, from the other side",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                controller: storyController,
              ),
              StoryItem.pageImage(
                url:
                    "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
                caption: const Text(
                  "Hello, from the other side2",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                controller: storyController,
              ),
            ],
        onVerticalSwipeComplete: (direction) {
          if (direction == Direction.down) {
            Navigator.pop(context);
          }
        },
        onStoryShow: (storyItem, index) {
          print("Showing a story");
        },
        onComplete: () {
          print("Completed a cycle");
        },
        progressPosition: ProgressPosition.top,
        repeat: false,
        controller: storyController,
      ),
    );
  }
}
