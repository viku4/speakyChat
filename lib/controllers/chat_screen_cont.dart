
import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrue/gotrue.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:record_mp3/record_mp3.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:speaky_chat/model/chat_user.dart';

import '../api/api_services.dart';
import '../model/message_model.dart';
import '../providers/chats_provider.dart';

class ChatScreenController extends GetxController{

  // IO.Socket? socket;
  var chatId = ''.obs;
  var nickname = ''.obs;
  var sourceChat = ''.obs;
  var profilePic = ''.obs;
  var visible = true.obs;
  var isRecording = false.obs;
  var isImageSelected = false.obs, isImageFetched = false.obs;
  late ChatUser user;
  var recordFilePath = ''.obs;
  var isSearching = false.obs;
  var pinLoaded = false.obs;
  late var sentImage;
  var list = <Message>[].obs;
  // List<Message> list = [];
  var offlineMessages = <Message>[].obs;
  var record = AudioRecorder();

  Timer? _timer;
  var _currentTime = 0.obs; // Stores elapsed time in seconds

  final Rx<Directory?> _applicationDirectory = Rx<Directory?>(null);
  Directory? get applicationDirectory => _applicationDirectory.value;

  String get formattedTime {
    int minutes = _currentTime ~/ 60;
    int seconds = _currentTime.value % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  void startTimer() {
    _currentTime.value = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _currentTime++;
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  ImagePicker imagePicker = new ImagePicker();
  late XFile pickedFile;
  File? image;

  ScrollController scrollController = ScrollController();

  DateTime? inchatTime;

  final messageController = TextEditingController();
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  final messageFocusNode = FocusNode();


  final scaffoldKey = GlobalKey<ScaffoldState>();

  var isTyping = false.obs;
  var isInProgress = false.obs;
  var isLoaded = false.obs;

  var question = ''.obs;

  // late ChatProvider chatProvider;

  @override
  void onInit() {
    super.onInit();
    if(Get.arguments != null){
      user = Get.arguments[0];
      profilePic.value = Get.arguments[1];
      nickname.value = user.name;
      if(nickname.value==''){
        nickname.value = user.phone;
      }
      if(Get.arguments.length > 2){
        sentImage.value = Get.arguments[2];
      }
      // sourceChat.value = Get.arguments[2];
      // chatId.value = Get.arguments[3];
      // socket = Get.arguments[4];
      // inchatTime = DateTime.now();

    }

    // connect();
    // chatProvider = Get.put(ChatProvider());
  }




  Future<void> sendMessage(String message, String sourceId, String targetId) async {
    // socket!.emit("message",
    //     {"message": message, "sourceId": sourceId, "targetId": targetId});
    print(targetId);
    await APIService.creareChatOnFirestore(nickname.value, profilePic.value, message, targetId).then((value) => null);}

  Future<String> getRecordingFile() async {
    final file =await getTempFile('${generateRandomHexString()}.mp3');
    return file.path;
  }

  Future<Directory?> getApplicationDirectory() async {
    if (_applicationDirectory.value != null) return _applicationDirectory.value;
    final dir = await getApplicationDocumentsDirectory();
    _applicationDirectory.value = dir;
    update(); // Notify listeners
    return dir;
  }

  Future<File> getTempFile(String fileName) async {
    final dir = await getTemporaryDirectory();
    return File('${dir.path}/$fileName');
  }

  String generateRandomHexString({int length = 6}) {
    final _hexChars = '0123456789ABCDEF';
    final StringBuffer result = StringBuffer();
    for (int i = 0; i < length; i++) {
      final char = _hexChars[Random().nextInt(_hexChars.length)];
      result.write(char);
    }
    return result.toString();
  }

  Future<void> startRecording() async {
    recordFilePath.value = await getRecordingFile();
    RecordMp3.instance.start(recordFilePath.value, (type) {});
    // record.start(const RecordConfig(encoder: AudioEncoder.pcm16bits), path: recordFilePath.value);
    // record.start(const RecordConfig(encoder: AudioEncoder.pcm16bits), path: recordFilePath.value);
    startTimer();
    isRecording.value = true;
  }

  Future<void> stopRecording(bool bool) async {
    isRecording.value = false;
    stopTimer();
    RecordMp3.instance.stop();
    // await record.stop();
    if(bool){
      File? uploadedAudio = await APIService.uploadMedia(user, recordFilePath.value, list);
      // if(uploadedAudio!=null){
      //
      // }
    }
  }

  Future<void> checkPermission() async {
    final status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      startRecording();
    } else if (status == PermissionStatus.permanentlyDenied) {
      openAppSettings(); // Open app settings for permission management
    } else {
      // Handle other permission status (denied, etc.)
      Get.snackbar("Permission Denied", "Microphone access is required for recording.");
    }
  }


// void connect() {
  //   socket!.on("messages", (msg) {
  //     print(msg);
  //     setMessage("destination", msg["message"]);
  //     scrollController.animateTo(scrollController.position.maxScrollExtent,
  //         duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  //   });
  // }
  //
  // void setMessage(String type, message) {
  //   MessageModel messageModel = MessageModel(
  //       type: type,
  //       message: message,
  //       time: DateTime.now().toString().substring(10, 16));
  //   chatProvider.addRemoteMessage(message: messageModel);
  // }
}