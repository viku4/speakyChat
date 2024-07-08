import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkCheck {
  Stream<ConnectivityResult> get connectionStream => Connectivity().onConnectivityChanged;

  Future<bool> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi;
  }
}