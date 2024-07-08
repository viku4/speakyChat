import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speaky_chat/model/chat_model.dart';
import 'package:speaky_chat/model/chat_user.dart';
import 'package:speaky_chat/model/user_model.dart';
import '../model/message_model.dart';
import 'api_constants.dart';

class APIService {
  static var client = http.Client();
  static User user = FirebaseAuth.instance.currentUser!;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static final Connectivity _connectivity = Connectivity();

  static ChatUser me = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      phone: user.phoneNumber.toString(),
      about: "Hey, I'm using We Chat!",
      image: user.photoURL.toString(),
      createdAt: '',
      isOnline: false,
      lastActive: '',
      pushToken: '');

  // 1
  static Future<Map<String, dynamic>> login(String mobile) async {
    var url = '${APIConstants.BASE_URL}auth/userProfile/login';

    var data = {
      "mobilenumber": mobile,
    };

    // Fluttertoast.showToast(msg: mobile);

    var body = json.encode(data);

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json', // Set the proper content type
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print('Successfull');
      Map<String, dynamic> jsonMap = json.decode(response.body);
      String tokenValue = jsonMap['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(tokenValue);
      prefs.setString('token', tokenValue).then((value) => print(value));
      print(jsonMap);
      // if (jsonMap['payload']['message'] != "Invalid Credentials") {
      //   String tokenValue = jsonMap['payload']['userData']['token'];
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   print(tokenValue);
      //
      //   var sessionManager = SessionManager();
      //   print("user data is: ${jsonMap['payload']}");
      //   await sessionManager.set("userRole", jsonMap['payload']['usersRole'].toString());
      //
      //   prefs.setString('token', tokenValue).then((value) => print(value));
      //   prefs.setInt('employeeId', jsonMap['payload']['userData']['id']).then((
      //       value) => print(value));
      //   return jsonMap;
      // } else {
      //   return jsonMap;
      // }
      return jsonMap;
      // Extracting the value of the "token" key
    } else if (response.statusCode == 401) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      print('Response body: ${response.body}');
      return json.decode(response.body);
    }
  }

  // 2
  static Future<Map<String, dynamic>> signUp(
      String uid, String name, String imageUrl, String mobile) async {
    var url = '${APIConstants.BASE_URL}auth/userProfile/signup';

    var data = {
      "user_id": uid,
      "username": name,
      "mobilenumber": mobile,
      "profile_pic": imageUrl,
      "name": name,
      "status": "Available",
      "bio": "A passionate individual",
      "about": "Hey there!, I'm using SpeakyChat."
    };

    var body = json.encode(data);

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json', // Set the proper content type
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print('Successfull');
      Map<String, dynamic> jsonMap = json.decode(response.body);
      print(jsonMap);
      return jsonMap;
      // if (jsonMap['payload']['message'] != "Invalid Credentials") {
      //   String tokenValue = jsonMap['payload']['userData']['token'];
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   print(tokenValue);
      //
      //   var sessionManager = SessionManager();
      //   print("user data is: ${jsonMap['payload']}");
      //   await sessionManager.set("userRole", jsonMap['payload']['usersRole'].toString());
      //
      //   prefs.setString('token', tokenValue).then((value) => print(value));
      //   prefs.setInt('employeeId', jsonMap['payload']['userData']['id']).then((
      //       value) => print(value));
      //   return jsonMap;
      // } else {
      //   return jsonMap;
      // }
      // Extracting the value of the "token" key
    } else if (response.statusCode == 401) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      print('Response body: ${response.body}');
      return json.decode(response.body);
    }
  }

  // 3
  static Future<Map<String, dynamic>> getProfile(String uid) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var url = '${APIConstants.BASE_URL}/auth/userProfile/getProfile/$uid';

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'AUTHORIZATION': prefs.getString('token') ?? '',
      },
    );

    if (response.statusCode == 200) {
      print('Successfull');
      Map<String, dynamic> jsonMap = json.decode(response.body);
      print(jsonMap);
      var sessionManager = new SessionManager();
      sessionManager.set("uid", jsonMap['user_id']);
      sessionManager.set("username", jsonMap['username']);
      sessionManager.set("profile_pic", jsonMap['profile_pic']);
      sessionManager.set("mobilenumber", jsonMap['mobilenumber']);
      sessionManager.set("bio", jsonMap['bio']);
      sessionManager.set("status", jsonMap['status']);
      sessionManager.set("about", jsonMap['about']);

      return jsonMap;
      // if (jsonMap['payload']['message'] != "Invalid Credentials") {
      //   String tokenValue = jsonMap['payload']['userData']['token'];
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   print(tokenValue);
      //
      //   var sessionManager = SessionManager();
      //   print("user data is: ${jsonMap['payload']}");
      //   await sessionManager.set("userRole", jsonMap['payload']['usersRole'].toString());
      //
      //   prefs.setString('token', tokenValue).then((value) => print(value));
      //   prefs.setInt('employeeId', jsonMap['payload']['userData']['id']).then((
      //       value) => print(value));
      //   return jsonMap;
      // } else {
      //   return jsonMap;
      // }
      // Extracting the value of the "token" key
    } else if (response.statusCode == 401) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      print('Response body: ${response.body}');
      return json.decode(response.body);
    }
  }

  // 4
  static Future<Map<String, dynamic>> updateProfile(String uid, String name,
      String imageUrl, String mobile, String about) async {
    var url = '${APIConstants.BASE_URL}auth/userProfile/updateProfile/$uid';
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var data = {
      "user_id": uid,
      "username": name.replaceAll(" ", "_"),
      "mobilenumber": mobile,
      "profile_pic": imageUrl,
      "name": name,
      "status": "Available",
      "bio": "A passionate individual",
      "about": about
    };
    print(
        "$uid, ${name.replaceAll(" ", "_")}, \n$mobile, $imageUrl, $name, \nAvailable, A Passionate Individual, $about");

    var body = json.encode(data);

    var response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'AUTHORIZATION': prefs.getString('token') ?? '',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print('Successfull');
      Map<String, dynamic> jsonMap = json.decode(response.body);
      await getProfile(me.id);
      SessionManager sessionManager = SessionManager();
      final chatUser = ChatUser(
          id: user.uid,
          name: await sessionManager.get("username"),
          phone: user.phoneNumber.toString(),
          about: "Hey, I'm using SpeakyChat",
          image: await sessionManager.get("profile_pic"),
          createdAt: '',
          isOnline: true,
          lastActive: '',
          pushToken: '');

      await firestore
          .collection('users')
          .doc(user.uid)
          .update(chatUser.toJson());
      print(jsonMap);
      return jsonMap;
      // if (jsonMap['payload']['message'] != "Invalid Credentials") {
      //   String tokenValue = jsonMap['payload']['userData']['token'];
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   print(tokenValue);
      //
      //   var sessionManager = SessionManager();
      //   print("user data is: ${jsonMap['payload']}");
      //   await sessionManager.set("userRole", jsonMap['payload']['usersRole'].toString());
      //
      //   prefs.setString('token', tokenValue).then((value) => print(value));
      //   prefs.setInt('employeeId', jsonMap['payload']['userData']['id']).then((
      //       value) => print(value));
      //   return jsonMap;
      // } else {
      //   return jsonMap;
      // }
      // Extracting the value of the "token" key
    } else if (response.statusCode == 401) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      print('Response body: ${response.body}');
      return json.decode(response.body);
    }
  }

  // 5
  static Future<Map<String, dynamic>> getPrivacySettings() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var url =
        '${APIConstants.BASE_URL}/privacy/userPrivacy/getPrivacySettings/$uid';

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'AUTHORIZATION': prefs.getString('token') ?? '',
      },
    );

    if (response.statusCode == 200) {
      print('Successfull');
      Map<String, dynamic> jsonMap = json.decode(response.body);
      print(jsonMap);
      return jsonMap;
    } else if (response.statusCode == 401) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      print('Response body: ${response.body}');
      return json.decode(response.body);
    }
  }

  // 6
  static Future<Map<String, dynamic>> updatePrivacySettings(String lastSeen,
      String profilePic, String about, String status, int readReceipt) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var url =
        '${APIConstants.BASE_URL}privacy/userPrivacy/updatePrivacySettings/$uid';
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    var data = {
      "private_profile": true,
      "profile_pic_permission": profilePic,
      "about_permission": about,
      "status_permission": status,
      "read_receipt": readReceipt,
      "last_seen": lastSeen,
      "user_id": uid
    };

    var body = json.encode(data);

    var response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'AUTHORIZATION': prefs.getString('token') ?? '',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print('Successfull');
      Map<String, dynamic> jsonMap = json.decode(response.body);
      print(jsonMap);
      return jsonMap;
      // if (jsonMap['payload']['message'] != "Invalid Credentials") {
      //   String tokenValue = jsonMap['payload']['userData']['token'];
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   print(tokenValue);
      //
      //   var sessionManager = SessionManager();
      //   print("user data is: ${jsonMap['payload']}");
      //   await sessionManager.set("userRole", jsonMap['payload']['usersRole'].toString());
      //
      //   prefs.setString('token', tokenValue).then((value) => print(value));
      //   prefs.setInt('employeeId', jsonMap['payload']['userData']['id']).then((
      //       value) => print(value));
      //   return jsonMap;
      // } else {
      //   return jsonMap;
      // }
      // Extracting the value of the "token" key
    } else if (response.statusCode == 401) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      print('Response body: ${response.body}');
      return json.decode(response.body);
    }
  }

  // 7
  static Future<Map<String, dynamic>> getMobileUser(String mobile) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var url = '${APIConstants.BASE_URL}/auth/userProfile/getMobileUser/$mobile';

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'AUTHORIZATION': prefs.getString('token') ?? '',
      },
    );

    if (response.statusCode == 200) {
      print('Successfull');
      Map<String, dynamic> jsonMap = json.decode(response.body);
      print(jsonMap);
      return jsonMap;
    } else if (response.statusCode == 401) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      print('Response body: ${response.body}');
      return json.decode(response.body);
    }
  }

  // 8
  static Future<Map<String, dynamic>> getContacts(
      List<Map<String, String>> mobile) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var url = '${APIConstants.BASE_URL}/auth/userProfile/getContacts/';

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'AUTHORIZATION': prefs.getString('token') ?? '',
      },
      body: jsonEncode(<String, dynamic>{'mobileNumbers': mobile}),
    );

    if (response.statusCode == 200) {
      print('Successfull');
      Map<String, dynamic> jsonMap = json.decode(response.body);
      print(jsonMap);
      return jsonMap;
    } else if (response.statusCode == 401) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      print('Response body: ${response.body}');
      return json.decode(response.body);
    }
  }

  // 9
  static Future<bool> userExists(String targetId) async {
    return (await firestore.collection(user.uid).doc(user.uid).get()).exists;
  }

  // 10
  static Future<void> creareChatOnFirestore(
      String name, String icon, String currentMessage, String targetId) async {
    final chatUser = ChatModel(
        name: name,
        icon: icon,
        isGroup: false,
        time: DateTime.now().toString(),
        currentMessage: currentMessage,
        status: '',
        select: false,
        id: targetId);
    return await firestore
        .collection(user.uid)
        .doc(targetId)
        .set(chatUser.toJson());
  }

  // 11
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // 12
  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type, int time, RxList<Message> messages) async {
    //message sending time (also used as id)

    Future<void> sendMessageToFirestore() async {
      await firestore
          .collection('users')
          .doc(chatUser.id)
          .collection('my_users')
          .doc(user.uid)
          .update({'created_at': time.toString()});

      await firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_users')
          .doc(chatUser.id)
          .update({'created_at': time.toString()});

      final Message message = Message(
          toId: chatUser.id,
          msg: msg,
          read: '',
          delivered: '',
          type: type,
          fromId: user.uid,
          sent: '$time');

      final ref = firestore
          .collection('chats/${getConversationID(chatUser.id)}/messages/');

      // await ref.doc(time).set(message.toJson()).then((value) =>
      //     sendPushNotification(chatUser, type == Type.text ? msg : 'image'));

      await ref.doc('$time').set(message.toJson());
    }

    Future<void> handleConnectivity() async {
      ConnectivityResult connectivityResult =
          await _connectivity.checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {

        if(type == Type.text){
          messages.insert(
              0,
              Message(
                  toId: chatUser.id,
                  msg: msg,
                  read: '',
                  delivered: '',
                  type: type,
                  fromId: user.uid,
                  sent: '$time',
                  isLocal: true));
          
          print('object2 : ${messages[0].msg}');
        }
        StreamSubscription<ConnectivityResult>? subscription;
        subscription = _connectivity.onConnectivityChanged
            .listen((ConnectivityResult result) async {

          if (result != ConnectivityResult.none) {
            await sendMessageToFirestore();
            subscription?.cancel();
          }

        });
      } else {
        if(type == Type.text){
          messages.insert(
              0,
              Message(
                  toId: chatUser.id,
                  msg: msg,
                  read: '',
                  delivered: '',
                  type: type,
                  fromId: user.uid,
                  sent: '$time',
                  isLocal: true));
        }
        await sendMessageToFirestore();
      }
    }

    await handleConnectivity();
  }

  // 13
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // 14
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  // 15
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  // 16
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // 17
  static Future<void> deleteMessage(Message message) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .delete();

    if (message.type == Type.image) {
      // await storage.refFromURL(message.msg).delete();
    }
  }

  // 18
  static Future<void> updateMessage(Message message, String updatedMsg) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .update({'msg': updatedMsg});
  }

  // 19
  static Future<void> sendFirstMessage(
      ChatUser chatUser, String msg, Type type, RxList<Message> list) async {
    print(chatUser.id);
    // addChatUser(chatUser.phone);

    print(chatUser.toJson());
    int time = DateTime.now().millisecondsSinceEpoch;
    chatUser.createdAt = time.toString();
    print(chatUser.toJson());
    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .doc(chatUser.id)
        .set(chatUser.toJson());

    await getSelfInfo();
    await firestore
        .collection('users')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(user.uid)
        .set(ChatUser(
                image: me.image,
                about: '',
                name: '',
                createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
                isOnline: false,
                id: me.id,
                lastActive: '',
                phone: me.phone,
                pushToken: '')
            .toJson())
        .then((value) => sendMessage(chatUser, msg, type, time, list));

    await firestore.collection('users').doc(chatUser.id).set(chatUser.toJson());
  }

  // 20
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    return firestore
        .collection('users')
        .where('id',
            whereIn: userIds.isEmpty
                ? ['']
                : userIds) //because empty list throws an error
        // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // 21
  static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      //user exists

      firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});

      return true;
    } else {
      //user doesn't exists

      return false;
    }
  }

  // 22
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        // await getFirebaseMessagingToken();

        //for setting user status to active
        APIService.updateActiveStatus(true);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  // 23
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  // 24
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    var sessionManager = new SessionManager();
    final chatUser = ChatUser(
        id: user.uid,
        name: user.displayName.toString(),
        phone: user.phoneNumber.toString(),
        about: "Hey, I'm using SpeakyChat",
        image: await sessionManager.get("profile_pic"),
        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken: '');

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  // 25
  static Future<void> updateNameInFirestore(String id, String name) async {
    try {
      // Update the "name" field in the Firestore document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(me.id)
          .collection('my_users')
          .doc(id)
          .update({
        'name': name,
      });

      // Send the message after successful update (optional)
      print('Name updated and message sent successfully!');
    } catch (e) {
      print('Error updating name: $e');
      // Handle errors appropriately, e.g., show a user-friendly message
    }
  }

  // 26
  static Future<void> sendChatImage(
      ChatUser chatUser, File file, RxList<Message> list) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    int time = DateTime.now().millisecondsSinceEpoch;
    await saveFileToLocalStorage(file, time, list, chatUser, Type.image);
    //storage file ref with path
    final ref = storage
        .ref()
        .child('chatImages/${getConversationID(chatUser.id)}/$time.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      // log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image, time, list);
  }

  // 27
  static Future<void> sendChatDocument(ChatUser chatUser, File file,
      String name, String? ext, RxList<Message> list) async {
    //getting image file extension
    //storage file ref with path
    int time = DateTime.now().millisecondsSinceEpoch;
    await saveFileToLocalStorage(file, time, list, chatUser, Type.document);

    final ref = storage
        .ref()
        .child('chatDocuments/${getConversationID(chatUser.id)}/$time.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'application/$ext'))
        .then((p0) {
      // log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final documentUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, "${documentUrl}____$name", Type.document, time, list);
  }

  // 28
  static Future<File?> uploadMedia(
      ChatUser chatUser, String recordFilePath, RxList<Message> list) async {
    final file = File(recordFilePath);
    if (!await file.exists()) {
      throw Exception("File not found: $recordFilePath");
    }

    final ext = recordFilePath.split('.').last;

    print("ext is $ext $recordFilePath");
    int time = DateTime.now().millisecondsSinceEpoch;

    await saveFileToLocalStorage(file, time, list, chatUser, Type.audio);

    //storage file ref with path
    final ref = storage
        .ref()
        .child('voiceNoted/${getConversationID(chatUser.id)}/$time.$ext');

    //uploading image
    await ref
        .putFile(
            file,
            SettableMetadata(
                contentType: 'audio/$ext')) // Use 'audio/$ext' MIME type
        .whenComplete(() => null) // Ensure completion before next steps
        .then((p0) {
      // log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
      Get.snackbar("Uploaded!",
          "Audio file uploaded successfully."); // Use GetX for UI feedback
    }).catchError((error) {
      Get.snackbar("Error",
          "Failed to upload audio: ${error.toString()}"); // Handle errors with GetX
    });

    //updating image in firestore database
    final audioUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, audioUrl, Type.audio, time, list);
  }

  // 29
  static sendChatVideo(ChatUser chatUser, File file, File thumbnail, RxList<Message> list) async {
    //storage file ref with path
    int time = DateTime.now().millisecondsSinceEpoch;
    final refVideo = storage
        .ref()
        .child('chatVideos/${getConversationID(chatUser.id)}/$time.mp4');

    final refThumb = storage
        .ref()
        .child('chatVideoThumbs/${getConversationID(chatUser.id)}/$time.jpg');

    await saveFileToLocalStorage(file, time, list, chatUser, Type.video);

    //uploading image
    await refVideo
        .putFile(file, SettableMetadata(contentType: 'video/mp4'))
        .then((p0) {
      // log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    await refThumb
        .putFile(thumbnail, SettableMetadata(contentType: 'image/jpg'))
        .then((p0) {
      // log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating video in firestore database
    final videoUrl = await refVideo.getDownloadURL();
    final thumbUrl = await refThumb.getDownloadURL();
    // final msg = StcreateJson(thumbUrl, videoUrl);
    await sendMessage(
        chatUser, createJson(thumbUrl, videoUrl), Type.video, time, list);
  }

  // 30
  static String createJson(String value1, String value2) {
    // final data = {"thumb": value1, "video": value2};
    final data = '${value1}________$value2';
    // final jsonString = jsonEncode(data);
    return data;
  }

  // 31
  static Future<void> pinMessage(
      String prevPinned, String userId, String messageId, Message msg) async {
    String type = "";
    if (msg.type == Type.text) {
      type = "text";
    } else if (msg.type == Type.image) {
      type = "image";
    } else if (msg.type == Type.audio) {
      type = "audio";
    } else if (msg.type == Type.video) {
      type = "video";
    } else if (msg.type == Type.document) {
      type = "document";
    }

    // Map<String, dynamic> message = {
    //   "toId": msg.fromId,
    //   "msg": msg.msg,
    //   "sent": msg.sent,
    //   "fromId": user.uid,
    //   "type": type
    // };

    final database = FirebaseDatabase.instance;

    final chatId = firestore.collection('chats').doc(getConversationID(userId));

    final messageRef = chatId.collection('messages').doc(messageId);

    if (prevPinned != '') {
      prevUnpin(userId, prevPinned);
    }

    chatId.set({
      'toId': msg.toId,
      'msg': msg.msg,
      'sent': msg.sent,
      'fromId': msg.fromId,
      'type': type,
      'chatId': getConversationID(userId)
    });

    final messageDoc = await messageRef.get();

    if (messageDoc.exists) {
      final messageData = messageDoc.data() as Map<String, dynamic>;
      // Fluttertoast.showToast(msg: getConversationID(userId));
      // Add a 'starred' field to the message data
      messageData['pinned'] = true;
      await messageRef.update(messageData);
    }

    final reference = database.ref().child(
        'pinnedChats/${getConversationID(me.id == msg.fromId ? msg.toId : msg.fromId)}/');

    try {
      // await reference.set(message);
      // print(message);
      print('Data written successfully!');
    } catch (error) {
      print('Error writing data: $error');
    }
  }

  // 32
  static Stream<Object> listenForData(String userId) {
    // Fluttertoast.showToast(msg: getConversationID(userId));
    return firestore
        .collection('chats')
        .doc(getConversationID(userId))
        .snapshots();

    // return firestore
    //     .collection('chats')
    //     .where(getConversationID(userId))
    //     .snapshots();
    // final database = FirebaseDatabase.instance;
    // final reference = database
    //     .ref()
    //     .child('pinnedChats/${getConversationID(userId)}/');
    // try {
    //   final event = await reference.once();
    //   final snapshot = event.snapshot;
    //   if (snapshot.exists) {
    //     print("data is: " + snapshot.key!);
    //     return snapshot.value as Map<Object?, Object?>;
    //   } else {
    //     print('No data found at path: ');
    //     return {};
    //   }
    // } catch (error) {
    //   print('Error fetching data: $error');
    //   return {};
    // }
  }

  // 33
  static Future<void> starMessage(String userId, String messageId,
      String fromName, String fromPic, String toName) async {
    // Create a reference to the user's starred messages subcollection
    final starredRef =
        firestore.collection('users').doc(me.id).collection('starred_messages');

    // Get the message data
    final messageRef = firestore
        .collection('chats')
        .doc(getConversationID(userId))
        .collection('messages')
        .doc(messageId);

    print("check" + getConversationID(userId));
    final messageDoc = await messageRef.get();

    if (messageDoc.exists) {
      final messageData = messageDoc.data() as Map<String, dynamic>;

      // Add a 'starred' field to the message data
      messageData['starred'] = true;

      // Update the original message document
      await messageRef.update(messageData);

      messageData['fromName'] = fromName;
      messageData['toName'] = toName;
      if (fromName == "You") {
        var sessionManager = new SessionManager();
        messageData['fromPic'] = await sessionManager.get("profile_pic");
      } else {
        messageData['fromPic'] = fromPic;
      }
      // Create a document in the user's starred messages with the message data
      await starredRef.doc(messageId).set(messageData);
    } else {
      // Handle the case where the message doesn't exist
      print('Error: Message not found');
    }
  }

  // 34
  static Stream<List<Message>> getStarredMessages() {
    final userId = user.uid;
    return firestore
        .collection('users')
        .doc(me.id)
        .collection('starred_messages')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());
  }

  // 35
  static Future<void> unstarMessage(String userId, String messageId,
      String fromName, String fromPic, String toName) async {
    // Create a reference to the user's starred messages subcollection
    final starredRef =
        firestore.collection('users').doc(me.id).collection('starred_messages');

    // Get the message data
    final messageRef = firestore
        .collection('chats')
        .doc(getConversationID(userId))
        .collection('messages')
        .doc(messageId);

    print("check" + getConversationID(userId));
    final messageDoc = await messageRef.get();

    if (messageDoc.exists) {
      final messageData = messageDoc.data() as Map<String, dynamic>;

      // Add a 'starred' field to the message data
      messageData['starred'] = false;

      // Update the original message document
      await messageRef.update(messageData);
      // Create a document in the user's starred messages with the message data
      // await starredRef.doc(messageId).set(messageData);
      await starredRef.doc(messageId).delete();
    } else {
      // Handle the case where the message doesn't exist
      print('Error: Message not found');
    }
  }

  // 36
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser user) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: user.id)
        .snapshots();
  }

  // 37
  static Future<void> prevUnpin(String userId, String prevPinned) async {
    final messageRef = firestore
        .collection('chats')
        .doc(getConversationID(userId))
        .collection('messages')
        .doc(prevPinned);

    firestore.collection('chats').doc(getConversationID(userId)).delete();

    final messageDoc = await messageRef.get();

    if (messageDoc.exists) {
      final messageData = messageDoc.data() as Map<String, dynamic>;
      // Fluttertoast.showToast(msg: getConversationID(userId));
      // Add a 'starred' field to the message data
      messageData['pinned'] = false;
      await messageRef.update(messageData);
    }
  }

  // 38
  static Future<String> getPinnedMessage(String userId) async {
    DocumentSnapshot snapshot = await firestore
        .collection('chats')
        .doc(getConversationID(userId))
        .get();

    // Check if the document exists
    if (snapshot.exists) {
      // Access the data in the document
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      // Access the specific value you need
      dynamic value = data['sent'];

      // Do something with the value
      print('Retrieved value from Firestore: $value');
      return value ?? '';
    } else {
      print('Document does not exist');
      return '';
    }
  }

  // 39
  static Future<void> updateMessageDeliveryStatus(Message message) async {
    // Fluttertoast.showToast(msg: 'msg');
    CollectionReference messagesRef = firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/');

    // Query for messages where fromId is "abc" and delivered is empty
    // QuerySnapshot<Map<String, dynamic>> snapshot = await messagesRef
    //     .where(message.fromId, isNotEqualTo: user.uid)
    //     .where('delivered', isEqualTo: '')
    //     .get();

    QuerySnapshot<Object?> snapshot = await messagesRef
        .where('fromId', isNotEqualTo: user.uid)
        .where('delivered', isEqualTo: '')
        .get();
    // Create a batched write operation
    // Iterate over the documents in the snapshot and update the delivered field
    for (QueryDocumentSnapshot<Object?> doc in snapshot.docs) {
      await doc.reference.update(
          {'delivered': DateTime.now().millisecondsSinceEpoch.toString()});
    }

    // firestore
    //     .collection('chats/${getConversationID(message.fromId)}/messages/')
    //     .doc(message.sent)
    //     .update({'delivered': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // 40
  static Future<void> updateTypingStatus(
      ChatUser chatUser, bool isTyping) async {
    print(getConversationID(chatUser.id));
    await firestore
        .collection('chats/${getConversationID(chatUser.id)}/activity')
        .doc(me.id)
        .set({
      'is_typing': isTyping,
      'id': me.id,
    });
  }

  // 41
  static Stream<QuerySnapshot<Map<String, dynamic>>> getTyping(
      ChatUser chatUser) {
    print(getConversationID(chatUser.id));
    return firestore
        .collection('chats/${getConversationID(chatUser.id)}/activity')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  // 42
  static Future<void> sendFirstDocument(ChatUser chatUser, File file,
      String name, String? ext, RxList<Message> list) async {
    print(chatUser.id);
    // addChatUser(chatUser.phone);

    print(chatUser.toJson());
    chatUser.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
    print(chatUser.toJson());
    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .doc(chatUser.id)
        .set(chatUser.toJson());

    // Fluttertoast.showToast(msg: 'msg');

    await getSelfInfo();
    await firestore
        .collection('users')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(user.uid)
        .set(ChatUser(
                image: me.image,
                about: '',
                name: '',
                createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
                isOnline: false,
                id: me.id,
                lastActive: '',
                phone: me.phone,
                pushToken: '')
            .toJson())
        .then((value) => sendChatDocument(chatUser, file, name, ext, list));

    await firestore.collection('users').doc(chatUser.id).set(chatUser.toJson());
  }

  // 43
  static Future<void> sendFirstChatImage(
      ChatUser chatUser, File pickedMediaFile, RxList<Message> list) async {
    print(chatUser.id);
    // addChatUser(chatUser.phone);

    print(chatUser.toJson());
    chatUser.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
    print(chatUser.toJson());
    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .doc(chatUser.id)
        .set(chatUser.toJson());

    await getSelfInfo();
    await firestore
        .collection('users')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(user.uid)
        .set(ChatUser(
                image: me.image,
                about: '',
                name: '',
                createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
                isOnline: false,
                id: me.id,
                lastActive: '',
                phone: me.phone,
                pushToken: '')
            .toJson())
        .then((value) => sendChatImage(chatUser, pickedMediaFile, list));

    await firestore.collection('users').doc(chatUser.id).set(chatUser.toJson());
  }

  // 44
  static Future<void> sendFirstChatVideo(
      ChatUser chatUser, File pickedMediaFile, File thumbnail, RxList<Message> list) async {
    chatUser.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
    print(chatUser.toJson());
    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .doc(chatUser.id)
        .set(chatUser.toJson());

    await getSelfInfo();
    await firestore
        .collection('users')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(user.uid)
        .set(ChatUser(
                image: me.image,
                about: '',
                name: '',
                createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
                isOnline: false,
                id: me.id,
                lastActive: '',
                phone: me.phone,
                pushToken: '')
            .toJson())
        .then((value) => sendChatVideo(chatUser, pickedMediaFile, thumbnail, list));

    await firestore.collection('users').doc(chatUser.id).set(chatUser.toJson());
  }

  // 45
  static Future<String> getProfilePic(String uid) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      return userDoc['image'];
    }
    return '';
  }

  // 46
  static void setProfilePic(String imageUrl) async {
    SessionManager sessionManager = SessionManager();
    final chatUser = ChatUser(
        id: user.uid,
        name: await sessionManager.get("username"),
        phone: user.phoneNumber.toString(),
        about: "Hey, I'm using SpeakyChat",
        image: imageUrl,
        createdAt: '',
        isOnline: true,
        lastActive: '',
        pushToken: '');

    await firestore.collection('users').doc(user.uid).update(chatUser.toJson());
  }

  // 47
  static Future<void> uploadFirstMedia(
      ChatUser chatUser, String recordFilePath, RxList<Message> list) async {
    chatUser.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
    print(chatUser.toJson());
    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .doc(chatUser.id)
        .set(chatUser.toJson());

    await getSelfInfo();
    await firestore
        .collection('users')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(user.uid)
        .set(ChatUser(
                image: me.image,
                about: '',
                name: '',
                createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
                isOnline: false,
                id: me.id,
                lastActive: '',
                phone: me.phone,
                pushToken: '')
            .toJson())
        .then((value) => uploadMedia(chatUser, recordFilePath, list));

    await firestore.collection('users').doc(chatUser.id).set(chatUser.toJson());
  }

  static Future<void> saveFileToLocalStorage(File file, int time,
      List<Message> messages, ChatUser chatUser, Type type) async {
    try {
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw FileSystemException(
            'Could not access external storage directory.');
      }

      final path =
          '${directory.parent.parent.parent.parent.path}/SpeakyChat/Media/SpeakyChat ${type.toString().substring(5).capitalizeFirst}s/Sent';
      await Directory(path).create(recursive: true);

      final File nomediaFile = File('$path/.nomedia');
      if (!(await nomediaFile.exists())) {
        await nomediaFile.create();
      }

      if (type == Type.image) {
        await file.copy('$path/SpeakyChatIMG-$time-${me.id}.jpg');
        messages.insert(
            0,
            Message(
                toId: chatUser.id,
                msg: 'msg',
                read: '',
                delivered: '',
                type: type,
                fromId: user.uid,
                sent: '$time',
                isLocal: true));
      }else if (type == Type.audio) {
        String ext = file.path.split('/').last.split('.').last;
        await file.copy('$path/SpeakyChatAUD-$time-${me.id}.$ext');
        messages.insert(
            0,
            Message(
                toId: chatUser.id,
                msg: 'msg____${file.path.split('/').last}',
                read: '',
                delivered: '',
                type: type,
                fromId: user.uid,
                sent: '$time',
                isLocal: true));
      } else if (type == Type.document) {
        await file.copy('$path/${file.path.split('/').last}');
        messages.insert(
            0,
            Message(
                toId: chatUser.id,
                msg: 'msg____${file.path.split('/').last}',
                read: '',
                delivered: '',
                type: type,
                fromId: user.uid,
                sent: '$time',
                isLocal: true));
      } else if (type == Type.video) {
        await file.copy('$path/SpeakyChatVID-$time-${me.id}.${file.path.split('.').last}');
        messages.insert(
            0,
            Message(
                toId: chatUser.id,
                msg: 'msg',
                read: '',
                delivered: '',
                type: type,
                fromId: user.uid,
                sent: '$time',
                isLocal: true));
      }

      // Print debug information
      print('File saved successfully: ${file.path}');
      print('Messages after insertion: ${messages.length} messages');
    } catch (e) {
      print('Error saving file: $e');
    }
  }
}
