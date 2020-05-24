import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'model.dart';

class WebviewNorm extends StatefulWidget {
  @override
  _WebState createState() => _WebState();
}

class _WebState extends State<WebviewNorm> {
  @override
  Widget build(BuildContext context) {
    final ScanedUrl args = ModalRoute.of(context).settings.arguments;
    return WebviewScaffold(
      appBar: AppBar(
        title: const Text('WebView'),
      ),
      url: args.url,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
