import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedding_guest/screen/views/addVendor/add_vendor_desktop.dart';
import 'package:wedding_guest/screen/views/addVendor/add_vendor_mobile.dart';
import 'package:responsive_builder/responsive_builder.dart';


class AddVendorPage extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
                      onWillPop: () async => false,
                      child: Scaffold(
                        backgroundColor: Colors.grey[100],
                        body: ScreenTypeLayout(
                          mobile: AddVendorMobilePage(                                                       
                          ),
                          tablet: AddVendorMobilePage(                           
                            
                          ),
                          desktop: AddVendorDesktopPage(
                          
                            
                          ),
                        ),
                      ),
                    );
  }
}
