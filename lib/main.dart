import 'package:flutter/material.dart';

import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:permission_handler/permission_handler.dart';

import 'scanview.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  QrReaderViewController _controller;
  // bool isOk = false;
  String data;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตัวช่วยไทยชนะ'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(child: FlatButton(
              onPressed: () async {
                Map<PermissionGroup, PermissionStatus> permissions =
                    await PermissionHandler()
                        .requestPermissions([PermissionGroup.camera]);
                // print(permissions);
                if (permissions[PermissionGroup.camera] ==
                    PermissionStatus.granted) {
                      Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ScanView()));
                }
              },
              // child: Text("สแกน"),
              child: Icon(Icons.camera_enhance),
              color: Colors.blue,
            ),),
            
          ],
        ),
      ),
    );
  }

  void onScan(String v, List<Offset> offsets) {
    // print([v, offsets]);
    setState(() {
      data = v;
    });
    _controller.stopCamera();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
