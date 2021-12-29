import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class InAppWebViewExampleScreen extends StatefulWidget {
  InAppWebViewExampleScreen({this.url});
  final String url;

  @override
  _InAppWebViewExampleScreenState createState() =>
      new _InAppWebViewExampleScreenState();
}

class _InAppWebViewExampleScreenState extends State<InAppWebViewExampleScreen> {
  InAppWebViewController webView;
  ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  bool isloading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
            body: SafeArea(
                child: Column(children: <Widget>[
          isloading
              ? Container(
                  padding: EdgeInsets.all(5.0),
                  child: progress < 1.0
                      ? LinearProgressIndicator(value: progress)
                      : Container())
              : Container(),
          Expanded(
            child: InAppWebView(
                contextMenu: contextMenu,
                initialUrl: widget.url,
                initialHeaders: {},
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    debuggingEnabled: true,
                    useShouldOverrideUrlLoading: true,
                  ),
                ),
                onWebViewCreated: (InAppWebViewController controller) {
                  webView = controller;
                  print("onWebViewCreated");
                },
                onLoadStart: (InAppWebViewController controller, String url) {
                  print("onLoadStart $url");
                  setState(() {
                    this.url = url;
                  });
                },
                shouldOverrideUrlLoading:
                    (controller, shouldOverrideUrlLoadingRequest) async {
                  var url = shouldOverrideUrlLoadingRequest.url;
                  var uri = Uri.parse(url);

                  if (![
                    "http",
                    "https",
                    "file",
                    "chrome",
                    "data",
                    "javascript",
                    "about"
                  ].contains(uri.scheme)) {
                    if (await canLaunch(url)) {
                      // Launch the App
                      await launch(
                        url,
                      );
                      // and cancel the request
                      return ShouldOverrideUrlLoadingAction.CANCEL;
                    }
                  }

                  return ShouldOverrideUrlLoadingAction.ALLOW;
                },
                onLoadStop:
                    (InAppWebViewController controller, String url) async {
                  print("onLoadStop $url");
                  setState(() {
                    this.url = url;
                  });
                },
                onProgressChanged:
                    (InAppWebViewController controller, int progress) {
                  setState(() {
                    this.progress = progress / 100;
                    isloading = false;
                  });
                },
                onUpdateVisitedHistory: (InAppWebViewController controller,
                    String url, bool androidIsReload) {
                  print("onUpdateVisitedHistory $url");
                  setState(() {
                    this.url = url;
                  });
                }),
          ),
        ]))));
  }
}
