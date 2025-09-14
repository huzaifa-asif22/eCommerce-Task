import 'package:flutter/services.dart';

class DeviceInfoChannel {
  static const MethodChannel _channel = MethodChannel('device_info');

  Future<Map<String, String>> getDeviceInfo() async {
    try {
      final result = await _channel.invokeMethod<Map>('getDeviceInfo');
      return Map<String, String>.from(result ?? {});
    } on PlatformException catch (e) {
      throw Exception('Failed to get device info: ${e.message}');
    }
  }
}
