import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:speaky_chat/model/user_model.dart';

class ContactsReposity {
  final FirebaseFirestore firestore;

  ContactsReposity({required this.firestore});

  Future<List<List>> getAllContacts() async{
    List<UserModel> firebaseContacts = [];
    List<UserModel> phoneContacts = [];

    // try{
    //   if(await FlutterContacts.requestPermission()){
    //     final userCollection = await firestore.collection('users').get();
    //     final allContactsInPhone = await FlutterContacts.getContacts(withProperties: true);
    //
    //     bool isContactFound = false;
    //
    //     for(var contact in allContactsInPhone){
    //       for(var firebaseContactData in userCollection.docs){
    //         var firebaseContact = UserModel.fromMap(firebaseContactData.data());
    //         if(contact.phones[0].number.replaceAll(' ', '') == firebaseContact.phoneNumber){
    //           firebaseContacts.add(firebaseContact);
    //           isContactFound = true;
    //           break;
    //         }
    //       }
    //       if(!isContactFound){
    //         phoneContacts.add(UserModel(username: contact.displayName, uid: '', profileImageUrl: '', active: false, lastSeen: 0, phoneNumber: contact.phones[0].number.replaceAll(' ', ''), groupId: []));
    //       }
    //       isContactFound = false;
    //     }
    //   }
    // }
    return [];
  }
}