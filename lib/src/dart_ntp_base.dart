import 'dart:io';
import 'dart:math';
import 'dart:core';

import 'package:dart_ntp/src/dart_ntp_message.dart';

class NTPServer {
  final Duration offset;
  final DateTime datetime_epoch = DateTime.utc(1900, 1, 1, 0, 0, 0);

  NTPServer({this.offset = const Duration(seconds: 0)});

  int dateTimeToNTP(DateTime datetimeNow) {
    Duration time_diff = datetimeNow.difference(datetime_epoch);
    int timeS = time_diff.inSeconds + offset.inSeconds;
    return timeS;
  }

  int dateTimeToNTPFrac(DateTime datetimeNow) {
    int timeUsec = datetimeNow.millisecond * 1000 + datetimeNow.microsecond;
    double timeFrac = ((timeUsec + 1) * (1 << 32) * 1.0e-6);
    return timeFrac.toInt();
  }

  void start({int port = 123}) async {
    RawDatagramSocket.bind(InternetAddress.anyIPv4, port).then((
      RawDatagramSocket socket,
    ) {
      socket.listen((RawSocketEvent e) {
        DateTime datetimeRecive = DateTime.now();
        Datagram? d = socket.receive();
        if (d == null) return;
        NTPMessage message = NTPMessage.fromTypedData(d.data);

        NTPMessage ntpResp = NTPMessage(1, 3, 4);
        ntpResp.stratum = 1;
        ntpResp.poll = 0;
        ntpResp.precision = -10;
        ntpResp.rootDelay = 0;
        ntpResp.rootDispersion = 0;
        ntpResp.referenceIdentifier = 0;
        ntpResp.referenceTimestamp = message.referenceTimestamp;

        ntpResp.originateTimestamp = message.transmitTimestamp;
        ntpResp.originateTimestampFrac = message.transmitTimestampFrac;

        ntpResp.reciveTimestamp = dateTimeToNTP(datetimeRecive);
        ntpResp.reciveTimestampFrac = dateTimeToNTPFrac(datetimeRecive);

        DateTime now = DateTime.now();
        ntpResp.transmitTimestamp = dateTimeToNTP(now);
        ntpResp.transmitTimestampFrac = dateTimeToNTPFrac(now);

        socket.send(ntpResp.toList(), d.address, d.port);
      });
    });
  }
}
