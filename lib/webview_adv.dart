import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'model.dart';

class WebviewAdv extends StatefulWidget {
  @override
  _WebState createState() => _WebState();
}

class _WebState extends State<WebviewAdv> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  WebMenu webMenu;
  @override
  Widget build(BuildContext context) {
    webMenu = WebMenu(_controller.future);
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView'),
        actions: <Widget>[
          NavigationControls(_controller.future),
          webMenu,
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        final ScanedUrl args = ModalRoute.of(context).settings.arguments;
        return WebView(
          initialUrl: args.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          javascriptChannels: <JavascriptChannel>[
            _toasterJavascriptChannel(context),
          ].toSet(),
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              print('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
        );
      }),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}

enum MenuOptions {
  listCookies,
  clearCookies,
  listCache,
  clearCache,
}

class WebMenu extends StatelessWidget {
  WebMenu(this.controller);

  final Future<WebViewController> controller;
  final CookieManager cookieManager = CookieManager();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: controller,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        return PopupMenuButton<MenuOptions>(
          onSelected: (MenuOptions value) {
            switch (value) {
              case MenuOptions.listCookies:
                listCookies(controller.data, context);
                break;
              case MenuOptions.clearCookies:
                clearCookies(context);
                break;
              case MenuOptions.listCache:
                listCache(controller.data, context);
                break;
              case MenuOptions.clearCache:
                clearCache(controller.data, context);
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.listCookies,
              child: Text('แสดงคุ้กกี้'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.clearCookies,
              child: Text('ลบคุ้กกี้'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.listCache,
              child: Text('แสดงข้อมูล'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.clearCache,
              child: Text('ลบข้อมูล'),
            ),
          ],
        );
      },
    );
  }

  void listCookies(WebViewController controller, BuildContext context) async {
    final String cookies =
        await controller.evaluateJavascript('document.cookie');
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Cookies:'),
          _getCookieList(cookies),
        ],
      ),
    ));
  }

  void listCache(WebViewController controller, BuildContext context) async {
    await controller.evaluateJavascript('caches.keys()'
        '.then((cacheKeys) => JSON.stringify({"cacheKeys" : cacheKeys, "localStorage" : localStorage}))'
        '.then((caches) => Toaster.postMessage(caches))');
  }

  void clearCache(WebViewController controller, BuildContext context) async {
    await controller.clearCache();
    Scaffold.of(context).showSnackBar(const SnackBar(
      content: Text("ลบข้อมูลในเครื่องเรียบร้อย"),
    ));
  }

  void clearCookies(BuildContext context) async {
    final bool hadCookies = await cookieManager.clearCookies();
    String message = 'ทำการลบคุ้กกี้เรียบร้อย!';
    if (!hadCookies) {
      message = 'ไม่พบคุ้กกี้';
    }
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  Widget _getCookieList(String cookies) {
    if (cookies == null || cookies == '""') {
      return Container();
    }
    final List<String> cookieList = cookies.split(';');
    final Iterable<Text> cookieWidgets =
        cookieList.map((String cookie) => Text(cookie));
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: cookieWidgets.toList(),
    );
  }
}

void _myClearCookies(BuildContext context) async {
  final bool hadCookies = await CookieManager().clearCookies();
  String message = 'ทำการลบคุ้กกี้เรียบร้อย!';
  if (!hadCookies) {
    message = 'ไม่พบคุ้กกี้';
  }
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: !webViewReady
                  ? null
                  : () {
                      _myClearCookies(context);
                    },
            ),
          ],
        );
      },
    );
  }
}
