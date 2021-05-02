import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedding_guest/bloc/login/bloc.dart';
import 'package:wedding_guest/firebase_repository/user_firebase_repository.dart';
import 'package:wedding_guest/firebase_repository/user_wedding_firebase_repository.dart';
import 'package:wedding_guest/model/vendor.dart';
import 'package:wedding_guest/screen/views/homeVendor/home_view.dart';
import 'package:wedding_guest/screen/views/login/login_page_desktop.dart';
import 'package:wedding_guest/screen/views/login/login_page_mobile.dart';
import 'package:wedding_guest/screen/widgets/centered_view/centered_view.dart';
import 'package:wedding_guest/util/show_snackbar.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  final ValueChanged<Vendor> onTapped;
  final ValueChanged<bool> onAdd;
  final ValueChanged<bool> onlogin;
  final ValueChanged<bool> onHome;
   LoginPage({Key key, this.onTapped, this.onAdd,this.onlogin,this.onHome}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
            create: (BuildContext context) => LoginBloc(
              userWeddingRepository: FirebaseUserWeddingRepository(),
              userRepository: FirebaseUserRepository(),
            )),
      ],
      child:BlocListener(
        cubit:  BlocProvider.of<LoginBloc>(context),
        listener: (context, state) {
          if (state.isSubmitting) {
            FocusScope.of(context).unfocus();
          //  showProcessingSnackbar(context, state.message);
          }
          if (state.isSuccess) {
            FocusScope.of(context).unfocus();
            showSuccessSnackbar(context, state.message);
            onlogin(false);
            this.onHome(true);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeViewVendor(onTapped: onTapped,onAdd: onAdd,onHome: onHome,)),
            );
          }
          if (state.isFailure) {
            FocusScope.of(context).unfocus();
            showFailedSnackbar(context, 'Có lỗi xảy ra');
          }
        },
        child: WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: Colors.grey[100],
            body: CenteredView(
              child: ScreenTypeLayout(
                mobile: LoginPageMobile(onTapped: onTapped,onAdd: onAdd,onlogin: onlogin,onHome: onHome,),
                tablet: LoginPageMobile(onTapped: onTapped,onAdd: onAdd,onlogin: onlogin,onHome: onHome,),
                desktop: LoginPageDesktop(onTapped: onTapped,onAdd: onAdd,onlogin: onlogin,onHome: onHome,),
              ),
            ),
          ),
        ),
      )
    );
  }
}
