<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages). 
-->

This is simple NTP server with offers offset feature. This may helped test system 
based on time.

## Features

Offset of time may be changed or UDP default server port.

## Getting started

Add library to your project by pub.dev.

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
  NTPServer srv = NTPServer(offset: Duration(seconds: 3600));
  srv.start(1234);
}
```

## Additional information

More ifno you can find in RFC5905 https://datatracker.ietf.org/doc/html/rfc5905

## License
License under MIT