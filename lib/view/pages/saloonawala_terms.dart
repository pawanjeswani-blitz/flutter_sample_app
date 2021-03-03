import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class SaloonWalaTerms extends StatefulWidget {
  @override
  _SaloonWalaTermsState createState() => _SaloonWalaTermsState();
}

class _SaloonWalaTermsState extends State<SaloonWalaTerms> {
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
        initialUrl: 'https://saloonwala.in/terms-conditions.html',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
