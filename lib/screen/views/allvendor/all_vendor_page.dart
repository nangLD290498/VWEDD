import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedding_guest/bloc/vendor/bloc.dart';
import 'package:wedding_guest/firebase_repository/vendor_firebase_repository.dart';
import 'package:wedding_guest/model/vendor.dart';
import 'package:wedding_guest/screen/views/allvendor/all_vendor_desktop.dart';
import 'package:wedding_guest/screen/views/allvendor/all_vendor_mobile.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllVendorPage extends StatelessWidget {
  final ValueChanged<Vendor> onTapped;
  final ValueChanged<bool> onAdd;
   AllVendorPage({Key key, this.onTapped, this.onAdd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<VendorBloc>(
              create: (BuildContext context) => VendorBloc(
                todosRepository: FirebaseVendorRepository(),
              )),
        ],
          child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              backgroundColor: Colors.grey[100],
              body:  ScreenTypeLayout(
                  mobile: AllVendorPageMobile(onTapped: onTapped,onAdd: onAdd,),
                  tablet: AllVendorPageMobile(onTapped: onTapped,onAdd: onAdd),
                  desktop: AllVendorPageDesktop(onTapped: onTapped,onAdd: onAdd),
                  
                ),
              
            ),
          ),
    );
  }
}
