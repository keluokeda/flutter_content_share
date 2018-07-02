import 'dart:async';

import 'package:flutter/services.dart';
import 'dart:typed_data';

class FlutterContentShare {
  static const MethodChannel _channel =
      const MethodChannel('github.com/keluokeda/flutter_content_share');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static share(String text, Uint8List image, String url) {
    _channel
        .invokeMethod("share", {"text": text, "image": image, "url": url});
  }
}
