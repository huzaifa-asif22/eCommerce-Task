import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/di/injection.dart';

part 'profile_provider.g.dart';

@riverpod
Future<Map<String, String>> deviceInfo(DeviceInfoRef ref) async {
  final deviceInfoChannel = ref.read(deviceInfoChannelProvider);
  try {
    return await deviceInfoChannel.getDeviceInfo();
  } catch (e) {
    // Return mock data if platform channel fails (e.g., on non-iOS platforms)
    return {
      'Device Model': 'Unknown',
      'System Version': 'Unknown',
      'Platform': 'Flutter',
    };
  }
}
