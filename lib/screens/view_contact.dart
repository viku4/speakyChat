import 'package:flutter/material.dart';

class ViewContactScreen extends StatelessWidget {
  final String personName;
  final String personPhoneNumber;

  ViewContactScreen({
    required this.personName,
    required this.personPhoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('View Contact', style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(
              Icons.person,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              personName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold, color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              personPhoneNumber,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18, color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     // Add contact functionality
            //     // Implement your logic here
            //   },
            //   child: Text('Add Contact'),
            // ),
          ],
        ),
      ),
    );
  }
}