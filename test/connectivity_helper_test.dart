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
    expect(await helper.isInternetConnected(), true);
  });

  test('Test there is not an active connection', () async {
    final client = MockHttpClient();
    when(() => client.get(any(), any(), any())).thenThrow(SocketException(''));
    when(() => client.close())
        .thenAnswer((invocation) => Future(() => MockHttpClientResponse()));
    final helper = InternetConnectionHelper(client: client);
    final activeConnection = await helper.isInternetConnected();
    expect(activeConnection, false);
  });
}

class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}
