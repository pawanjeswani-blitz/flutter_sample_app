import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        title: Text(
          'Saloonwala Privacy Policy',
          style: GoogleFonts.poppins(),
        ),
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
