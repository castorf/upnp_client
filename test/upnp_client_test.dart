import 'dart:io';

import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:upnp_client/src/discovery.dart';

class MockSocket extends Mock implements RawDatagramSocket {}

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  setUpAll(() {
    registerFallbackValue(InternetAddress.anyIPv4);
  });

  test('hello world!', () {
    expect(1 + 1, equals(2));
  });

  test('start', () async {
    final discoverer = DeviceDiscoverer();
    await discoverer.start();
    discoverer.stop();
  });

  test('add_device bad header', () async {
    final discoverer = DeviceDiscoverer();
    discoverer.addDevice(['blah', 'blah']);
  });

  /*
  [HTTP/1.1 200 OK, CACHE-CONTROL: max-age=1801, DATE: Fri, 10 Jan 2025 16:02:30 GMT, EXT:, LOCATION: http://192.168.1.99:49152/wps_device.xml, SERVER: Unspecified, UPnP/1.0, Unspecified, ST: urn:schemas-wifialliance-org:service:WFAWLANConfig:1, USN: uuid:8a27648a-3cae-771f-e954-78958b890ea0::urn:schemas-wifialliance-org:service:WFAWLANConfig:1, , ]
[HTTP/1.1 200 OK, CACHE-CONTROL: max-age=1801, DATE: Fri, 10 Jan 2025 16:02:30 GMT, EXT:, LOCATION: http://192.168.1.99:49152/wps_device.xml, SERVER: Unspecified, UPnP/1.0, Unspecified, ST: urn:schemas-wifialliance-org:service:WFAWLANConfig:1, USN: uuid:8a27648a-3cae-771f-e954-78958b890ea0::urn:schemas-wifialliance-org:service:WFAWLANConfig:1, , ]
[HTTP/1.1 200 OK, CACHE-CONTROL: max-age=1801, DATE: Fri, 10 Jan 2025 16:02:30 GMT, EXT:, LOCATION: http://192.168.1.99:49152/wps_device.xml, SERVER: Unspecified, UPnP/1.0, Unspecified, ST: urn:schemas-wifialliance-org:service:WFAWLANConfig:1, USN: uuid:8a27648a-3cae-771f-e954-78958b890ea0::urn:schemas-wifialliance-org:service:WFAWLANConfig:1, , ]
Error: HttpException: Connection closed before full header was received, uri = http://192.168.1.99:49153/wps_device.xml while trying to get device from http://1
*/

  test('add_device with location but invalid', () async {
    final discoverer = DeviceDiscoverer();
    discoverer.addDevice(['blah', 'LOCATION: http://192.168.1.121:5000/t.xml']);
    var devices = await discoverer.getDevices();
    expect(devices.length, equals(0));
  });
}
