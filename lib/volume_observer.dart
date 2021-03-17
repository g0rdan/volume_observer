import 'dart:async';

import 'package:flutter/services.dart';

class VolumeObserver {
  static const EventChannel _volumeObserver =
      const EventChannel('com.g0rdan.volume_observer/volume_listener');
  final _streamController = StreamController<double>.broadcast();

  // singleton
  static VolumeObserver _instance;
  static VolumeObserver get instance => _instance ??= VolumeObserver._();
  VolumeObserver._() {
    _enableEventReceiver();
  }

  Stream<double> get volumeObserver => _streamController.stream;

  void _enableEventReceiver() {
    _volumeObserver.receiveBroadcastStream().listen(
      (dynamic event) {
        if (event is double) {
          print('[Volume Observer]: volume -> $event');
          _streamController.add(event);
        }
      },
      onError: (dynamic error) {
        print('[Volume Observer]: Received error -> ${error.message}');
      },
      cancelOnError: true,
    );
  }
}
