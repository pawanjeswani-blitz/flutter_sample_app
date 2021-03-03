import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class SaloonWalaPrivacy extends StatefulWidget {
  @override
  _SaloonWalaPrivacyState createState() => _SaloonWalaPrivacyState();
}

class _SaloonWalaPrivacyState extends State<SaloonWalaPrivacy> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saloonwala Terms&Conditions'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.chevron_left_rounded),
          iconSize: 30.0,
        ),
      ),
      body: WebView(
        initialUrl: 'https://saloonwala.in/privacy-policy.html',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
