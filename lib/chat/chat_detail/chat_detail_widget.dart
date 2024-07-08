import 'dart:io';
import 'dart:async';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:camera/camera.dart';
import '../../api/api_services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import '../../model/message_model.dart';
import '../../helpers/my_date_util.dart';
import '../../offline/message_hive.dart';
import '../../helpers/network_check.dart';
import '/components/uploads_b_s_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../controllers/chat_screen_cont.dart';
import 'package:speaky_chat/model/chat_user.dart';
import 'package:speaky_chat/model/typing_user.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../widgets/message_components/image_card.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speaky_chat/chat/chat_all/message_card.dart';
import '../../widgets/message_components/document_card.dart';
import 'package:speaky_chat/screens/camera_screen_widget.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:speaky_chat/widgets/message_components/audio_card.dart';
import 'package:speaky_chat/widgets/message_components/video_card.dart';
import 'package:speaky_chat/widgets/message_components/contact_card.dart';
import 'package:speaky_chat/widgets/message_components/location_card.dart';

export 'chat_detail_model.dart';

class ChatDetailWidget extends StatefulWidget {
  const ChatDetailWidget({super.key});

  @override
  State<ChatDetailWidget> createState() => _ChatDetailWidgetState();
}

class ChatDetailPageRoute extends MaterialPageRoute {
  ChatDetailPageRoute()
      : super(
          builder: (BuildContext context) => const ChatDetailWidget(),
        );
}

