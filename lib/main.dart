import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaichana_helper/model.dart';

import 'scanview.dart';
import 'webview.dart';
import 'webview2.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/scanview': (context) => ScanView(),
        "/webviewAdv": (context) => WebviewAdv(),
        "/webviewNorm": (context) => WebviewNorm(),
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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool webviewAdv = false;
  String webviewRoute = '/webviewNorm';
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
              title: Column(
                children: <Widget>[
                  Text("ขั้นตอน"),
                  FlatButton(
                    padding: EdgeInsets.all(16),
                    onPressed: () async {
                      await Navigator.pushNamed(context, webviewRoute,
                          arguments: ScanedUrl(
                              'https://qr.thaichana.com/?appId=0001&shopId=S0000000003'));
                    },
                    child: Text(
                        "1.กดเพื่อลงทะเบียน(ครั้งแรก) และ ลองเช็คอิน/เช๊คเอาท์"),
                    color: Colors.grey,
                  ),
                ],
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
                      await Navigator.pushNamed(context, webviewRoute,
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
                    Text('2. กดเพื่อสแกน QR โค๊ดของร้านค้าที่เข้าใช้บริการ')
                  ],
                ),
                color: Colors.blue,
              ),
              subtitle: Text(
                  '*สำหรับบางคนที่พบปัญหา หลังการติดตั้งโปรแกรมครั้งแรกแล้วเครื่องแฮงค์ ให้ทำการปิดเครื่องมือถือแล้วเปิดขึ้นใหม่จะใช้งานได้ปกติ (ถ้าปิดเครื่องมือถือไม่ได้ ให้กดปุ่มลดเสียง+ปุ่มปิดเครื่องค้างไว้ 10 วินาที'),
            ),
            SwitchListTile(
              title: Text('web view ชั้นสูง'),
              value: webviewAdv,
              onChanged: (value) {
                _setAdvWebview(value);
                _savePreference();
              },
            ),
          ],
        ),
      ),
    );
  }

  initState() {
    super.initState();
    _loadPreference();
  }

  _setAdvWebview(bool value) {
    setState(() {
      webviewAdv = value;
      if (value)
        webviewRoute = '/webviewAdv';
      else
        webviewRoute = '/webviewNorm';
    });
  }

  _savePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('webviewAdv', webviewAdv);
  }

  _loadPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      _setAdvWebview(prefs.getBool('webviewAdv'));
    } catch (e) {
      setState(() {
        _setAdvWebview(false);
      });
    }
  }
}
