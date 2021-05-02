import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [CircularProgressIndicator(), Text("Đang xử lý...")],
    );
  }
}
