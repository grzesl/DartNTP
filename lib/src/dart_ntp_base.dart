import 'dart:async';
import 'dart:io';
import 'dart:core';

import 'package:dart_ntp/src/dart_ntp_message.dart';

class NTPServer {
  final DateTime datetimeEpoch = DateTime.utc(1900, 1, 1, 0, 0, 0);
  StreamController<int> controller = StreamController<int>();
  late Stream<int> stream;
  int _numberOfCalls = 0;
  RawDatagramSocket? _socket;
  bool isRunning = false;

  NTPServer() {
    stream = controller.stream;
  }

  int dateTimeToNTP(
    DateTime datetimeNow, {
    offset = const Duration(seconds: 0),
  }) {
    Duration timeDiff = datetimeNow.difference(datetimeEpoch);
    int timeS = (timeDiff.inSeconds + offset.inSeconds).toInt();
    return timeS;
  }

  int dateTimeToNTPFrac(DateTime datetimeNow) {
    int timeUsec = datetimeNow.millisecond * 1000 + datetimeNow.microsecond;
    double timeFrac = ((timeUsec + 1) * (1 << 32) * 1.0e-6);
    return timeFrac.toInt();
  }

  void stop() {
    isRunning = false;
    if (_socket != null) {
      _socket!.close();
    }
    _numberOfCalls = 0;
    controller.sink.add(_numberOfCalls);
  }

  bool isRun() {
    return isRunning;
  }

  void start({
    int port = 123,
    Duration offset = const Duration(seconds: 0),
  }) async {
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
        ntpResp.transmitTimestamp = dateTimeToNTP(now, offset: offset);
        ntpResp.transmitTimestampFrac = dateTimeToNTPFrac(now);

        _numberOfCalls++;
        controller.sink.add(_numberOfCalls);

        socket.send(ntpResp.toList(), d.address, d.port);
      });

      _socket = socket;
      isRunning = true;
      _numberOfCalls = 0;
      controller.sink.add(_numberOfCalls);
    });
  }
}
