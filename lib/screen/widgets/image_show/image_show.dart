import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  bool isFromAssets;
  final String src;
  ShowImage({Key key, @required this.src, @required this.isFromAssets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isFromAssets)
      return Container(
        child: new Image.asset(
          src,
          fit: BoxFit.cover,
        ),
      );
    return Container(
        child: new Image.network(
      src,
      fit: BoxFit.cover,
     /* loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        return Center(
            child: Container(
                margin: EdgeInsets.only(top: 60),
                child: Text(
                  "Đang tải thiệp mời...",
                  style: TextStyle(fontSize: 15,),
                )));
      },*/
    ));
  }
}
