import 'package:dart_ntp/dart_ntp.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final srv = NTPServer();

    srv.start();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      //expect(srv, isTrue);
    });
  });
}
