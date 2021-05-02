import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedding_guest/model/vendor.dart';
import 'package:wedding_guest/screen/views/homeVendor/home_view_desktop.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomeViewVendor extends StatelessWidget {
  final ValueChanged<Vendor> onTapped;
  final ValueChanged<bool> onAdd;
  final ValueChanged<bool> onHome;
  HomeViewVendor({Key key, this.onTapped, this.onAdd, this.onHome})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: ScreenTypeLayout(
          mobile: HomeViewDesktop(
            onTapped: onTapped,
            onAdd: onAdd,
            onHome: onHome,
          ),
          tablet: HomeViewDesktop(
            onTapped: onTapped,
            onAdd: onAdd,
            onHome: onHome,
          ),
          desktop: HomeViewDesktop(
            onTapped: onTapped,
            onAdd: onAdd,
            onHome: onHome,
          ),
        ),
      ),
    );
  }
}
