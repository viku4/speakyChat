import 'dart:io';
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:speaky_chat/widgets/color_const.dart';
import 'package:speaky_chat/components/text_field.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:speaky_chat/flutter_flow/flutter_flow_theme.dart';

class TrimmerView extends StatefulWidget {
  final File? file;
  final String type;
  const TrimmerView({super.key, this.file, required this.type});

  @override
  State<TrimmerView> createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<TrimmerView> {
  final _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;
  bool _isPlaying = false;
  bool _progressVisibility = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _loadVideo();
    });
  }

  void _loadVideo() => (widget.file != null)
      ? _trimmer.loadVideo(videoFile: widget.file!)
      : null;

  _saveVideo() {
    setState(() {
      _progressVisibility = true;
    });

    _trimmer.saveTrimmedVideo(
      startValue: _startValue,
      endValue: _endValue,
      // outputFormat: FileFormat.,
      onSave: (outputPath) {
        setState(() {
          _progressVisibility = false;
        });
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (context) => Preview(outputPath),
        //   ),
        // );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    Future.delayed(Duration.zero, () {
      _trimmer.dispose();
    });
  }

  TextEditingController controller = TextEditingController();
  // Timer? _hideButtonTimer;

  @override
  Widget build(BuildContext context) {
    // _hideButtonTimer?.cancel(); // Cancel any existing timer
    // _hideButtonTimer = Timer(Duration(seconds: 3), () => setState(() {}));
    return Scaffold(
      backgroundColor: black,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          bottom: (MediaQuery.of(context).viewInsets.bottom > 0)
              ? MediaQuery.of(context).viewInsets.bottom + 10
              : 10,
          top: 10,
          left: 10,
          right: 10,
        ),
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).accent4,
          // borderRadius: const BorderRadius.only(
          //   topLeft: Radius.circular(20),
          //   topRight: Radius.circular(20),
          // ),
        ),
        // padding: const EdgeInsets.symmetric(
        //   horizontal: 20,
        //   vertical: 10,
        // ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: (widget.type != "text")
                  ? TextFieldData.BuildField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(250),
                      ],
                      controller: controller,
                      maxLines: 3,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: black),
                      decoration: InputDecoration(
                        hintText: "Enter your Description (250 Character)",
                        hintStyle: TextStyle(color: black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    )
                  : Text(""),
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              style: IconButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: black,
                // side: BorderSide()
              ),
              onPressed: () {},
              icon: Icon(
                Icons.done,
                size: 40,
                color: white,
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          (widget.type == "video")
              ? '30 Sec video upload a status'
              : (widget.type == "photo")
                  ? "Image"
                  : (widget.type == "text")
                      ? "Enter your Description"
                      : "",
          style: TextStyle(
            color: white,
            fontSize: 15,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: (widget.type == "video")
                ? (widget.file != null)
                    ? [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TrimViewer(
                              trimmer: _trimmer,
                              viewerHeight: 50.0,
                              viewerWidth: MediaQuery.of(context).size.width,
                              durationStyle: DurationStyle.FORMAT_MM_SS,
                              maxVideoLength: const Duration(seconds: 30),
                              editorProperties: TrimEditorProperties(
                                borderPaintColor: Colors.yellow,
                                borderWidth: 4,
                                borderRadius: 5,
                                circlePaintColor: Colors.yellow.shade800,
                              ),
                              areaProperties: TrimAreaProperties.edgeBlur(
                                  thumbnailQuality: 10),
                              onChangeStart: (value) => _startValue = value,
                              onChangeEnd: (value) => _endValue = value,
                              onChangePlaybackState: (value) => setState(
                                () => _isPlaying = value,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _progressVisibility,
                          child: const LinearProgressIndicator(
                            backgroundColor: Colors.red,
                          ),
                        ),
                        Expanded(
                            child: Stack(
                          children: [
                            VideoViewer(trimmer: _trimmer),
                            Positioned(
                              child: Center(
                                child:

                                    //  AnimatedOpacity(
                                    //   opacity:
                                    //       _hideButtonTimer?.isActive ?? false ? 0.0 : 1.0,
                                    //   duration: Duration(milliseconds: 200),
                                    //   child:

                                    IconButton(
                                  icon: Icon(
                                    _isPlaying ? Icons.pause : Icons.play_arrow,
                                    size: 80,
                                    color: Colors.black,
                                  ),
                                  onPressed: () async {
                                    final playbackState =
                                        await _trimmer.videoPlaybackControl(
                                      startValue: _startValue,
                                      endValue: _endValue,
                                    );
                                    setState(() => _isPlaying = playbackState);
                                  },
                                ),
                              ),
                            ),
                            // )
                          ],
                        )),
                      ]
                    : []
                : (widget.type == "photo")
                    ? (widget.file != null)
                        ? [
                            Expanded(
                              child: Image.file(
                                widget.file!,
                                fit: BoxFit.contain,
                              ),
                            )
                          ]
                        : []
                    : (widget.type == "text")
                        ? [
                            Expanded(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 20,
                                  ),
                                  child: TextFieldData.BuildField(
                                    controller: controller,
                                    maxLines: 10,
                                    keyboardType: TextInputType.text,
                                    style:
                                        TextStyle(color: white, fontSize: 40),
                                    decoration: InputDecoration(
                                        hintText: "Enter Your Text",
                                        hintStyle: TextStyle(color: white),
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                            )
                          ]
                        : [],
          ),
        ),
      ),
    );
  }
}
