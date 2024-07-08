import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:speaky_chat/screens/account.dart';
import 'package:speaky_chat/screens/privacy.dart';
import 'package:speaky_chat/screens/update_profile.dart';

import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';

class SettingsPage extends StatefulWidget {
  var profile_pic;


  SettingsPage(
      {super.key, required this.profile_pic});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String lastSeen = 'Nobody';
  String name = '';
  String profile_pic = '';
  String about = '';
  String mobile = '';


  @override
  void initState() {
    super.initState();
    loadData();
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
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: Colors.white54,
                  height: 1,
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => UpdateProfilePage(name: name, profile_pic: profile_pic, about: about, mobile: mobile))?.then((value) => loadData());
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 30.0, bottom: 13, top: 13, right: 30),
                    child: Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: CachedNetworkImage(
                              height: 65,
                              width: 65,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                  child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1,
                                        color: Colors.red,
                                      ))),
                              imageUrl: profile_pic,
                            )),
                        SizedBox(width: 16,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style:
                                    TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              Text(
                                about,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 17),
                                maxLines: 1,
                                // Set the maximum number of lines
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16,),
                        Icon(Icons.navigate_next, color: Colors.white,)
                      ],
                    ),
                  ),
                ),Divider(
                  color: Colors.white54,
                  height: 1,
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => AccountPage());
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 30.0, bottom: 13, top: 13),
                      child: Text(
                        'Account',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white54,
                  height: 1,
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => PrivacyPage());
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 30.0, bottom: 13, top: 13),
                      child: Text(
                        'Privacy',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white54,
                  height: 1,
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }

  loadData() async {
    var sessionManager = new SessionManager();
    profile_pic=='' ? profile_pic = widget.profile_pic : profile_pic = await sessionManager.get("profile_pic");
    name = await sessionManager.get("username");
    // Fluttertoast.showToast(msg: profile_pic);
    about = await sessionManager.get("about");
    mobile = await sessionManager.get("mobilenumber");
    setState(() {

    });
  }
}
