import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'qr_reader.dart';

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
        headerWidget: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
    );
  }

  Future onScan(String data) async {
    var uri= Uri.parse(data);
    if(uri.host!='qr.thaichana.com'){
      _key.currentState.startScan();
      return;
    }
    Navigator.pop(context,data);
    // Navigator.push(context,
    //     MaterialPageRoute(builder: (context) => Web(initialUrl: data)));
    // await showCupertinoDialog(
    //   context: context,
    //   builder: (context) {
    //     return CupertinoAlertDialog(
    //       title: Text("ผลการสแกนรหัส"),
    //       content: Text(data),
    //       actions: <Widget>[
    //         CupertinoDialogAction(
    //           child: Text("ยืนยัน"),
    //           onPressed: () {
    //             Navigator.push(context,MaterialPageRoute(builder: (context) => Web(initialUrl:data)));

    //             },
    //         )
    //       ],
    //     );
    //   },
    // );
    // _key.currentState.startScan();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
