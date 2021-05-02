import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedding_guest/bloc/vendor/bloc.dart';
import 'package:wedding_guest/firebase_repository/vendor_firebase_repository.dart';
import 'package:wedding_guest/model/vendor.dart';
import 'package:wedding_guest/screen/views/vendorDetail/vendor_detail_desktop.dart';
import 'package:wedding_guest/screen/views/vendorDetail/vendor_detail_mobile.dart';
import 'package:wedding_guest/screen/views/error/error_page.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VendorDetailPage extends StatelessWidget {
  final bool isEditing;
  final Vendor vendor;
  const VendorDetailPage({Key key,  this.isEditing, this.vendor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VendorBloc>(
          create: (BuildContext context) =>
              VendorBloc(todosRepository: FirebaseVendorRepository())
                ..add(LoadVendor()),
        ),
      ],
      child: Builder(
        builder: (context) => BlocBuilder(
            cubit: BlocProvider.of<VendorBloc>(context),
            builder: (context, state) {
              if(isEditing == false){
                return WillPopScope(
                      onWillPop: () async => false,
                      child: Scaffold(
                        backgroundColor: Colors.grey[100],
                        body: ScreenTypeLayout(
                          mobile: VendorDetailMobilePage(
                            
                            isEditing: true,
                          ),
                          tablet: VendorDetailMobilePage(
                            
                            isEditing: true,
                          ),
                          desktop: VendorDetailDesktopPage(
                          
                            isEditing: true,
                          ),
                        ),
                      ),
                    );
              }else{
                  if (state is VendorLoaded) {
                if (vendor.label == "") {
                  Vendor _vendor;
                  for (int i = 0; i < state.vendors.length; i++) {
                    String id = state.vendors[i].id;
                    String vendorid = vendor.id.trim();
                    if (id == vendorid) {
                      _vendor = state.vendors[i];
                    }
                  }
                  if (_vendor != null) {
                    return WillPopScope(
                      onWillPop: () async => false,
                      child: Scaffold(
                        backgroundColor: Colors.grey[100],
                        body: ScreenTypeLayout(
                          mobile: VendorDetailMobilePage(
                            vendor: _vendor,
                            isEditing: true,
                          ),
                          tablet: VendorDetailMobilePage(
                            vendor: _vendor,
                            isEditing: true,
                          ),
                          desktop: VendorDetailDesktopPage(
                            vendor: _vendor,
                            isEditing: true,
                          ),
                        ),
                      ),
                    );
                  } else
                    return UnknownScreen();
                }
                return WillPopScope(
                onWillPop: () async => false,
                child: Scaffold(
                  backgroundColor: Colors.grey[100],
                  body: ScreenTypeLayout(
                      mobile: VendorDetailMobilePage(
                            vendor: vendor,
                            isEditing: true,
                          ),
                      tablet: VendorDetailMobilePage(
                            vendor: vendor,
                            isEditing: true,
                          ),
                      desktop: VendorDetailDesktopPage(
                            vendor: vendor,
                            isEditing: true,
                          ),
                    ),
                  
                ),
              );
              }
              return Container(
                color:  Colors.grey[100],
                child: Center(child: Image.asset(
                  "/favicon-32x32.png",
                ),),
              );
              }
              
            }
            ),
      ),
    );
  }
}
