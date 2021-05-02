import 'package:flutter/material.dart';
import 'package:wedding_guest/util/globle_variable.dart';

class DropDownCustom extends StatelessWidget {
  int initialValue;
  Function onTapped;
  DropDownCustom({Key key,@required this.initialValue,@required this.onTapped})
      : super(key: key);
  String selected = "Sẽ tới";
  List<String> items = ["Sẽ tới", "Không tới"];
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 300),
      child: DropdownButtonFormField(
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        isExpanded: true,
        style: TextStyle(color: Colors.deepPurple),
        items: items
            .map((label) => DropdownMenuItem(
          child: Text(label.toString(), style: TextStyle(color: Colors.black87,fontSize: 17),),
          value: label,
        )).toList(),
        onChanged: (val) {
          selected = val;
          if(selected == "Sẽ tới") status =1;
          if(selected == "Không tới") status =2;
          if(selected.isEmpty) status =0;
          onTapped(val);
        },
        value: initialValue ==1  ? "Sẽ tới" : initialValue ==2 ? "Không tới" : null,
        validator: (val) => val == null? "Hãy chọn đi hay không" : null,
        onSaved: (val) {
          selected = val;
          guestToUpdate.status = status;
        },
        decoration: InputDecoration(
          hintText: "Bạn sẽ tham gia chứ",
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
    );;
  }
}
