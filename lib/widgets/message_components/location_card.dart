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
class LocationMessage extends StatefulWidget {
  final String user2Name;

  final String fromPic;

  const LocationMessage(
      {super.key,
      required this.message,
      required this.user,
      required this.user2Name,
      required this.fromPic});

  final Message message;
  final ChatUser user;

  @override
  State<LocationMessage> createState() => _LocationMessageState();
}

class _LocationMessageState extends State<LocationMessage> {
  Set<Marker> _markers = {};
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    _markers.add(
      Marker(
        markerId: MarkerId('current_location'),
        position: LatLng(getLatitude(widget.message.msg), getLongitude(widget.message.msg)),
        infoWindow: InfoWindow(
          title: 'Current Location',
        ),
      ),
    );

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
}