import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speaky_chat/api/api_services.dart';

import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';

class PrivacyOptionsPage extends StatefulWidget {
  var pageName;

  var index;

  var selectedOption;

  var lastSeen;

  var profilePhoto;

  var about;

  var status;

  var readReceipt;

  PrivacyOptionsPage(
      {super.key,
      required this.pageName,
      required this.index,
      required this.selectedOption,
      required this.lastSeen,
      required this.profilePhoto,
      required this.about,
      required this.status,
      required this.readReceipt});

  @override
  State<PrivacyOptionsPage> createState() => _PrivacyOptionsPageState();
}

class _PrivacyOptionsPageState extends State<PrivacyOptionsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String lastSeen = 'Everyone';
  String profilePhoto = 'Everyone';
  String about = 'Everyone';
  String status = 'My Contacts';


  @override
  void initState() {
    super.initState();
    setPrivacyDetails();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 60.0,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).secondaryBackground,
            size: 30.0,
          ),
          onPressed: () async {
            Get.back();
          },
        ),
        title: Text(
          widget.pageName,
          style: TextStyle(color: Colors.white),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 25, right: 25, top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Who can see my ${widget.pageName}',
              style: TextStyle(color: Colors.white54),
            ),
            SizedBox(
              height: 10,
            ),
            widget.index == 3 ? SizedBox() : RadioListTile(
              title: Text(
                'Everyone',
                style: TextStyle(color: Colors.white),
              ),
              value: 'Everyone',
              groupValue: widget.selectedOption,
              onChanged: (value) {
                setState(() {
                  widget.selectedOption = 'Everyone';
                  if(widget.index == 0){
                    lastSeen = 'Everyone';
                  }else if(widget.index == 1){
                    profilePhoto = 'Everyone';
                  }else if(widget.index == 2){
                    about = 'Everyone';
                  }else {
                    status = 'Everyone';
                  }
                  updateValues();
                });
              },
            ),
            RadioListTile(
              title: Text(
                'My Contacts',
                style: TextStyle(color: Colors.white),
              ),
              value: 'My Contacts',
              groupValue: widget.selectedOption,
              onChanged: (value) {
                setState(() {
                  widget.selectedOption = 'My Contacts';
                  if(widget.index == 0){
                    lastSeen = 'My Contacts';
                  }else if(widget.index == 1){
                    profilePhoto = 'My Contacts';
                  }else if(widget.index == 2){
                    about = 'My Contacts';
                  }else {
                    status = 'My Contacts';
                  }
                  updateValues();
                });
              },
            ),
            // RadioListTile(
            //   title: Text(
            //     'My Contacts Except...',
            //     style: TextStyle(color: Colors.white),
            //   ),
            //   value: 'My Contacts Except...',
            //   groupValue: widget.selectedOption,
            //   onChanged: (value) {
            //     setState(() {
            //       widget.selectedOption = 'My Contacts Except...';
            //
            //     });
            //   },
            // ),
            RadioListTile(
              title: Text(
                'Nobody',
                style: TextStyle(color: Colors.white),
              ),
              value: 'Nobody',
              groupValue: widget.selectedOption,
              onChanged: (value) {
                setState(() {
                  widget.selectedOption = 'Nobody';
                  if(widget.index == 0){
                    lastSeen = 'Nobody';
                  }else if(widget.index == 1){
                    profilePhoto = 'Nobody';
                  }else if(widget.index == 2){
                    about = 'Nobody';
                  }else {
                    status = 'Nobody';
                  }
                  updateValues();
                });
              },
            ),
          ],
        ),
      ),
    ));
  }

  Future<void> updateValues() async {
    var response = await APIService.updatePrivacySettings(lastSeen, profilePhoto, about, status, widget.readReceipt);
  }

  void setPrivacyDetails() {
    lastSeen = widget.lastSeen;
    profilePhoto = widget.profilePhoto;
    about = widget.about;
    status = widget.status;
  }
}
