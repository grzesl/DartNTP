
This is simple NTP server with offset feature. This may helped test system based on NTP time.

## Features

Offset of time may be changed or UDP default server port.

## Getting started

Add library to your project : 

https://pub.dev/packages/dart_ntp

## Usage

Using the server with default settings (UDP port 123 and 0 sec. offset):

```dart
void main() {
  NTPServer srv = NTPServer();
  srv.start();
}
```

Using the server with nondefault 1234 UDP port and 1h offset (3600 in seconds):

```dart
void main() {
  NTPServer srv = NTPServer();
  srv.start(port:1234, offset: Duration(seconds: 3600));
}
```

## Additional information

More informations you can find in RFC5905 https://datatracker.ietf.org/doc/html/rfc5905

## License
License under MIT