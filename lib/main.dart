import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaichana_helper/model.dart';
import 'package:package_info/package_info.dart';

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
  PackageInfo packageInfo;
  bool webviewAdv = false;
  String webviewRoute = '/webviewNorm';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สแกนไทยชนะ'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Center(
                child: Image(image: AssetImage('assets/icon/icon.png')),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            SwitchListTile(
              title: Text('การใช้งานขั้นสูง'),
              value: webviewAdv,
              onChanged: (value) {
                _setAdvWebview(value);
                _savePreference();
              },
            ),
            ListTile(
              title: Text('เกียวกับสแกนไทยชนะ'),
              onTap: () {
                showDialog(context: context, builder: aboutBuilder);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
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
                    Text('กดเพื่อสแกน QR โค๊ดของร้านค้าที่เข้าใช้บริการ')
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

  initState() {
    super.initState();
    _getPackageInfo();
    _loadPreference();
  }

  _getPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
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

  Widget aboutBuilder(BuildContext context) {
    return AlertDialog(
      title: Text('เกี่ยวกับ สแกนไทยชนะ'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            ListTile(
              title: Text('Version ' + packageInfo.version),
              subtitle: Text('Build ' + packageInfo.buildNumber),
            ),
            ListTile(
              title: Text(
                  'ตัวช่วยสแกน สำหรับ check in และ check out ไทยชนะ QR code'),
            ),
            ListTile(
              subtitle: Text('  - รวดเร็ว ลดขั้นตอนการ check in / check out'),
            ),
            ListTile(
              subtitle: Text(
                  '  - เพิ่มความเป็นส่วนตัว เพราะมี browser ในตัว แยกจาก browser ที่เราใช้งานประจำ ไม่ต้องห่วงว่าข้อมูล cookie ส่วนตัวจะรั่วไหล'),
            ),
            ListTile(
              subtitle: Text(
                  '  - ปลอดภัยเพราะ เป็น opensource สามารถตรวจสอบ ได้ถึง source code ของตัวโปรแกรมได้ที่ https://github.com/chartchuo/thaichana_helper'),
            ),
          ],
        ),
      ),
      actions: [
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
