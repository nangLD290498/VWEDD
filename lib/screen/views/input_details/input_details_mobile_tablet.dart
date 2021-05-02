import 'package:flutter/material.dart';
import 'package:wedding_guest/model/guest.dart';
import 'package:wedding_guest/screen/widgets/details_input/details_input.dart';
class InputDetailsMobileTablet extends StatelessWidget {
  Guest guest;
  String weddingID;
  ValueChanged<bool> onTapped;
  InputDetailsMobileTablet({Key key, @required this.onTapped, @required this.guest,@required this.weddingID}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        //ShowImage(src: "/B&G.jpg"),
        Expanded(
          child: Center(
            child: Container(
                color: Colors.grey[200],
                child: DetailsInput(onTapped: onTapped,guest: guest,weddingID: weddingID,)),
          ),
        )
      ],
    );
  }
}
