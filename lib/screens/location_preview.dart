import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speaky_chat/model/chat_user.dart';
import 'package:speaky_chat/model/message_model.dart';

import '../api/api_services.dart';

class LocationPreviewPage extends StatefulWidget {
  final ChatUser chatUser;
  final RxList<Message> list;

  LocationPreviewPage({Key? key, required this.chatUser, required this.list}) : super(key: key);

  @override
  State<LocationPreviewPage> createState() => _LocationPreviewPageState();
}

class _LocationPreviewPageState extends State<LocationPreviewPage> {
  final Completer<GoogleMapController> _controller = Completer();
  late Position _currentPosition;
  Set<Marker> _markers = {};
  bool loading = true;
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _getUserCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading:   InkWell(
            onTap: (){
              Get.back();
            },
            child: Icon(Icons.navigate_before, color: Colors.white, size: 40,)
          ),
          title: Text('Location', style: TextStyle(color: Colors.white),),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.white,),
              onPressed: _getUserCurrentLocation,
            ),
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.white,),
              onPressed: _getUserCurrentLocation,
            ),
          ],
        ),
        body: loading ? Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black,)) :Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: isFullScreen ? MediaQuery.of(context).size.height*.75 :250,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
                      zoom: 14,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    zoomControlsEnabled: false,
                    markers: _markers,
                  ),
                ),
                // SizedBox(
                //   height: isFullScreen ? null : 250,
                //   child: GoogleMap(
                //     initialCameraPosition: CameraPosition(
                //       target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
                //       zoom: 14,
                //     ),
                //     onMapCreated: (GoogleMapController controller) {
                //       _controller.complete(controller);
                //     },
                //     zoomControlsEnabled: false,
                //     markers: _markers,
                //   ),
                // ),'
                Positioned(
                  bottom: 10,
                  left:10,child:     InkWell(onTap:(){
                  setState(() {
                    isFullScreen = !isFullScreen;
                  });
                },child: Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color:Colors.white,),child: Icon(isFullScreen? Icons.fullscreen_exit :Icons.fullscreen, color: Colors.black, size: 34,))),),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color:Colors.white,),child: Icon(Icons.location_on_outlined, color: Colors.black, size: 34,)),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              height: 100,
              padding: EdgeInsets.all(11),
              color: Colors.white,
              child: InkWell(
                onTap: (){
                  // print(_currentPosition);
                  // print("https://maps.google.com/?q=${_currentPosition.latitude},${_currentPosition.longitude}");
                  int time = DateTime.now().millisecondsSinceEpoch;
                  APIService.sendMessage(
                      widget.chatUser,
                      "https://maps.google.com/?q=${_currentPosition.latitude},${_currentPosition.longitude}",
                      Type.location,
                  time, widget.list);
                  Get.back();
                },
                child: Row(
                  children: [
                    Container(padding: EdgeInsets.all(11), decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color:Colors.black,), child: Icon(Icons.my_location_sharp, color: Colors.white, size: 35,),),
                    SizedBox(width: 12,),
                    Center(
                      child: Text('SEND YOUR CURRENT LOCATION', style: TextStyle(color: Colors.black, fontSize: 16),),
                    ),
                  ],
                ),
              ),
            ),
            !isFullScreen ? Expanded(child: SizedBox()): SizedBox(),
          ],
        ),
      ),
    );
  }

  Future<void> _getUserCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('current_location'),
          position: LatLng(_currentPosition.latitude, _currentPosition.longitude),
          infoWindow: InfoWindow(
            title: 'Current Location',
          ),
        ),
      );
      loading = false;
    });
  }
}