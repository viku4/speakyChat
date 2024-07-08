import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speaky_chat/contact/invite_contact_card.dart';

import '../../api/api_services.dart';
import '../../auth/supabase_auth/auth_util.dart';
import '../../backend/supabase/database/tables/a_users_info.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../model/chat_model.dart';
import '../../model/chat_user.dart';
import '../../screens/settings.dart';
import '../button_card.dart';
import '../contact_card.dart';

class ContactsPage extends StatefulWidget {
  ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var isLoading = true;
  List<ChatUser> speakyContacts = [];
  List<ChatUser> notOnSpeakyContacts = [];

  @override
  void initState() {
    super.initState();
    _requestContactsPermission();
    // checkContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  Get.back();
                },
                child: Icon(
                  Icons.chevron_left,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 28.0,
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Contact',
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Outfit',
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                  ),
                  Text(
                    '${speakyContacts.length} Contacts',
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Outfit',
                          color: Colors.grey,
                          fontSize: 14.0,
                        ),
                  ),
                ],
              ),
              Expanded(child: SizedBox()),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator())
                      : SizedBox(),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 0.0),
                    child: Icon(
                      Icons.search_outlined,
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      size: 26.0,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.bottomSheet(
                        _buildBottomSheet(),
                        backgroundColor: Colors.transparent,
                      );
                    },
                    child: Stack(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      children: [
                        Icon(
                          Icons.hexagon_outlined,
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          size: 24.0,
                        ),
                        FaIcon(
                          FontAwesomeIcons.circle,
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          size: 8.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: ListView.builder(
            itemCount: speakyContacts.length + notOnSpeakyContacts.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  padding: EdgeInsets.only(top: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      border: Border(
                          bottom: BorderSide.none,
                          top: BorderSide(color: Colors.white))),
                );
              } else if (index == 1) {
                return ButtonCard(
                  icon: Icons.person_add,
                  name: "New contact",
                );
              } else if (index > 1 && index < speakyContacts.length + 2) {
                return ContactCard(user: speakyContacts[index-2]);
              } else {
                return InviteContactCard(
                  contact: notOnSpeakyContacts[index - 2],
                );
              }
            }));
  }

  Widget _buildBottomSheet() {
    return Container(
      decoration: BoxDecoration(
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
            padding: EdgeInsets.only(top: 20, bottom: 20),
            width: double.infinity,
            decoration: BoxDecoration(
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
          _buildBottomSheetButton('Invite a friend'),
          _buildBottomSheetButton('Contacts'),
          _buildBottomSheetButton('Refresh'),
          _buildBottomSheetButton('Help'),
        ],
      ),
    );
  }

  Widget _buildBottomSheetButton(String text) {
    return InkWell(
      child: Container(
          height: 46,
          child: Column(
            children: [
              Text(
                text,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 5,
              ),
              Divider()
            ],
          )),
      onTap: () {
        // Handle button tap
        if (text == "SETTINGS") {
          Get.to(() => SettingsPage(
                profile_pic: '',
              ));
        } else {
          Get.back(); // Close the bottom sheet
        }
      },
    );
  }

  Future<void> checkContacts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // var response = await APIService.getMobileUser('+918949783483');

    List<Contact> phoneContacts =
        await ContactsService.getContacts(withThumbnails: false);
    print(phoneContacts.length);

    List<Map<String, String>> mobileNumbers = [];

    for (Contact contact in phoneContacts) {
      String contactName = contact.displayName ?? 'Unknown'; // Get contact name
      String phoneNumber;

      if (contact.phones!.isEmpty) {
        // Handle case when contact has no phone numbers
        phoneNumber = '';
      } else if (contact.phones!.length > 1) {
        // If a contact has more than one number, handle it differently
        phoneNumber = contact.phones!.first.value!.contains('+91') ||
                contact.phones!.first.value!.contains('+44')
            ? contact.phones!.first.value!.replaceAll(RegExp(r'[^\d]'), '')
            : '+91${contact.phones!.first.value!.replaceAll(RegExp(r'[^\d]'), '')}';
      } else {
        // If a contact has only one number, add it to the list
        phoneNumber = contact.phones![0].value!.contains('+91') ||
                contact.phones![0].value!.contains('+44')
            ? contact.phones![0].value!.replaceAll(RegExp(r'[^\d]'), '')
            : '+91${contact.phones![0].value!.replaceAll(RegExp(r'[^\d]'), '')}';
      }

      if (phoneNumber.startsWith('+910')) {
        phoneNumber = phoneNumber.replaceFirst('+910', '+91');
      }

      if (!phoneNumber.startsWith('+')) {
        phoneNumber = '+$phoneNumber';
      }

      // Store contact name and phone number
      mobileNumbers.add({'name': contactName, 'phone': phoneNumber});
      // print(mobileNumbers);
    }

    Map<String, dynamic>? contactsResponse = await getStoredContacts();

    if (contactsResponse == null) {
      print('No stored data found. Fetching from API...');
      try {
        contactsResponse = await APIService.getContacts(mobileNumbers);
        String responseString = jsonEncode(contactsResponse);
        await prefs.setString('contacts_response', responseString);
        // await storeContactsResponse(contactsResponse);
        print('Data fetched from API and stored locally.');
      } catch (error) {
        print('Error fetching data from API: $error');
      }
    } else {
      print('Stored data found. Using local data.');
      contactsResponse = await APIService.getContacts(mobileNumbers);
      String responseString = jsonEncode(contactsResponse);
      await prefs.setString('contacts_response', responseString);
    }

    // var response =

    // print(response);
    // print(response['foundContacts']);
    // print(response['notFoundContacts']);

    List<dynamic> foundContacts = contactsResponse?['foundContacts'];
    List<dynamic> notFoundContacts = contactsResponse?['notFoundContacts'];
    // print(foundContacts);
    // print(notFoundContacts);

    for (Map<String, dynamic> contact in foundContacts) {
      // speakyContacts.add(ChatModel(
      //   name: contact['name'],
      //   status: contact['userData']['bio'],
      //   id: contact['userData']['user_id'],
      //   icon: contact['userData']['profile_pic'],
      // ));
      speakyContacts.add(ChatUser(
          image: contact['userData']['profile_pic'],
          about: contact['userData']['bio'],
          name: contact['name'],
          createdAt: '',
          isOnline: false,
          id: contact['userData']['user_id'],
          lastActive: '',
          phone: contact['mobileNumber'],
          pushToken: ''));
      if (speakyContacts.length == foundContacts.length) {
        // print(speakyContacts[5].id);
        setState(() {
          if (notOnSpeakyContacts.length == notFoundContacts.length) {
            isLoading = false;
          }
        });
      }
    }

    int excludedContacts = 0;
    for (Map<String, dynamic> phoneContact in notFoundContacts) {
      if (phoneContact['name'] != 'Unknown') {
        // notOnSpeakyContacts.add(ChatModel(
        //   name: phoneContact['name'],
        // ));
        notOnSpeakyContacts.add(ChatUser(
            image: '',
            about: '',
            name: phoneContact['name'],
            createdAt: '',
            isOnline: false,
            id: '',
            lastActive: '',
            phone: phoneContact['mobileNumber'],
            pushToken: ''));
      } else {
        excludedContacts++;
      }
      if (notOnSpeakyContacts.length + excludedContacts ==
          notFoundContacts.length) {
        setState(() {
          if (speakyContacts.length == foundContacts.length) {
            isLoading = false;
          }
        });
      }
    }

    int totalContacts = phoneContacts.length;
    // print(response);
    // for (Contact contact in contacts) {
    //   if (contact.phones!.isNotEmpty) {
    //     print(contact.phones![0].value!);
    //     if (!contact.phones![0].value!.contains('+91')) {
    //       contact.phones![0].value = '+91${contact.phones![0].value!}';
    //     }
    //     var response = await APIService.getMobileUser(
    //         contact.phones![0].value!.replaceAll(' ', '').replaceAll('-', ''));
    //     // if(response['error'] ){
    //     //
    //     // }
    //     if (response['error'] != 'User not found for the given mobile number') {
    //       speakyContacts.add(ChatModel(
    //           name: contact.displayName,
    //           status: response['bio'],
    //           id: response['user_id'],
    //           icon: response['profile_pic']));
    //       setState(() {});
    //     }
    //   }
    //   if (contacts[totalContacts - 1] == contact) {
    //     setState(() {
    //       isLoading = false;
    //     });
    //   }
    //   // if (response) {
    //   //   // Store the contact in Flutter (e.g., using a database or shared preferences)
    //   //   // Example:
    //   //   // await storeContact(contact);
    //   //   print('Contact stored: $contact');
    //   // }
    // }
  }

  Future<void> _requestContactsPermission() async {
    if (await Permission.contacts.request().isGranted) {
      checkContacts();
    } else {
      // Handle permission denied
      // For simplicity, you can display an error message
      print('Permission denied');
    }
  }

  Future<String?> _getContactName(
      Contact contact, List<Contact> phoneContacts) async {
    // Assuming contact.phones is a list of phone numbers for a contact
    String? contactNumber =
        contact.phones!.isNotEmpty ? contact.phones!.first.value : '';

    // Search for contact name using contact number
    Contact matchedContact = phoneContacts
        .firstWhere((c) => c.phones!.any((p) => p.value == contactNumber));

    return matchedContact.displayName;
  }

  Future<Map<String, dynamic>?> getStoredContacts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? responseString = prefs.getString('contacts_response');
    if (responseString != null) {
      return jsonDecode(responseString);
    }
    return null;
  }
}
