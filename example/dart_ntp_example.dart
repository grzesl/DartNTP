import 'package:dart_ntp/dart_ntp.dart';

void main() {
  NTPServer srv = NTPServer();
  srv.start(port: 123, offset: Duration(seconds: 20));
}
