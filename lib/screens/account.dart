import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speaky_chat/screens/privacy_options_page.dart';

import '../api/api_services.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String lastSeen = 'Nobody';
  String profilePhoto = 'Nobody';
  String about = 'Nobody';
  String status = 'Nobody';
  int readReceipt = 1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getPrivacySettings();
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
          'Account',
          style: TextStyle(color: Colors.white),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: isLoading? Center(child: CircularProgressIndicator()) :Container(
        padding: EdgeInsets.only(top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.only(left: 25, right: 25, top: 8),
                child: Text(
                  'Who can see my personal info',
                  style: TextStyle(color: Colors.white54),
                )),
            SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () {
                Get.to(() => PrivacyOptionsPage(
                      pageName: 'Last seen and online',
                      index: 0,
                      selectedOption: lastSeen,
                      lastSeen: lastSeen,
                      profilePhoto: profilePhoto,
                      about: about,
                      status: status,
                      readReceipt: readReceipt,
                ))?.then((value) => getPrivacySettings());
              },
              child: Container(
                padding:
                    EdgeInsets.only(left: 25, right: 25, top: 8, bottom: 8),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last seen and online',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      lastSeen,
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => PrivacyOptionsPage(
                      pageName: 'Profile Photo',
                      index: 1,
                      selectedOption: profilePhoto,
                      lastSeen: lastSeen,
                      profilePhoto: profilePhoto,
                      about: about,
                      status: status,
                      readReceipt: readReceipt,
                ))?.then((value) => getPrivacySettings());
              },
              child: Container(
                padding:
                    EdgeInsets.only(left: 25, right: 25, top: 8, bottom: 8),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile photo',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      profilePhoto,
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => PrivacyOptionsPage(
                      pageName: 'About',
                      index: 2,
                      selectedOption: about,
                      lastSeen: lastSeen,
                      profilePhoto: profilePhoto,
                      about: about,
                      status: status,
                      readReceipt: readReceipt,
                ))?.then((value) => getPrivacySettings());
              },
              child: Container(
                padding:
                    EdgeInsets.only(left: 25, right: 25, top: 8, bottom: 8),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      about,
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => PrivacyOptionsPage(
                      pageName: 'Status',
                      index: 3,
                      selectedOption: status,
                      lastSeen: lastSeen,
                      profilePhoto: profilePhoto,
                      about: about,
                      status: status,
                      readReceipt: readReceipt,
                    ))?.then((value) => getPrivacySettings());
              },
              child: Container(
                padding:
                    EdgeInsets.only(left: 25, right: 25, top: 8, bottom: 8),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      status,
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 25, right: 25, top: 8, bottom: 8),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Read receipts',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'if turned off, you won\'t send of receive Read receipts.',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  Switch(
                      value: readReceipt == 1 ? true : false,
                      onChanged: (value) {
                        readReceipt = value?1:0;
                        updateValues();
                        setState(() {

                        });
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Future<void> getPrivacySettings() async {
    var response = await APIService.getPrivacySettings();
    lastSeen = response['last_seen'] ?? 'Everyone';
    profilePhoto = response['profile_pic_permission'] ?? 'Everyone';
    about = response['about_permission'] ?? 'Everyone';
    status = response['status_permission'] ?? 'Everyone';
    readReceipt = response['read_receipt'] ?? 1;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> updateValues() async {
    var response = await APIService.updatePrivacySettings(lastSeen, profilePhoto, about, status, readReceipt);
  }
}
