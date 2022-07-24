import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:quiz_waker/src/core/network/network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker internetConnectionChecker;

  NetworkInfoImpl({required this.internetConnectionChecker});

  @override
  Future<bool> isConnected() async {
    return internetConnectionChecker.hasConnection;
  }
}
