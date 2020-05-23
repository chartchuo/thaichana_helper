import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thaichana_helper/model.dart';

import 'scanview.dart';
import 'webview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/scanview': (context) => ScanView(),
        "/webview": (context) => Web(),
      },
    );
  }
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget widget;
  SlideRightRoute({this.widget})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return new SlideTransition(
              position: new Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตัวช่วยไทยชนะ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ListTile(
              title: FlatButton(
                padding: EdgeInsets.all(16),
                onPressed: () async {
                  await Navigator.pushNamed(context, '/webview',
                      arguments: ScanedUrl(
                          'https://qr.thaichana.com/?appId=0001&shopId=S0000000003'));
                },
                child: Text("ลงทะเบียน และ ลองเช็คอิน/เช๊คเอาท์"),
                color: Colors.grey,
              ),
            ),
            ListTile(
              title: FlatButton(
                padding: EdgeInsets.all(16),
                onPressed: () async {
                  Map<PermissionGroup, PermissionStatus> permissions =
                      await PermissionHandler()
                          .requestPermissions([PermissionGroup.camera]);
                  if (permissions[PermissionGroup.camera] ==
                      PermissionStatus.granted) {
                    final result =
                        await Navigator.pushNamed(context, '/scanview');
                    if (result == null) return;
                    final uri = Uri.parse(result.toString());
                    if (uri.host == 'qr.thaichana.com') {
                      await Navigator.pushNamed(context, '/webview',
                          arguments: ScanedUrl(result.toString()));
                    }
                  }
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.photo_camera,
                      size: 100,
                    ),
                    Text('สแกน QR Code')
                  ],
                ),
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
