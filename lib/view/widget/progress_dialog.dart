import 'package:flutter/material.dart';

class ProgressDialog {
  static showProgressDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
              child: Container(
            decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(8.0)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CircularProgressIndicator(),
            ),
          ));
        });
  }
}
