import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'scanview.dart';
import 'webview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
    // return MaterialApp(home: Web(initialUrl: 'https://google.com'));
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตัวช่วยไทยชนะ'),
      ),
      body: Center(
        child: FlatButton(
          onPressed: () async {
            Map<PermissionGroup, PermissionStatus> permissions =
                await PermissionHandler()
                    .requestPermissions([PermissionGroup.camera]);
            if (permissions[PermissionGroup.camera] ==
                PermissionStatus.granted) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ScanView()));
            }
          },
          child: Icon(
            Icons.photo_camera,
            size: 100,
          ),
          color: Colors.blue,
        ),
      ),
    );
  }
}
