import 'package:flutter/material.dart';

showSuccessAlertDialog(
    BuildContext context, String title, String message, Function function) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: function,
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
