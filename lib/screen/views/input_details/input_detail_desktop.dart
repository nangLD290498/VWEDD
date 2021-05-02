import 'package:flutter/material.dart';
import 'package:wedding_guest/model/guest.dart';
import 'package:wedding_guest/screen/widgets/details_input/details_input.dart';
import 'package:wedding_guest/screen/widgets/image_show/image_show.dart';

class InputDetailsDesktop extends StatelessWidget {
  Guest guest;
  String weddingID;
  ValueChanged<bool> onTapped;
  InputDetailsDesktop({Key key, @required this.onTapped, @required this.guest,@required this.weddingID}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ShowImage(src: "assets/B&G.jpg",isFromAssets: true,),
        Expanded(
          child: Center(
            child: DetailsInput(onTapped: onTapped,guest: guest,weddingID: weddingID,),
          ),
        )
      ],
    );
  }
}
