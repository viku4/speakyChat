import 'package:flutter/material.dart';
import 'package:speaky_chat/main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:speaky_chat/widgets/color_const.dart';

void showLoading() {
  showDialog(
      context: MyApp.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Container(
          color: white.withOpacity(0.4),
          child: SpinKitCircle(
            color: Colors.blue,
          ),
        );
      });
}
