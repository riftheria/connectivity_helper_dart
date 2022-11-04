import 'package:connectivity_helper/connectivity_helper.dart';

void main() async {
  final helper = InternetConnectionHelper();
  bool thereIsAnActiveConnection = await helper.isInternetConnected();
  if (thereIsAnActiveConnection) {
    print('You are connected');
  } else {
    print('You are not connected');
  }
}
