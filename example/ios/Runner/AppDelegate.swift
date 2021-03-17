import UIKit
import Flutter

import Foundation
import AVFoundation

private struct ObservationKeys {
    static let VolumeKey = "outputVolume"
    static let ChannelName = "com.g0rdan.volume_observer/volume_listener"
    static var Context = 0
}


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    let audioSession = AVAudioSession.sharedInstance()
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    guard let controller = window?.rootViewController as? FlutterViewController else {
        fatalError("rootViewController is not type FlutterViewController")
    }
    
    let eventChannel = FlutterEventChannel(name: ObservationKeys.ChannelName, binaryMessenger: controller.binaryMessenger)
    eventChannel.setStreamHandler(self)
    
    do {
        try audioSession.setActive(true)
    } catch {
        print("[Volume Observer]: Failed to activate audio session")
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        startObservingVolumeChanges()
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self)
        eventSink = nil
        return nil
    }
    
    func startObservingVolumeChanges() {
        audioSession.addObserver(self, forKeyPath: ObservationKeys.VolumeKey, options: [.initial, .new], context: &ObservationKeys.Context)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &ObservationKeys.Context {
            if keyPath == ObservationKeys.VolumeKey, let volume = (change?[NSKeyValueChangeKey(rawValue: NSKeyValueChangeKey.newKey.rawValue)] as? NSNumber)?.floatValue {
                print("[Volume Observer]: volume - \(volume)")
                eventSink!(volume)
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}
