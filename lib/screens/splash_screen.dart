import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speaky_chat/index.dart';
import 'package:speaky_chat/screens/user_page.dart';

import '../api/api_services.dart';
import '../home_page/home_page_widget.dart';
import '../onboarding/o_t_p_login/o_t_p_login_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences prefs;
  bool isConnected = false;

  navigate() async {
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    init();
  }

  @override
  void initState() {
    super.initState();

    navigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(child: SizedBox()),
            Image.asset(
              'assets/images/favicon.png',
              height: 100,
            ),
            const Expanded(child: SizedBox()),
            Column(
              children: [
                // Text('MapPal', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),),
                // SizedBox(height: 15,)
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> init() async {
    // Get.to(() => HomePageWidget());
    isConnected = await checkNetworkConnection();
    prefs = await _prefs;
    bool isTermsAccepted = prefs.getBool("isTermsAccepted") ?? false;
    bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
    // Navigator.push(context, MaterialPageRoute(builder: (context) => SelectUser()));

    if (isLoggedIn) {
      if (isConnected) {
        var response = await APIService.login(prefs.getString('mobile') ?? '');
        await APIService.getProfile(FirebaseAuth.instance.currentUser!.uid);
        await Future.delayed(const Duration(milliseconds: 2000), () {});
        if (response['token'] != null) {
          Get.off(() => HomePageWidget());
          // Navigator.push(context, MaterialPageRoute(builder: (context) => SelectUser()));
        } else {
          Fluttertoast.showToast(msg: "Session Expired, Login Again!");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => OTPLoginWidget()));
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 2000), () {});
        Get.off(() => HomePageWidget());
      }
      // Get.to(() => HomePageWidget());
    } else if (isTermsAccepted) {
      // Get.to(() => OTPLoginWidget());
      // Get.to(() => SignUpPage(uid: 'verId', phoneNumber: 'phoneNumber', phoneCode: 'phoneCode'));
      Get.to(() => const OTPLoginWidget());
      // Get.to(() => HomePageWidget());
    } else {
      Get.to(() => IntroPageWidget());
      // Get.to(() => HomePageWidget());
    }
  }

  Future<bool> checkNetworkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.none ? false : true;
  }
}
