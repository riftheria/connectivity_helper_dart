import 'dart:async';
import 'dart:io';

class InternetConnectionHelper {
  final HttpClient _client;
  Timer? timer;
  InternetConnectionHelper({HttpClient? client})
      : _client = client ?? HttpClient();

  Future<bool> isConnectedToInternet() async {
    bool isConnected = true;
    try {
      await _client.get('www.exaple.com', 80, '');
    } on SocketException {
      isConnected = false;
    }
    return isConnected;
  }

  void listen(Function(bool isConnected) callback) {
    timer = Timer.periodic(Duration(milliseconds: 200), (timer) async {
      bool connected = await isConnectedToInternet();
      callback(connected);
    });
  }

  void stopListen() {
    if (timer != null) {
      timer?.cancel();
      timer = null;
    }
  }
}
