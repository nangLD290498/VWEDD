import 'package:flutter/material.dart';
import 'package:wedding_guest/util/globle_variable.dart';

class TextFieldCustom extends StatelessWidget {
  bool allowEmpty;
  final int maxlines;
  int length;
  final String hintText;
  String initialText;

  TextFieldCustom({Key key, @required this.hintText, @required this.maxlines,
    @required this.initialText,@required this.length, @required this.allowEmpty})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 300),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: TextFormField(
        maxLength: length,
        maxLines: maxlines,
        autocorrect: true,
        initialValue: initialText,
        onSaved: (input){
          initialText = input;
          if(!allowEmpty) guestToUpdate.name = input;
          if(allowEmpty) guestToUpdate.congrat = input;
        },
        validator: (value) => allowEmpty == true? null
            : (value == null || value.trim().isEmpty)? "Hãy nhập tên bạn" : null,
        decoration: InputDecoration(
          counterText:"",
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white60,
          border: new OutlineInputBorder(
            borderSide: new BorderSide(color: Colors.grey),
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
