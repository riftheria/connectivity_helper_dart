import 'package:connectivity_helper/connectivity_helper.dart';

void callback(bool isConnected) {
  print(isConnected ? "There is an active connection" : "You are not connectd");
}

void main() async {
  final helper = InternetConnectionHelper();
  bool thereIsAnActiveConnection = await helper.isConnectedToInternet();
  if (thereIsAnActiveConnection) {
    print('You are connected');
  } else {
    print('You are not connected');
  }
  helper.listen(callback);
}
