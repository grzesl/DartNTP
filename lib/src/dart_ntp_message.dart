//source: rfc2030
//source: Simple Network Time Protocol (SNTP) Version 4 for IPv4, IPv6 and OSI
/*
                           1                   2                   3
       0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
      |LI | VN  |Mode |    Stratum    |     Poll      |   Precision   |
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
      |                          Root Delay                           |
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
      |                       Root Dispersion                         |
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
      |                     Reference Identifier                      |
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
      |                                                               |
      |                   Reference Timestamp (64)                    |
      |                                                               |
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
      |                                                               |
      |                   Originate Timestamp (64)                    |
      |                                                               |
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
      |                                                               |
      |                    Receive Timestamp (64)                     |
      |                                                               |
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
      |                                                               |
      |                    Transmit Timestamp (64)                    |
      |                                                               |
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
      |                 Key Identifier (optional) (32)                |
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
      |                                                               |
      |                                                               |
      |                 Message Digest (optional) (128)               |
      |                                                               |
      |                                                               |
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
*/

import 'dart:ffi' show Int32, Int8, Struct;
import 'dart:typed_data';

final class NTPMessage extends Struct {
  @Int8()
  external int header;
  @Int8()
  external int stratum;
  @Int8()
  external int poll;
  @Int8()
  external int precision;
  @Int32()
  external int rootDelay;
  @Int32()
  external int rootDispersion;
  @Int32()
  external int referenceIdentifier;
  @Int32()
  external int referenceTimestamp;
  @Int32()
  external int referenceTimestampFrac;
  @Int32()
  external int originateTimestamp;
  @Int32()
  external int originateTimestampFrac;
  @Int32()
  external int reciveTimestamp;
  @Int32()
  external int reciveTimestampFrac;
  @Int32()
  external int transmitTimestamp;
  @Int32()
  external int transmitTimestampFrac;
  // @Int32()
  // external int keyIdentifier;
  // @Int64()
  // external int messageDigestLow;
  // @Int64()
  // external int messageDigestHi;

  factory NTPMessage.fromTypedData(TypedData typedData) {
    return Struct.create(typedData);
  }

  factory NTPMessage(int lv, int vn, int mode) {
    return Struct.create()
      ..header = (lv & 0x03) << 5 | (vn & 0x7) << 3 | (mode & 0x7);
  }

  Uint8List toList() {
    ByteData data = ByteData(48);
    data.setInt8(0, header); //1
    data.setInt8(1, stratum); //2
    data.setInt8(2, poll); //3
    data.setInt8(3, precision); //4
    data.setInt32(4, rootDelay); //5
    data.setInt32(8, rootDispersion); //6
    data.setInt32(12, referenceIdentifier); //7
    data.setInt32(16, referenceTimestamp, Endian.little); //8
    data.setInt32(20, referenceTimestampFrac, Endian.little); //8
    data.setInt32(24, originateTimestamp, Endian.little); //9
    data.setInt32(28, originateTimestampFrac, Endian.little); //9
    data.setInt32(32, reciveTimestamp); //10
    data.setInt32(36, reciveTimestampFrac); //10
    data.setInt32(40, transmitTimestamp); //11
    data.setInt32(44, transmitTimestampFrac); //11
    // data.setInt32(40, keyIdentifier); //12
    // data.setInt32(44, messageDigestLow); //13
    // data.setInt32(52, messageDigestHi); //14
    Uint8List bytes = Uint8List(48);

    for (int i = 0; i < data.lengthInBytes; i++) {
      bytes[i] = data.getUint8(i);
    }
    return bytes;
  }
}
