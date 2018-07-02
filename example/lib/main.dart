import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_content_share/flutter_content_share.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: RepaintBoundary(
        key: globalKey,
        child: new Scaffold(
            appBar: new AppBar(
              title: const Text('Plugin example app'),
              actions: <Widget>[
                IconButton(icon: Icon(Icons.share), onPressed: shareAll)
              ],
            ),
            body: ListView(
              children: <Widget>[
                ListTile(
                  title: Text("分享纯文字"),
                  onTap: shareText,
                ),
                ListTile(
                  title: Text("分享纯图片"),
                  onTap: shareImage,
                ),
                ListTile(
                  title: Text("分享链接"),
                  onTap: shareUrl,
                ),
                ListTile(
                  title: Text("全部分享"),
                  onTap: shareAll,
                )
              ],
            )),
      ),
    );
  }

  shareText() {
    FlutterContentShare.share("你好啊", null, null);
  }

  shareImage() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();

    var image = await boundary.toImage();

    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);

    var pngBytes = byteData.buffer.asUint8List();

    FlutterContentShare.share(null, pngBytes, null);
  }

  shareUrl() {
    FlutterContentShare.share(null, null, "https://www.baidu.com");
  }

  shareAll() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();

    var image = await boundary.toImage();

    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);

    var pngBytes = byteData.buffer.asUint8List();

    FlutterContentShare.share("标题", pngBytes, "https://www.baidu.com");
  }
}
