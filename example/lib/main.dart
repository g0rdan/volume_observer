import 'package:flutter/material.dart';
import 'dart:async';

// import 'package:flutter/services.dart';
import 'package:volume_observer/volume_observer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   platformVersion = await VolumeObserver.platformVersion;
    // } on PlatformException {
    //   platformVersion = 'Failed to get platform version.';
    // }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // setState(() {
    //   _platformVersion = platformVersion;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              // Text('Running on: $_platformVersion\n'),
              StreamBuilder(
                stream: VolumeObserver.instance.volumeObserver,
                builder: (context, data) {
                  if (data.hasData) {
                    final volume = data.data.toString();
                    return Text('$volume');
                  } else {
                    print('data.error: ${data.error}');
                    print('data.connectionState: ${data.connectionState}');
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
