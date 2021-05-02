import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonDetailsDialog extends StatefulWidget {
  final String message;
  final Function onPressedFunction;
  PersonDetailsDialog({Key key, @required this.message, this.onPressedFunction})
      : super(key: key);

  @override
  _PersonDetailsDialogState createState() {
    return _PersonDetailsDialogState();
  }
}

class _PersonDetailsDialogState extends State<PersonDetailsDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Thông báo: ', style: TextStyle(fontWeight: FontWeight.bold),),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(widget.message),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Có'),
          onPressed: () {
            widget.onPressedFunction();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Hủy'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
