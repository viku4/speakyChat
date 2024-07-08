import 'package:flutter/material.dart';

class ButtonCard extends StatelessWidget {
  const ButtonCard({Key? key, this.name, this.icon}) : super(key: key);
  final String? name;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 23,
        child: Icon(
          icon,
          size: 26,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      title: Text(
        name!,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),
      ),
    );
  }
}