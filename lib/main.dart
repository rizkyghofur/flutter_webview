import 'package:flutter/material.dart';
import 'package:flutter_webview/inapp_webview.dart';
import 'constant.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InAppWebViewExampleScreen(
        url: Constants.url,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
