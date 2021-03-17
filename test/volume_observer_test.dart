import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volume_observer/volume_observer.dart';

void main() {
  const MethodChannel channel = MethodChannel('volume_observer');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await VolumeObserver.platformVersion, '42');
  });
}
