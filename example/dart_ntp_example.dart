import 'dart:ffi';
import 'dart:typed_data';

import 'package:dart_ntp/dart_ntp.dart';
import 'package:dart_ntp/src/dart_ntp_message.dart';

void main() {
  NTPServer srv = NTPServer(offset: Duration(seconds: 3600));
  srv.start();
}
