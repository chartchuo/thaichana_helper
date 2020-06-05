import 'package:flutter/material.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:easy_web_view/easy_web_view.dart';
import 'model.dart';

class WebviewNorm extends StatefulWidget {
  @override
  _WebState createState() => _WebState();
}

class _WebState extends State<WebviewNorm> {
  @override
  Widget build(BuildContext context) {
    final ScanedUrl args = ModalRoute.of(context).settings.arguments;
    // return WebviewScaffold(
    //   appBar: AppBar(
    //     title: const Text('WebView'),
    //   ),
    //   url: args.url,
    // );
    return Scaffold(
      appBar: AppBar(title: const Text('Webview')),
      body: EasyWebView(
        src: args.url, onLoaded: () {},
        // isHtml: false, // Use Html syntax
        // isMarkdown: false, // Use markdown syntax
        // convertToWidets: false, // Try to convert to flutter widgets
        // width: 100,
        // height: 100,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
