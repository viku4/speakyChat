import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:speaky_chat/model/chat_user.dart';

import '../chat/chat_detail/chat_detail_widget.dart';
import '../model/chat_model.dart';

class InviteContactCard extends StatelessWidget {
  const InviteContactCard({Key? key, this.contact}) : super(key: key);
  final ChatUser? contact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 17.0, right: 17.0),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 53,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 23,
                  backgroundColor: Colors.blueGrey[200],
                  child: SvgPicture.asset(
                    "assets/person.svg",
                    color: Colors.white,
                    height: 30,
                    width: 30,
                  ),
                ),
                // contact!.select!
                //     ? Positioned(
                //   bottom: 4,
                //   right: 5,
                //   child: CircleAvatar(
                //     backgroundColor: Colors.teal,
                //     radius: 11,
                //     child: Icon(
                //       Icons.check,
                //       color: Colors.white,
                //       size: 18,
                //     ),
                //   ),
                // )
                //     : Container(),
              ],
            ),
          ),
          SizedBox(width: 12,),
          Expanded(
            child: Text(
              contact!.name!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          // Expanded(child: SizedBox()),
          ElevatedButton(onPressed: (){}, child: Text('Invite'))
        ],
      ),
    );
  }
}
