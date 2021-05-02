import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedding_guest/util/globle_variable.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

class NumberInputIncrementDecrement extends StatefulWidget {
  int initial;
  NumberInputIncrementDecrement({Key key, @required this.initial})
      : super(key: key);

  @override
  _NumberInputIncrementDecrementState createState() =>
      _NumberInputIncrementDecrementState();
}

class _NumberInputIncrementDecrementState
    extends State<NumberInputIncrementDecrement> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: NumberInputWithIncrementDecrement(
                  controller: _controller,
                  min: 0,
                  max: 5,
                  onDecrement: (num) => guestToUpdate.companion =num,
                  onIncrement: (num) => guestToUpdate.companion =num,
                  onSubmitted: (num) => guestToUpdate.companion =num,
                  validator: (value) => value.isEmpty? "Nhập số người đi cùng bạn" :
                  int.parse(value) > 5 ? 'Tối đa 5 người': null,
                  numberFieldDecoration: InputDecoration(enabled: false,
                      prefixText: "Số người đi cùng",contentPadding: EdgeInsets.only(left: 10) ),
                  initialValue: widget.initial != null ? widget.initial : 0,
                  widgetContainerDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(5)
                      ),
                      border: Border.all(
                        color: Colors.grey,
                      )
                  ),
                ),
              ),
            ],
          ),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(5),
        ),
      );
  }
}