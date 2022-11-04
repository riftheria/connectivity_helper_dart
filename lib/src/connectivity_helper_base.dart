import 'dart:io';

class InternetConnectionHelper {
  final HttpClient _client;
  InternetConnectionHelper({HttpClient? client})
      : _client = client ?? HttpClient();

  Future<bool> isInternetConnected() async {
    bool isConnected = true;
    try {
      await _client.get('www.exaple.com', 80, '');
    } on SocketException {
      isConnected = false;
    } finally {
      _client.close();
    }
    return isConnected;
  }
}
