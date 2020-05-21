import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_qr_reader/qrcode_reader_view.dart';
import 'webview.dart';

class ScanView extends StatefulWidget {
  
  ScanView({Key key}) : super(key: key);

  @override
  _ScanViewState createState() => new _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  GlobalKey<QrcodeReaderViewState> _key = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: QrcodeReaderView(
        key: _key,
        onScan: onScan,
        helpWidget: Text("กรุณาส่องรหัส QR ให้อยู่ในกรอบ"),
        headerWidget: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
    );
  }

  Future onScan(String data) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("ผลการสแกนรหัส"),
          content: Text(data),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("ยืนยัน"),
              onPressed: () {
                print('goto web');
                Navigator.push(context,MaterialPageRoute(builder: (context) => Web(initialUrl:data)));
                
                // Navigator.pop(context);
                },
            )
          ],
        );
      },
    );
    // _key.currentState.startScan();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
