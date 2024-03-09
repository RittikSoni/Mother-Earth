import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityServices {
  factory ConnectivityServices() {
    return _customConnectivityServices;
  }
  ConnectivityServices._internal();
  static final ConnectivityServices _customConnectivityServices =
      ConnectivityServices._internal();

// #############################################################################

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
