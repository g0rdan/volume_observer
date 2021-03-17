package com.g0rdan.volume_observer_example

import android.media.AudioManager
import android.os.Handler
import android.view.KeyEvent
import androidx.annotation.NonNull
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity() {
    private lateinit var channel: EventChannel
    var eventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        channel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, "com.g0rdan.volume_observer/volume_listener")
        channel.setStreamHandler(
                object : EventChannel.StreamHandler {
                    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                        eventSink = events
                        Log.d("[Volume Observer]", "EventChannel onListen called")
                    }

                    override fun onCancel(arguments: Any?) {
                        Log.w("[Volume Observer]", "EventChannel onCancel called")
                    }
                })
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        if (keyCode == KeyEvent.KEYCODE_VOLUME_DOWN) {
            val am = getSystemService(AUDIO_SERVICE) as AudioManager
            am.adjustStreamVolume(AudioManager.STREAM_MUSIC, AudioManager.ADJUST_LOWER, AudioManager.FLAG_SHOW_UI)
            val volumeLevel = am.getStreamVolume(AudioManager.STREAM_MUSIC)
            val maxVolumeLevel: Int = am.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
            val volumePercent = volumeLevel.toFloat() / maxVolumeLevel
            eventSink?.success(volumePercent)
        }
        if (keyCode == KeyEvent.KEYCODE_VOLUME_UP) {
            val am = getSystemService(AUDIO_SERVICE) as AudioManager
            am.adjustStreamVolume(AudioManager.STREAM_MUSIC, AudioManager.ADJUST_RAISE, AudioManager.FLAG_SHOW_UI);
            val volumeLevel = am.getStreamVolume(AudioManager.STREAM_MUSIC)
            val maxVolumeLevel: Int = am.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
            val volumePercent = volumeLevel.toFloat() / maxVolumeLevel
            eventSink?.success(volumePercent)
        }
        return super.onKeyDown(keyCode, event);
    }
}
