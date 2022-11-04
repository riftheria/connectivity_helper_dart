import 'dart:io';

import 'package:connectivity_helper/connectivity_helper.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  test('Test there is an active connection', () async {
    final client = MockHttpClient();
    when(() => client.get(any(), any(), any()))
        .thenAnswer((invocation) => Future(() => MockHttpClientRequest()));
    when(() => client.close())
        .thenAnswer((invocation) => Future(() => MockHttpClientResponse()));
    final helper = InternetConnectionHelper(client: client);
    expect(await helper.isConnectedToInternet(), true);
  });

  test('Test there is not an active connection', () async {
    final client = MockHttpClient();
    when(() => client.get(any(), any(), any())).thenThrow(SocketException(''));
    when(() => client.close())
        .thenAnswer((invocation) => Future(() => MockHttpClientResponse()));
    final helper = InternetConnectionHelper(client: client);
    final activeConnection = await helper.isConnectedToInternet();
    expect(activeConnection, false);
  });

  test('Test callback to listener', () async {
    final listener = MockListener();
    final client = MockHttpClient();
    when(() => client.get(any(), any(), any()))
        .thenAnswer((invocation) => Future(() => MockHttpClientRequest()));
    when(() => client.close())
        .thenAnswer((invocation) => Future(() => MockHttpClientResponse()));
    final helper = InternetConnectionHelper(client: client);
    helper.listen(listener.callback);
    await Future.delayed(Duration(seconds: 2));
    verify(() => listener.callback(any())).called(greaterThan(1));
  });

  test('Test listener could be manually stoped', () async {
    final listener = MockListener();
    final client = MockHttpClient();
    when(() => client.get(any(), any(), any()))
        .thenAnswer((invocation) => Future(() => MockHttpClientRequest()));
    when(() => client.close())
        .thenAnswer((invocation) => Future(() => MockHttpClientResponse()));
    final helper = InternetConnectionHelper(client: client);
    helper.listen(listener.callback);
    await Future.delayed(Duration(seconds: 2, milliseconds: 100));
    verify(() => listener.callback(any())).called(10);
    helper.stopListen();
    await Future.delayed(Duration(milliseconds: 500));
    verifyNever(() => listener.callback(any()));
  });
}

class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}

class MockListener extends Mock implements Listener {}

abstract class Listener {
  void callback(bool isConnected);
}
