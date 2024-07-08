import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speaky_chat/api/api_services.dart';
import 'package:speaky_chat/model/chat_user.dart';
import 'package:speaky_chat/screens/media_view_screen.dart';
import 'package:speaky_chat/screens/view_contact.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:voice_message_package/voice_message_package.dart';

import '../../helpers/my_date_util.dart';
import '../../model/message_model.dart';
// import 'package:gallery_saver/gallery_save?r.dart';

// for showing single message details
class MediaMessage extends StatefulWidget {
  final String user2Name;

  final String fromPic;

  const MediaMessage(
      {super.key,
      required this.message,
      required this.user,
      required this.user2Name,
      required this.fromPic});

  final Message message;
  final ChatUser user;

  @override
  State<MediaMessage> createState() => _MediaMessageState();
}

class _MediaMessageState extends State<MediaMessage> {
  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = Duration();
  Duration position = Duration();
  bool playing = false;
  Set<Marker> _markers = {};
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    if(widget.message.type == Type.location){
      _markers.add(
        Marker(
          markerId: MarkerId('current_location'),
          position: LatLng(getLatitude(widget.message.msg), getLongitude(widget.message.msg)),
          infoWindow: InfoWindow(
            title: 'Current Location',
          ),
        ),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isMe = APIService.user.uid == widget.message.fromId;
    return isMe ? _greenMessage() : _blueMessage();
  }

  // sender or another user message
  Widget _blueMessage() {
    //update last read message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      APIService.updateMessageReadStatus(widget.message);
    }

    var mq = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 135,
        ),
        child: Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          color: Color(0xffffffff),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              if (widget.message.type == Type.document)
                InkWell(
                  onTap: () {
                    // Get.to(() => MediaViewScreen(), arguments: [
                    //   widget.user,
                    //   false,
                    //   widget.message.msg.split('________')[1],
                    //   MyDateUtil.getFormattedTime(
                    //       context: context, time: widget.message.sent)
                    // ]);
                  },
                  child: Padding(
                      padding: EdgeInsets.only(
                        left: 9,
                        right: 9,
                        top: 9,
                        bottom: 9,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.file_present,
                            size: 35,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.message.msg.split('____')[1],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  widget.message.msg
                                          .split('____')[1]
                                          .split('.')
                                          .last
                                          .toUpperCase() +
                                      " File",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                ),

              if (widget.message.type == Type.video)
                InkWell(
                  onTap: () {
                    Get.to(() => MediaViewScreen(), arguments: [
                      widget.user,
                      false,
                      widget.message.msg.split('________')[1],
                      MyDateUtil.getFormattedTime(
                          context: context, time: widget.message.sent)
                    ]);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 3,
                      right: 3,
                      top: 3,
                      bottom: 3,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl: widget.message.msg.split('____')[0],
                            placeholder: (context, url) => const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.image, size: 70),
                          ),
                        ),
                        const Icon(
                          Icons.play_circle,
                          color: Colors.white,
                          size: 40,
                        )
                      ],
                    ),
                  ),
                ),

              if (widget.message.type == Type.image)
                InkWell(
                  onTap: () {
                    Get.to(() => MediaViewScreen(), arguments: [
                      widget.user,
                      true,
                      widget.message.msg,
                      MyDateUtil.getFormattedTime(
                          context: context, time: widget.message.sent)
                    ]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 3,
                      right: 3,
                      top: 3,
                      bottom: 3,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: widget.message.msg,
                        placeholder: (context, url) => const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.image, size: 70),
                      ),
                    ),
                  ),
                ),

              if (widget.message.type == Type.audio)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 3,
                    right: 3,
                    top: 3,
                    bottom: 3,
                  ),
                  child: SizedBox(
                    height: 55,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 14,
                        ),
                        InkWell(
                          onTap: () {
                            getAudio(widget.message.msg);
                          },
                          child: Icon(
                            playing
                                ? CupertinoIcons.pause
                                : CupertinoIcons.play,
                            color: Colors.black,
                          ),
                        ),
                        _slider()
                      ],
                    ),
                  ),
                ),

              if (widget.message.type == Type.location)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 3,
                    right: 3,
                    top: 3,
                    bottom: 3,
                  ),
                  child: InkWell(
                    onTap: (){
                      print("clicked");
                      openLocation(widget.message.msg);
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 155,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: IgnorePointer(
                                    child: GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                        target: LatLng(getLatitude(widget.message.msg), getLongitude(widget.message.msg)),
                                        zoom: 14,
                                      ),
                                      onMapCreated: (GoogleMapController controller) {
                                        _controller.complete(controller);
                                      },
                                      zoomControlsEnabled: false,
                                      markers: _markers,
                                      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                                        Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                                      ].toSet(),
                                    ),
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24,)
                      ],
                    ),
                  ),
                ),

              if (widget.message.type == Type.contact)
                Padding(
                  padding: EdgeInsets.only(
                    left: 3,
                    right: 3,
                    top: 3,
                    bottom: 3,
                  ),
                  child: InkWell(
                    onTap: (){
                      print("clicked");
                      Get.to(()=>ViewContactScreen(personName: getContact(widget.message.msg)['name']!, personPhoneNumber: getContact(widget.message.msg)['phone']!));
                    },
                    child: Column(
                      children: [
                        // Container(
                        //   height: 155,
                        //   child: ClipRRect(
                        //     borderRadius: BorderRadius.circular(20),
                        //     child: Row(
                        //       children: [
                        //         Expanded(
                        //           child: IgnorePointer(
                        //             child: GoogleMap(
                        //               initialCameraPosition: CameraPosition(
                        //                 target: LatLng(getLatitude(widget.message.msg), getLongitude(widget.message.msg)),
                        //                 zoom: 14,
                        //               ),
                        //               onMapCreated: (GoogleMapController controller) {
                        //                 _controller.complete(controller);
                        //               },
                        //               zoomControlsEnabled: false,
                        //               markers: _markers,
                        //               gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                        //                 Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                        //               ].toSet(),
                        //             ),
                        //           ),
                        //         )
                        //
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        Container(padding:EdgeInsets.all(15),child: Row(
                          children: [
                            Icon(Icons.person, size: 41,),
                            SizedBox(width: 10,),
                            Text(getContact(widget.message.msg)['name']!, style: TextStyle(color: Colors.black, fontSize: 18),),
                          ],
                        )),
                        SizedBox(height: 8,)
                      ],
                    ),
                  ),
                ),

              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    widget.message.starred != null &&
                            widget.message.starred == "true"
                        ? Icon(
                            Icons.star_rate_outlined,
                            color: widget.message.type == Type.image
                                ? Colors.white
                                : Colors.black,
                            size: 15,
                          )
                        : SizedBox(),

                    widget.message.pinned != null &&
                        widget.message.pinned!
                        ? Icon(
                      CupertinoIcons.pin,
                      color: widget.message.type == Type.image
                          ? Colors.white
                          : Colors.black,
                      size: 15,
                    )
                        : SizedBox(),

                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      MyDateUtil.getFormattedTime(
                          context: context, time: widget.message.sent),
                      style: TextStyle(
                        fontSize: 13,
                        color: widget.message.type == Type.image
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // our or user message
  Widget _greenMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 135,
        ),
        child: Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          color: Color(0xffffffff),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              if (widget.message.type == Type.document)
                InkWell(
                  onTap: () {
                    // Get.to(() => MediaViewScreen(), arguments: [
                    //   widget.user,
                    //   false,
                    //   widget.message.msg.split('________')[1],
                    //   MyDateUtil.getFormattedTime(
                    //       context: context, time: widget.message.sent)
                    // ]);
                  },
                  child: Padding(
                      padding: EdgeInsets.only(
                        left: 9,
                        right: 9,
                        top: 9,
                        bottom: 9,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.file_present,
                            size: 35,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.message.msg.split('____')[1],
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  widget.message.msg
                                          .split('____')[1]
                                          .split('.')
                                          .last
                                          .toUpperCase() +
                                      " File",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                ),

              if (widget.message.type == Type.video)
                InkWell(
                  onTap: () {
                    Get.to(() => MediaViewScreen(), arguments: [
                      widget.user,
                      false,
                      widget.message.msg.split('________')[1],
                      MyDateUtil.getFormattedTime(
                          context: context, time: widget.message.sent)
                    ]);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 3,
                      right: 3,
                      top: 3,
                      bottom: 3,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl: widget.message.msg.split('____')[0],
                            placeholder: (context, url) => const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.image, size: 70),
                          ),
                        ),
                        const Icon(
                          Icons.play_circle,
                          color: Colors.white,
                          size: 40,
                        )
                      ],
                    ),
                  ),
                ),

              if (widget.message.type == Type.image)
                InkWell(
                  onTap: () {
                    Get.to(() => MediaViewScreen(), arguments: [
                      widget.user,
                      true,
                      widget.message.msg,
                      MyDateUtil.getFormattedTime(
                          context: context, time: widget.message.sent)
                    ]);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 3,
                      right: 3,
                      top: 3,
                      bottom: 3,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: widget.message.msg,
                        placeholder: (context, url) => const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.image, size: 70),
                      ),
                    ),
                  ),
                ),

              if (widget.message.type == Type.audio)
                Padding(
                  padding: EdgeInsets.only(
                    left: 3,
                    right: 3,
                    top: 3,
                    bottom: 3,
                  ),
                  child: Container(
                    height: 55,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 14,
                        ),
                        InkWell(
                          onTap: () {
                            getAudio(widget.message.msg);
                          },
                          child: Icon(
                            playing
                                ? CupertinoIcons.pause
                                : CupertinoIcons.play,
                            color: Colors.black,
                          ),
                        ),
                        _slider()
                      ],
                    ),
                  ),
                ),

              if (widget.message.type == Type.location)
                Padding(
                  padding: EdgeInsets.only(
                    left: 3,
                    right: 3,
                    top: 3,
                    bottom: 3,
                  ),
                  child: InkWell(
                    onTap: (){
                      // print("clicked");
                      openLocation(widget.message.msg);
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 155,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: IgnorePointer(
                                    child: GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                        target: LatLng(getLatitude(widget.message.msg), getLongitude(widget.message.msg)),
                                        zoom: 14,
                                      ),
                                      onMapCreated: (GoogleMapController controller) {
                                        _controller.complete(controller);
                                      },
                                      zoomControlsEnabled: false,
                                      markers: _markers,
                                      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                                        Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                                      ].toSet(),
                                    ),
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24,)
                      ],
                    ),
                  ),
                ),
              if (widget.message.type == Type.contact)
                Padding(
                  padding: EdgeInsets.only(
                    left: 3,
                    right: 3,
                    top: 3,
                    bottom: 3,
                  ),
                  child: InkWell(
                    onTap: (){
                      print("clicked");
                      Get.to(()=>ViewContactScreen(personName: getContact(widget.message.msg)['name']!, personPhoneNumber: getContact(widget.message.msg)['phone']!));
                    },
                    child: Column(
                      children: [
                        // Container(
                        //   height: 155,
                        //   child: ClipRRect(
                        //     borderRadius: BorderRadius.circular(20),
                        //     child: Row(
                        //       children: [
                        //         Expanded(
                        //           child: IgnorePointer(
                        //             child: GoogleMap(
                        //               initialCameraPosition: CameraPosition(
                        //                 target: LatLng(getLatitude(widget.message.msg), getLongitude(widget.message.msg)),
                        //                 zoom: 14,
                        //               ),
                        //               onMapCreated: (GoogleMapController controller) {
                        //                 _controller.complete(controller);
                        //               },
                        //               zoomControlsEnabled: false,
                        //               markers: _markers,
                        //               gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                        //                 Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                        //               ].toSet(),
                        //             ),
                        //           ),
                        //         )
                        //
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        Container(padding:EdgeInsets.all(15),child: Row(
                          children: [
                            Icon(Icons.person, size: 41,),
                            SizedBox(width: 10,),
                            Text(getContact(widget.message.msg)['name']!, style: TextStyle(color: Colors.black, fontSize: 18),),
                          ],
                        )),
                        SizedBox(height: 8,)
                      ],
                    ),
                  ),
                ),

              Positioned(
                bottom: 4,
                right: 8,
                child: Row(
                  children: [
                    widget.message.starred != null &&
                            widget.message.starred == "true"
                        ? Icon(
                            Icons.star_rate_outlined,
                            color: widget.message.type == Type.image
                                ? Colors.white
                                : Colors.grey,
                            size: 15,
                          )
                        : SizedBox(),

                    widget.message.pinned != null &&
                        widget.message.pinned!
                        ? Icon(
                      CupertinoIcons.pin,
                      color: widget.message.type == Type.image
                          ? Colors.white
                          : Colors.grey,
                      size: 15,
                    )
                        : SizedBox(),

                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      MyDateUtil.getFormattedTime(
                          context: context, time: widget.message.sent),
                      style: TextStyle(
                        fontSize: 13,
                        color: widget.message.type == Type.image
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    if (widget.message.delivered.isNotEmpty && widget.message.read.isEmpty)
                      Icon(
                        Icons.done_all,
                        size: 20,
                      ),
                    if (widget.message.read.isNotEmpty)
                      Icon(
                        Icons.done_all,
                        size: 20,
                        color: Colors.green,
                      ),
                    if (widget.message.read.isEmpty && widget.message.delivered.isEmpty)
                      Icon(
                        Icons.done,
                        size: 20,
                        color: Colors.grey,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _slider() {
    return Expanded(
      child: Slider.adaptive(
          min: 0.0,
          max: duration.inSeconds.toDouble(),
          value: position.inSeconds.toDouble(),
          activeColor: Colors.black,
          inactiveColor: Colors.black,
          allowedInteraction: SliderInteraction.tapAndSlide,
          onChanged: (double value) {
            setState(() {
              audioPlayer.seek(Duration(seconds: value.toInt()));
            });
          }),
    );
  }

  Future<void> getAudio(String url) async {
    if (playing) {
      await audioPlayer.pause();
      setState(() {
        playing = false;
      });
    } else {
      var res = await audioPlayer.play(UrlSource(url));
      setState(() {
        playing = true;
        // audioPlayer.play();
      });
    }
    // audioPlayer!.onD
    duration = (await audioPlayer.getDuration())!;
    // audioPlayer.onDurationChanged.listen((Duration d) {
    //   setState(() {
    //     duration = d;
    //   });
    // });

    audioPlayer.onPositionChanged.listen((Duration d) {
      setState(() {
        position = d;
      });
    });

    audioPlayer.onPlayerComplete.listen((event) async {
      Duration? d = await audioPlayer.getCurrentPosition();
      audioPlayer.seek(Duration.zero);
      Fluttertoast.showToast(msg: 'msg $d');
      setState(() {
        // position = 0.0;
        playing = false;
      });
    });
  }

  String? getThumbnail(String msg) {
    final data = jsonDecode(msg);
    if (data is Map<String, dynamic>) {
      return data["thumb"] as String? ?? ""; // Handle potential null value
    }
  }

  double getLatitude(String location) {
    int qIndex = location.indexOf('q=');

    // Extract the substring starting from 'q=' to the end of the URL
    String coordinatesSubstring = location.substring(qIndex + 2);

    // Split the substring by ','
    List<String> coordinatesList = coordinatesSubstring.split(',');

    // Extract latitude and longitude
    String latitude = coordinatesList[0];
    print(latitude);
    return double.parse(latitude);
  }

  double getLongitude(String location) {
    int qIndex = location.indexOf('q=');

    // Extract the substring starting from 'q=' to the end of the URL
    String coordinatesSubstring = location.substring(qIndex + 2);

    // Split the substring by ','
    List<String> coordinatesList = coordinatesSubstring.split(',');

    // Extract latitude and longitude
    String longitude = coordinatesList[1];
    print(longitude);
    return double.parse(longitude);
  }

  Future<void> openLocation(String msg) async {
    if (await canLaunch(msg)) {
    await launch(msg);
    } else {
    throw 'Could not launch $msg';
    }
  }

  Map<String, String> getContact(String contact) {
    List<String> parts = contact.split(';');
    if (parts.length == 2) {
      return {
        'name': parts[0],
        'phone': parts[1],
      };
    } else {
      throw FormatException('Invalid encoded contact');
    }
  }
}

//custom options card (for copy, edit, delete, etc.)
class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * .05,
              top: MediaQuery.of(context).size.height * .015,
              bottom: MediaQuery.of(context).size.height * .015),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('    $name',
                    style: const TextStyle(
                        fontSize: 15, color: Colors.white, letterSpacing: 0.5)))
          ]),
        ));
  }
}