class _ChatDetailWidgetState extends State<ChatDetailWidget>
    with TickerProviderStateMixin {
  var cont = Get.find<ChatScreenController>();
  late AnimationController _controller;

  late final List<CameraDescription> cameras;

  final List<GlobalKey> itemKeys = [];
  String lastPinned = '';
  bool _emojiShowing = false;
  bool _isOffline = false;

  final NetworkCheck networkCheck = NetworkCheck();
  late StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    init();
    cont.messageController.addListener(_onTextChanged);
    // fetchPinned();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    checkConnectivity();
    checkPermissions();

    subscription =
        networkCheck.connectionStream.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        checkConnectivity();
      }
    });
    // connect();
  }

  @override
  void dispose() {
    _controller.dispose();
    cont.messageController.clear();
    cont.messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return WillPopScope(
      onWillPop: () {
        if (_emojiShowing) {
          setState(() => _emojiShowing = !_emojiShowing);
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        key: cont.scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderWidth: 1.0,
                buttonSize: 40.0,
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 30.0,
                ),
                onPressed: () async {
                  if (cont.isSearching.value) {
                    cont.searchFocusNode.unfocus();
                    cont.searchController.clear();
                  }
                  cont.isSearching.value
                      ? cont.isSearching.value = false
                      : Get.back();
                },
              ),
            ],
          ),
          title: Align(
            alignment: const AlignmentDirectional(0.0, 0.0),
            child: cont.isSearching.value
                ? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey),
                        color: Colors.black),
                    height: 50,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: TextField(
                          maxLines: null,
                          controller: cont.searchController,
                          focusNode: cont.searchFocusNode,
                          style: const TextStyle(color: Colors.white),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              searchAndScroll(value);
                            } else {}
                            print(value);
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search...",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        )),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(-1.0, -1.0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 12.0, 0.0),
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).accent1,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: CircleAvatar(
                                radius: 23,
                                backgroundColor: Colors.blueGrey[200],
                                child: cont.profilePic.value != ''
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(60),
                                        child: CachedNetworkImage(
                                          height: 65,
                                          width: 65,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const Center(
                                                  child: SizedBox(
                                                      width: 50,
                                                      height: 50,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 1,
                                                        color: Colors.red,
                                                      ))),
                                          imageUrl: cont.profilePic.value,
                                        ))
                                    : SvgPicture.asset(
                                        "assets/person.svg",
                                        color: Colors.white,
                                        height: 30,
                                        width: 30,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      StreamBuilder(
                          stream: APIService.getTyping(cont.user),
                          builder: (context, snapshot) {
                            final typingData = snapshot.data?.docs;

                            // typingData
                            //     ?.map((e) => print(e.data()))
                            //     .toList() ??
                            //     [];

                            final typingList = typingData
                                    ?.map((e) => TypingUser.fromJson(e.data()))
                                    .toList() ??
                                [];
                            // print(typingList[0].isTyping);
                            return StreamBuilder(
                                stream: APIService.getUserInfo(cont.user),
                                builder: (context, snapshot) {
                                  final data = snapshot.data?.docs;
                                  final list = data
                                          ?.map((e) =>
                                              ChatUser.fromJson(e.data()))
                                          .toList() ??
                                      [];
                                  return Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cont.nickname.value,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .override(
                                              fontFamily: 'Readex Pro',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 4.0, 0.0, 0.0),
                                        child: Text(
                                          typingList.isNotEmpty &&
                                                  typingList[0].isTyping
                                              ? 'Typing...'
                                              : list.isNotEmpty
                                                  ? list[0].isOnline
                                                      ? 'Online'
                                                      : MyDateUtil
                                                          .getLastActiveTime(
                                                              context: context,
                                                              lastActive: list[
                                                                      0]
                                                                  .lastActive)
                                                  : MyDateUtil
                                                      .getLastActiveTime(
                                                          context: context,
                                                          lastActive: cont
                                                              .user.lastActive),
                                          style: FlutterFlowTheme.of(context)
                                              .labelSmall
                                              .override(
                                                fontFamily: 'Readex Pro',
                                                color: Colors.grey,
                                              ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          }),
                    ],
                  ),
          ),
          actions: [
            cont.isSearching.value
                ? Row(
                    children: [
                      Icon(
                        Icons.arrow_downward_rounded,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        size: 24.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 18),
                        child: Icon(
                          Icons.arrow_upward_rounded,
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          size: 24.0,
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          _buildBottomSheet(),
                          backgroundColor: Colors.transparent,
                        );
                      },
                      child: Icon(
                        Icons.more_vert,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        size: 24.0,
                      ),
                    ),
                  ),
          ],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: GetBuilder<ChatScreenController>(builder: (con) {
          return SafeArea(
            top: true,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder(
                    stream: APIService.listenForData(cont.user.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(); // Show nothing while loading
                      }

                      if (snapshot.hasError) {
                        // Handle errors (optional)
                        print('Error: ${snapshot.error}');
                        return const SizedBox(); // Or display an error message
                      }

                      if (!snapshot.hasData) {
                        // Handle the case where no data is present (e.g., document not found)
                        print('No document found');
                        return const SizedBox();
                      }

                      final DocumentSnapshot document =
                          snapshot.data! as DocumentSnapshot;
                      ;

                      return document.exists
                          ? Column(
                              children: [
                                const Divider(
                                  color: Colors.white,
                                  height: 1,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      const Icon(
                                        CupertinoIcons.pin,
                                        color: Colors.grey,
                                        size: 18,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      if (document.get('type') == 'text')
                                        Expanded(
                                          child: Text(
                                            document.get('msg'),
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 24),
                                          ),
                                        ),
                                      if (document.get('type') == 'image')
                                        const Icon(
                                          Icons.image,
                                          color: Colors.grey,
                                          size: 23,
                                        ),
                                      if (document.get('type') == 'video')
                                        const Icon(
                                          Icons.local_movies,
                                          color: Colors.grey,
                                          size: 23,
                                        ),
                                      if (document.get('type') == 'audio')
                                        const Icon(
                                          Icons.headphones,
                                          color: Colors.grey,
                                          size: 23,
                                        ),
                                      if (document.get('type') == 'document')
                                        const Icon(
                                          Icons.file_present,
                                          color: Colors.grey,
                                          size: 23,
                                        ),
                                      if (document.get('type') != 'text')
                                        const SizedBox(
                                          width: 10,
                                        ),
                                      if (document.get('type') != 'text')
                                        Text(
                                          document
                                              .get('type')
                                              .toString()
                                              .capitalizeFirst!,
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 24),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(); // Display nothing if document doesn't exist
                    },
                  ),
                  const Divider(
                    color: Colors.white,
                    height: 1,
                  ),
                  Expanded(
                    child: _isOffline
                        ? cont.offlineMessages.value.isNotEmpty
                            ? Obx(
                                () => ListView.builder(
                                  reverse: true,
                                  controller: cont.scrollController,
                                  itemCount: cont.offlineMessages.value.length,
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        .01,
                                  ),
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    print("Building item at index: $index");
                                    final message =
                                        cont.offlineMessages.value[index];
                                    final isMe =
                                        APIService.user.uid == message.fromId;

                                    // Handle different message types
                                    Widget messageWidget;
                                    switch (message.type) {
                                      case Type.text:
                                        messageWidget = MessageCard(
                                          message: message,
                                          user: cont.user,
                                          user2Name: cont.nickname.value,
                                          fromPic: cont.profilePic.value,
                                        );
                                        break;
                                      case Type.image:
                                        messageWidget = ImageMessage(
                                          message: message,
                                          user: cont.user,
                                          user2Name: cont.nickname.value,
                                          fromPic: cont.profilePic.value,
                                        );
                                        break;
                                      case Type.document:
                                        messageWidget = DocumentMessage(
                                          message: message,
                                          user: cont.user,
                                          user2Name: cont.nickname.value,
                                          fromPic: cont.profilePic.value,
                                        );
                                        break;
                                      case Type.location:
                                        messageWidget = LocationMessage(
                                          message: message,
                                          user: cont.user,
                                          user2Name: cont.nickname.value,
                                          fromPic: cont.profilePic.value,
                                        );
                                        break;
                                      case Type.contact:
                                        messageWidget = ContactMessage(
                                          message: message,
                                          user: cont.user,
                                          user2Name: cont.nickname.value,
                                          fromPic: cont.profilePic.value,
                                        );
                                        break;
                                      case Type.audio:
                                        messageWidget = AudioMessage(
                                          message: message,
                                          user: cont.user,
                                          user2Name: cont.nickname.value,
                                          fromPic: cont.profilePic.value,
                                        );
                                        break;
                                      case Type.video:
                                        messageWidget = VideoMessage(
                                          message: message,
                                          user: cont.user,
                                          user2Name: cont.nickname.value,
                                          fromPic: cont.profilePic.value,
                                        );
                                        break;
                                      default:
                                        messageWidget = SizedBox.shrink();
                                        break;
                                    }

                                    return InkWell(
                                      onLongPress: () {
                                        _showBottomSheet(
                                          isMe,
                                          message,
                                          cont.user,
                                          cont.nickname.value,
                                          cont.profilePic.value,
                                        );
                                      },
                                      child: messageWidget,
                                    );
                                  },
                                ),
                              )
                            : const Center(
                                child: Text('Say Hii! 👋',
                                    style: TextStyle(fontSize: 20)),
                              )
                        : StreamBuilder(
                            stream: APIService.getAllMessages(cont.user),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                //if data is loading
                                case ConnectionState.waiting:
                                case ConnectionState.none:
                                  return const SizedBox();

                                //if some or all data is loaded then show it
                                case ConnectionState.active:
                                case ConnectionState.done:
                                  final data = snapshot.data?.docs;
                                  cont.list.value = data
                                          ?.map(
                                              (e) => Message.fromJson(e.data()))
                                          .toList() ??
                                      [];

                                  storeMessage(cont.user, cont.list.value);
                                  if (cont.list.value.isNotEmpty) {
                                    return Obx(
                                      () => ListView.builder(
                                          reverse: true,
                                          controller: cont.scrollController,
                                          itemCount: cont.list.value.length,
                                          padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .01),
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            final itemKey = GlobalKey();
                                            // Add the key to the list
                                            itemKeys.add(itemKey);

                                            // print(cont.list.value.value[index].msg);
                                            if (cont.list.value[index].type ==
                                                Type.text) {
                                              return InkWell(
                                                onLongPress: () async {
                                                  bool isMe =
                                                      APIService.user.uid ==
                                                          cont.list.value[index]
                                                              .fromId;
                                                  _showBottomSheet(
                                                      isMe,
                                                      cont.list.value[index],
                                                      cont.user,
                                                      cont.nickname.value,
                                                      cont.profilePic.value);
                                                },
                                                child: MessageCard(
                                                  key: itemKeys[index],
                                                  message:
                                                      cont.list.value[index],
                                                  user: cont.user,
                                                  user2Name:
                                                      cont.nickname.value,
                                                  fromPic:
                                                      cont.profilePic.value,
                                                ),
                                              );
                                            }

                                            if (cont.list.value[index].type ==
                                                Type.image) {
                                              return InkWell(
                                                onLongPress: () {
                                                  bool isMe =
                                                      APIService.user.uid ==
                                                          cont.list.value[index]
                                                              .fromId;
                                                  _showBottomSheet(
                                                      isMe,
                                                      cont.list.value[index],
                                                      cont.user,
                                                      cont.nickname.value,
                                                      cont.profilePic.value);
                                                },
                                                child: ImageMessage(
                                                  key: itemKeys[index],
                                                  message:
                                                      cont.list.value[index],
                                                  user: cont.user,
                                                  user2Name:
                                                      cont.nickname.value,
                                                  fromPic:
                                                      cont.profilePic.value,
                                                ),
                                              );
                                            }

                                            if (cont.list.value[index].type ==
                                                Type.document) {
                                              return InkWell(
                                                onLongPress: () {
                                                  bool isMe =
                                                      APIService.user.uid ==
                                                          cont.list.value[index]
                                                              .fromId;
                                                  _showBottomSheet(
                                                      isMe,
                                                      cont.list.value[index],
                                                      cont.user,
                                                      cont.nickname.value,
                                                      cont.profilePic.value);
                                                },
                                                child: DocumentMessage(
                                                  key: itemKeys[index],
                                                  message:
                                                      cont.list.value[index],
                                                  user: cont.user,
                                                  user2Name:
                                                      cont.nickname.value,
                                                  fromPic:
                                                      cont.profilePic.value,
                                                ),
                                              );
                                            }

                                            if (cont.list.value[index].type ==
                                                Type.audio) {
                                              return InkWell(
                                                onLongPress: () {
                                                  bool isMe =
                                                      APIService.user.uid ==
                                                          cont.list.value[index]
                                                              .fromId;
                                                  _showBottomSheet(
                                                      isMe,
                                                      cont.list.value[index],
                                                      cont.user,
                                                      cont.nickname.value,
                                                      cont.profilePic.value);
                                                },
                                                child: AudioMessage(
                                                  key: itemKeys[index],
                                                  message:
                                                      cont.list.value[index],
                                                  user: cont.user,
                                                  user2Name:
                                                      cont.nickname.value,
                                                  fromPic:
                                                      cont.profilePic.value,
                                                ),
                                              );
                                            }

                                            if (cont.list.value[index].type ==
                                                Type.video) {
                                              return InkWell(
                                                onLongPress: () {
                                                  bool isMe =
                                                      APIService.user.uid ==
                                                          cont.list.value[index]
                                                              .fromId;
                                                  _showBottomSheet(
                                                      isMe,
                                                      cont.list.value[index],
                                                      cont.user,
                                                      cont.nickname.value,
                                                      cont.profilePic.value);
                                                },
                                                child: VideoMessage(
                                                  key: itemKeys[index],
                                                  message:
                                                      cont.list.value[index],
                                                  user: cont.user,
                                                  user2Name:
                                                      cont.nickname.value,
                                                  fromPic:
                                                      cont.profilePic.value,
                                                ),
                                              );
                                            }

                                            if (cont.list.value[index].type ==
                                                Type.contact) {
                                              return InkWell(
                                                onLongPress: () {
                                                  bool isMe =
                                                      APIService.user.uid ==
                                                          cont.list.value[index]
                                                              .fromId;
                                                  _showBottomSheet(
                                                      isMe,
                                                      cont.list.value[index],
                                                      cont.user,
                                                      cont.nickname.value,
                                                      cont.profilePic.value);
                                                },
                                                child: ContactMessage(
                                                  key: itemKeys[index],
                                                  message:
                                                      cont.list.value[index],
                                                  user: cont.user,
                                                  user2Name:
                                                      cont.nickname.value,
                                                  fromPic:
                                                      cont.profilePic.value,
                                                ),
                                              );
                                            }

                                            if (cont.list.value[index].type ==
                                                Type.location) {
                                              return InkWell(
                                                onLongPress: () {
                                                  bool isMe =
                                                      APIService.user.uid ==
                                                          cont.list.value[index]
                                                              .fromId;
                                                  _showBottomSheet(
                                                      isMe,
                                                      cont.list.value[index],
                                                      cont.user,
                                                      cont.nickname.value,
                                                      cont.profilePic.value);
                                                },
                                                child: LocationMessage(
                                                  key: itemKeys[index],
                                                  message:
                                                      cont.list.value[index],
                                                  user: cont.user,
                                                  user2Name:
                                                      cont.nickname.value,
                                                  fromPic:
                                                      cont.profilePic.value,
                                                ),
                                              );
                                            }
                                          }),
                                    );
                                  } else {
                                    return const Center(
                                      child: Text('Say Hii! 👋',
                                          style: TextStyle(fontSize: 20)),
                                    );
                                  }
                              }
                            },
                          ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3.0,
                          color: Color(0x33000000),
                          offset: Offset(0.0, -2.0),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          color: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              Obx(
                                () => cont.isRecording.value
                                    ? AnimatedBuilder(
                                        animation: _controller,
                                        builder: (context, child) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.6, right: 4.6),
                                            child: Icon(
                                              Icons.mic,
                                              size: 30,
                                              color: Colors.red.withOpacity(
                                                  _controller.value),
                                            ),
                                          );
                                        },
                                      )
                                    : FlutterFlowIconButton(
                                        borderRadius: 60.0,
                                        borderWidth: 1.0,
                                        buttonSize: 40.0,
                                        fillColor: Colors.black,
                                        icon: const Icon(
                                          Icons.add_rounded,
                                          color: Colors.white,
                                          size: 24.0,
                                        ),
                                        onPressed: () async {
                                          await showModalBottomSheet(
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            enableDrag: false,
                                            context: context,
                                            builder: (context) {
                                              return GestureDetector(
                                                onTap: () => {},
                                                child: Padding(
                                                  padding:
                                                      MediaQuery.viewInsetsOf(
                                                          context),
                                                  child: UploadsBSWidget(
                                                      isFirstMessage: cont
                                                          .list.value.isEmpty,
                                                      chatUser: cont.user,
                                                      action: () async {},
                                                      cameras: cameras,
                                                      list: cont.list),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: Colors.white),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, right: 20.0),
                                        child: Obx(
                                          () => TextField(
                                            maxLines: null,
                                            controller: cont.messageController,
                                            focusNode: cont.messageFocusNode,
                                            onTap: () {
                                              if (_emojiShowing) {
                                                setState(() {
                                                  _emojiShowing =
                                                      !_emojiShowing;
                                                });
                                              }
                                            },
                                            onChanged: (value) {
                                              print(cont.messageController.text
                                                  .length);
                                              if (value.isNotEmpty) {
                                                cont.visible.value = false;
                                              } else {
                                                cont.visible.value = true;
                                              }
                                            },
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: cont.isRecording.value
                                                  ? ""
                                                  : "Let's Type Something",
                                              hintStyle: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Obx(() => cont.isRecording.value
                                        ? Container(
                                            height: 48,
                                            padding: const EdgeInsets.only(
                                                right: 20, left: 24),
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                    child: Obx(() => Text(
                                                          cont.formattedTime,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 16),
                                                        ))),
                                                const Icon(
                                                  CupertinoIcons.left_chevron,
                                                  color: Colors.grey,
                                                  size: 19,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                const Text(
                                                  'Slide to cancel',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Visibility(
                                                visible: cont.visible.value,
                                                child: Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          1.0, 0.0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0, 8.0, 6.0, 0.0),
                                                    child: InkWell(
                                                      onTap: () async {
                                                        // _takePhotoOrVideo();
                                                        bool
                                                            cameraPermissionGranted =
                                                            await checkCameraPermission(
                                                                context);
                                                        if (cameraPermissionGranted) {
                                                          var result =
                                                              await Get.to(() =>
                                                                  CameraScreenWidget(
                                                                    cameras:
                                                                        cameras,
                                                                    chatuser:
                                                                        cont.user,
                                                                    list: cont
                                                                        .list,
                                                                  ));

                                                          print(
                                                              '>>>>>result:$result && ${cont.list.value.length}');
                                                          print(
                                                              '>>>>>result1:$result && ${cont.list.value.last.msg}');
                                                          if (result != null) {
                                                            await Future.delayed(
                                                                const Duration(
                                                                    seconds:
                                                                        10));
                                                            result.delete();
                                                            setState(() {});
                                                          }
                                                        }
                                                      },
                                                      child: Icon(
                                                        Icons
                                                            .shutter_speed_outlined,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        size: 30.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        1.0, 0.0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0, 8.0, 13.0, 0.0),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      setState(() {
                                                        if (_emojiShowing) {
                                                          cont.messageFocusNode
                                                              .requestFocus();
                                                          _emojiShowing =
                                                              !_emojiShowing;
                                                        } else {
                                                          _emojiShowing =
                                                              !_emojiShowing;
                                                          cont.messageFocusNode
                                                              .unfocus();
                                                        }
                                                      });
                                                    },
                                                    child: Icon(
                                                      _emojiShowing
                                                          ? Icons.keyboard
                                                          : Icons
                                                              .emoji_emotions_outlined,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      size: 30.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 5),
                              Obx(() => cont.visible.value
                                  ? GestureDetector(
                                      onTap: () {
                                        Fluttertoast.showToast(
                                            msg: 'Press and hold to record');
                                      },
                                      onLongPressStart: (_) {
                                        cont.checkPermission();
                                        // cont.startRecording();
                                      },
                                      onLongPressEnd: (details) async {
                                        if (details
                                                .velocity.pixelsPerSecond.dx <
                                            0.0) {
                                          cont.stopRecording(false);
                                        } else {
                                          cont.stopRecording(true);
                                        }
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: const Color(0xff000000)),
                                          child: const Icon(
                                            Icons.mic,
                                            color: Colors.white,
                                          )),
                                    )
                                  : InkWell(
                                      onTap: () async {
                                        if (cont.messageController.text
                                            .isNotEmpty) {
                                          if (cont.list.value.isEmpty) {
                                            //on first message (add user to my_user collection of chat user)
                                            APIService.sendFirstMessage(
                                                cont.user,
                                                cont.messageController.text,
                                                Type.text,
                                                cont.list);
                                          } else {
                                            //simply send message
                                            int time = DateTime.now()
                                                .millisecondsSinceEpoch;
                                            APIService.sendMessage(
                                                cont.user,
                                                cont.messageController.text,
                                                Type.text,
                                                time,
                                                _isOffline
                                                    ? cont.offlineMessages
                                                    : cont.list);
                                          }
                                          cont.visible.value = true;
                                          cont.messageController.clear();
                                          cont.messageFocusNode.unfocus();
                                        }
                                        // if (cont.messageController.text.isEmpty) {
                                        //   return;
                                        // }
                                        // cont.sendMessage(
                                        //     cont.messageController.text,
                                        //     cont.sourceChat.value,
                                        //     cont.user.id,
                                        //     cont.socket);
                                        // await APIService.sendMessage(cont.user,
                                        //         cont.messageController.text, Type.text)
                                        //     .then((value) => null);
                                        //
                                        // cont.messageController.clear();
                                        // cont.messageFocusNode.unfocus();
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: const Color(0xff000000)),
                                          child: const Icon(
                                            Icons.send,
                                            color: Colors.white,
                                          )),
                                    )),
                            ],
                          ),
                        ),
                        Offstage(
                            offstage: !_emojiShowing,
                            child: EmojiPicker(
                              textEditingController: cont.messageController,
                              onEmojiSelected: (_, __) {
                                print(cont.visible.value);
                              },
                              config: Config(
                                height: 286,
                                checkPlatformCompatibility: true,
                                emojiViewConfig: EmojiViewConfig(
                                  backgroundColor: Colors.black45,
                                  columns: 8,
                                  // Issue: https://github.com/flutter/flutter/issues/28894
                                  emojiSizeMax:
                                      28 * (Platform.isIOS ? 1.20 : 1.0),
                                ),
                                swapCategoryAndBottomBar: false,
                                skinToneConfig: const SkinToneConfig(),
                                categoryViewConfig: const CategoryViewConfig(),
                                bottomActionBarConfig:
                                    const BottomActionBarConfig(),
                                searchViewConfig: const SearchViewConfig(),
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<bool> checkCameraPermission(BuildContext context) async {
    PermissionStatus status = await Permission.camera.status;
    if (!status.isGranted) {
      // If camera permission is not granted, request permission
      PermissionStatus permissionStatus = await Permission.camera.request();
      return permissionStatus.isGranted;
    }
    return true;
  }

  Future<void> init() async {
    cameras = await availableCameras();
    setState(() {});
  }

  Widget _buildBottomSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                border: Border(
                    bottom: BorderSide.none,
                    top: BorderSide(color: Colors.white))),
            child: Image.asset(
              'assets/images/img.png',
              height: 4,
            ),
          ),
          _buildBottomSheetButton('VIEW CONTACT'),
          _buildBottomSheetButton('SEARCH'),
          _buildBottomSheetButton('MEDIA, LINKS AND DOCS'),
          _buildBottomSheetButton('MUTE NOTIFICATIONS'),
          _buildBottomSheetButton('WALLPAPER'),
          _buildBottomSheetButton('CLEAR CHAT'),
          _buildBottomSheetButton('ADD SHORTCUT'),
          _buildBottomSheetButton('BLOCK'),
        ],
      ),
    );
  }

  Widget _buildBottomSheetButton(String text) {
    return InkWell(
      child: SizedBox(
          height: 46,
          child: Column(
            children: [
              Text(
                text,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider()
            ],
          )),
      onTap: () {
        // Handle button tap
        if (text == "SEARCH") {
          cont.isSearching.value = true;
          cont.searchFocusNode.requestFocus();
          Get.back();
        } else {
          Get.back(); // Close the bottom sheet
        }
      },
    );
  }

  void searchAndScroll(String searchTerm) {
    if (searchTerm.isEmpty || itemKeys.isEmpty || cont.list.value.isEmpty) {
      return; // Do nothing if search term or lists are empty
    }

    for (var index = 0; index < cont.list.value.length; index++) {
      if (cont.list.value[index].msg
          .toLowerCase()
          .contains(searchTerm.toLowerCase())) {
        // Print the matched message
        print(
            "Matched Message: ${cont.list.value[index].msg} and index is $index");

        if (index < itemKeys.length) {
          final itemContext = itemKeys[index].currentContext;
          if (itemContext != null) {
            final renderObject = itemContext.findRenderObject();
            if (renderObject != null) {
              // Scroll to the item smoothly
              cont.scrollController.position.ensureVisible(
                renderObject,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              break; // Exit the loop after finding the first match
            } else {
              print("RenderObject is null for index $index");
            }
          } else {
            print("ItemContext is null for index $index");
          }
        } else {
          print("Index $index is out of bounds for itemKeys");
        }
      }
    }
  }

  // Future<void> fetchPinned() async {
  //   Map userData = await APIService.listenForData(cont.user.id);
  //
  //   if (userData.isNotEmpty) {
  //     // Access data using userData map
  //     print("user data is: $userData");
  //     // String userName = userData['name'];
  //     cont.pinnedChat.value = userData['msg'];
  //     cont.pinnedChatType.value = userData['type'];
  //
  //     // setState(() {
  //     //
  //     // });
  //     // ...
  //   }
  // }

  void _showBottomSheet(bool isMe, Message message, ChatUser user,
      String user2Name, String fromPic) {
    showModalBottomSheet(
        backgroundColor: Colors.black,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              //black divider
              Container(
                padding: const EdgeInsets.only(top: 20),
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    border: Border(
                        bottom: BorderSide.none,
                        top: BorderSide(color: Colors.white))),
              ),
              Container(
                height: 3,
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * .015,
                    horizontal: MediaQuery.of(context).size.width * .44),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),

              _OptionItem(
                  icon: const Icon(CupertinoIcons.pin,
                      color: Colors.white, size: 26),
                  name: message.pinned != null && message.pinned!
                      ? 'Unpin Message'
                      : 'Pin Message',
                  onTap: () async {
                    //for hiding bottom sheet
                    Navigator.pop(context);

                    if (message.pinned != null && message.pinned!) {
                      await APIService.prevUnpin(cont.user.id, message.sent);
                    } else {
                      String userData =
                          await APIService.getPinnedMessage(cont.user.id);
                      print(userData);
                      // final data = snapshot.data?.docs;
                      // final list = data
                      //     ?.map((e) => ChatUser.fromJson(e.data()))
                      //     .toList() ??
                      //     [];

                      APIService.pinMessage(
                          userData, user.id, message.sent, message);
                    }
                  }),

              _OptionItem(
                  icon: const Icon(CupertinoIcons.star,
                      color: Colors.white, size: 26),
                  name: message.starred != null && message.starred == 'true'
                      ? 'Unstar Message'
                      : 'Star Message',
                  onTap: () {
                    //for hiding bottom sheet
                    Navigator.pop(context);

                    if (message.starred != null && message.starred == 'true') {
                      APIService.unstarMessage(
                          user.id,
                          message.sent,
                          isMe ? "You" : user2Name,
                          isMe ? "" : fromPic,
                          !isMe ? "You" : user2Name);
                    } else {
                      APIService.starMessage(
                          user.id,
                          message.sent,
                          isMe ? "You" : user2Name,
                          isMe ? "" : fromPic,
                          !isMe ? "You" : user2Name);
                    }
                  }),

              // widget.message.type == Type.text
              //     ?
              //     //copy option
              //     _OptionItem(
              //         icon: const Icon(Icons.copy_all_rounded,
              //             color: Colors.blue, size: 26),
              //         name: 'Copy Text',
              //         onTap: () async {
              //           await Clipboard.setData(
              //                   ClipboardData(text: widget.message.msg))
              //               .then((value) {
              //             //for hiding bottom sheet
              //             Navigator.pop(context);
              //
              //             // Dialogs.showSnackbar(context, 'Text Copied!');
              //           });
              //         })
              //     :
              //     //save option
              //     // _OptionItem(
              //     //     icon: const Icon(Icons.download_rounded,
              //     //         color: Colors.blue, size: 26),
              //     //     name: 'Save Image',
              //     //     onTap: () async {
              //     //       try {
              //     //         log('Image Url: ${widget.message.msg}');
              //     //         await GallerySaver.saveImage(widget.message.msg,
              //     //             albumName: 'We Chat')
              //     //             .then((success) {
              //     //           //for hiding bottom sheet
              //     //           Navigator.pop(context);
              //     //           if (success != null && success) {
              //     //             Dialogs.showSnackbar(
              //     //                 context, 'Image Successfully Saved!');
              //     //           }
              //     //         });
              //     //       } catch (e) {
              //     //         log('ErrorWhileSavingImg: $e');
              //     //       }
              //     //     }),
              //
              //     const SizedBox(
              //         height: 1,
              //       ),
              //separator or divider

              // if (isMe)
              //   Divider(
              //     color: Colors.black54,
              //     endIndent: MediaQuery.of(context).size.width * .04,
              //     indent: MediaQuery.of(context).size.width * .04,
              //   ),

              //edit option
              if (message.type == Type.text && isMe)
                _OptionItem(
                    icon: const Icon(Icons.edit, color: Colors.white, size: 26),
                    name: 'Edit Message',
                    onTap: () {
                      //for hiding bottom sheet
                      Navigator.pop(context);

                      _showMessageUpdateDialog(message);
                    }),

              //delete option
              if (isMe)
                _OptionItem(
                    icon: const Icon(Icons.delete_forever,
                        color: Colors.red, size: 26),
                    name: 'Delete Message',
                    onTap: () async {
                      await APIService.deleteMessage(message).then((value) {
                        //for hiding bottom sheet
                        Navigator.pop(context);
                      });
                    }),

              //separator or divider
              Divider(
                color: Colors.grey,
                endIndent: MediaQuery.of(context).size.width * .04,
                indent: MediaQuery.of(context).size.width * .04,
              ),

              //sent time
              _OptionItem(
                  icon: const Icon(Icons.check, color: Colors.white),
                  name:
                      'Sent : ${MyDateUtil.getMessageTime(context: context, time: message.sent)}',
                  onTap: () {}),

              //read time
              _OptionItem(
                  icon: const Icon(Icons.done_all, color: Colors.green),
                  name: message.read.isEmpty
                      ? 'Read : Not seen yet'
                      : 'Read : ${MyDateUtil.getMessageTime(context: context, time: message.read)}',
                  onTap: () {}),
            ],
          );
        });
  }

  void _showMessageUpdateDialog(Message message) {
    String updatedMsg = message.msg;

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: Colors.black,
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Colors.white)),

              //title
              title: const Row(
                children: [
                  Icon(
                    Icons.message,
                    color: Colors.white,
                    size: 28,
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Text(
                    ' Edit Message',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),

              //content
              content: TextFormField(
                initialValue: updatedMsg,
                maxLines: null,
                onChanged: (value) => updatedMsg = value,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
                style: const TextStyle(color: Colors.white),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    )),

                //update button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                      APIService.updateMessage(message, updatedMsg);
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ))
              ],
            ));
  }

  void _onTextChanged() {
    // Check if the text field is empty
    if (cont.messageController.text.isEmpty) {
      APIService.updateTypingStatus(cont.user, false);
      cont.visible.value = true;
    } else {
      cont.visible.value = false;
      APIService.updateTypingStatus(cont.user, true);
      print("called");
    }
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      cont.offlineMessages.value = await retrieveMessages();
      setState(() {
        _isOffline = true;
        print('object${cont.offlineMessages.value[0].msg}');
      });
    }
  }

  Future<void> storeMessage(ChatUser user, List<Message> messages) async {
    List<MessageHive> hiveList =
        cont.list.value.map((message) => message.toHiveMessage()).toList();
    // var box = Hive.box('messages');
    var box = Hive.box<List<MessageHive>>('messages');
    await box.put(APIService.getConversationID(cont.user.id), hiveList);
  }

  Future<List<Message>> retrieveMessages() async {
    var box = Hive.box<List<MessageHive>>('messages');
    List<MessageHive>? hiveList =
        box.get(APIService.getConversationID(cont.user.id));

    if (hiveList != null) {
      return hiveList.map((hiveMessage) => hiveMessage.toMessage()).toList();
    } else {
      return [];
    }
  }

  Future<void> checkPermissions() async {
    if (await _hasAcceptedPermissions()) {}
  }

  Future<bool> _hasAcceptedPermissions() async {
    if (Platform.isAndroid) {
      // Android 13 permissions
      List<Permission> android13Permissions = [
        Permission.photos,
        Permission.videos,
        Permission.audio,
      ];
      // Permissions for earlier versions of Android
      List<Permission> legacyPermissions = [
        Permission.storage,
        Permission.accessMediaLocation,
        Permission.manageExternalStorage,
      ];

      bool android13OrHigher = await _isAndroid13OrHigher();

      return await _requestPermissions(
          android13OrHigher ? android13Permissions : legacyPermissions);
    } else if (Platform.isIOS) {
      return await _requestPermissions([Permission.photos]);
    }
    return false;
  }

  Future<bool> _isAndroid13OrHigher() async {
    final int sdkVersion = await _getAndroidSdkVersion();
    return sdkVersion >= 33; // Android 13 is SDK 33
  }

  Future<int> _getAndroidSdkVersion() async {
    if (!Platform.isAndroid) {
      return 0;
    }
    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      int sdkInt = androidInfo.version.sdkInt;
      return sdkInt;
    } catch (e) {
      return 0;
    }
  }

  Future<bool> _requestPermissions(List<Permission> permissions) async {
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    bool allGranted = statuses.values.every((status) => status.isGranted);

    if (!allGranted) {
      bool permanentlyDenied =
          statuses.values.any((status) => status.isPermanentlyDenied);
      if (permanentlyDenied) {
        // Show a dialog or redirect to app settings
        return _showPermissionDialog();
      }
    }
    return allGranted;
  }

  Future<bool> _showPermissionDialog() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Permissions Required'),
            content: const Text(
                'This app requires permissions to function properly. Please grant permissions from app settings.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  openAppSettings();
                  Navigator.of(context).pop(true);
                },
                child: Text('Open Settings'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

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
