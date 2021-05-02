import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_guest/bloc/login/bloc.dart';
import 'package:wedding_guest/firebase_repository/user_firebase_repository.dart';
import 'package:wedding_guest/firebase_repository/user_wedding_firebase_repository.dart';
import 'package:wedding_guest/model/vendor.dart';
import 'package:wedding_guest/screen/views/homeVendor/home_view.dart';
import 'package:wedding_guest/util/show_snackbar.dart';

class LoginPageMobile extends StatefulWidget {
  final ValueChanged<Vendor> onTapped;
  final ValueChanged<bool> onAdd;
  final ValueChanged<bool> onlogin;
  final ValueChanged<bool> onHome;
   LoginPageMobile({Key key, this.onTapped, this.onAdd,this.onlogin,this.onHome}) : super(key: key);
  // This widget is the root of your application.
  @override
  _LoginPageMobileState createState() => _LoginPageMobileState();
}

class _LoginPageMobileState extends State<LoginPageMobile> {
  ValueChanged<Vendor> get onTapped => widget.onTapped;
  ValueChanged<bool> get onAdd => widget.onAdd;
  ValueChanged<bool> get onlogin => widget.onlogin;
   ValueChanged<bool> get onHome => widget.onHome;
  bool _showPass = false;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();

  LoginBloc _loginBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc=BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passController.addListener(_onPasswordChanged);
  }

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
      child: Scaffold(
          body: BlocListener(
            cubit:  BlocProvider.of<LoginBloc>(context),
            listener: (context, state) {
              if (state.isSubmitting) {
                FocusScope.of(context).unfocus();
               // showProcessingSnackbar(context, state.message);
              }
              if (state.isSuccess) {
                FocusScope.of(context).unfocus();
                //showSuccessSnackbar(context, state.message);
                this.onlogin(false);
                this.onHome(true);
               Navigator.push(
                 context,
                  MaterialPageRoute(builder: (context) => HomeViewVendor(onTapped: onTapped,onAdd: onAdd,onHome: onHome,)),
              );
              }
              if (state.isFailure) {
                FocusScope.of(context).unfocus();
                showFailedSnackbar(context, state.message);
              }
            },
            child: SingleChildScrollView(
              child: BlocBuilder(
                  cubit: _loginBloc,
                  builder: (context, state) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 70, 0, 30),
                            child: Container(
                              child: Image(
                                  image: AssetImage(
                                      'assets/favicon-32x32.png')),
                              width: 70,
                              height: 70,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Color(0xffd8d8d8)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Text(
                              "Quản lý ứng dụng VWED",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: TextField(
                                style: TextStyle(fontSize: 18, color: Colors.black),
                                controller: _emailController,
                                decoration: InputDecoration(
                                    labelText: 'E-mail',
                                    errorText: !state.isEmailValid
                                        ? "Email không hợp lệ "
                                        : null,
                                    labelStyle: TextStyle(
                                        color: Colors.grey, fontSize: 15)),
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                            child: Stack(
                              alignment: AlignmentDirectional.centerEnd,
                              children: <Widget>[
                                TextField(
                                  style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                                  controller: _passController,
                                  obscureText: !_showPass,
                                  decoration: InputDecoration(
                                      labelText: 'Mật khẩu',
                                      errorText: !state.isPasswordValid
                                          ? "Mật khẩu không hợp lệ"
                                          : null,
                                      labelStyle: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ),
                                GestureDetector(
                                  onTap: onToggleShowPass,
                                  child: Text(
                                    _showPass ? "Ẩn Mật khẩu" : "Hiện Mật Khẩu",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 30,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: isLoginButtonEnabled(state)
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                                onPressed: () => isLoginButtonEnabled(state)
                                    ? _onFormSubmitted()
                                    : null,
                                child: Text(
                                  'Đăng Nhập ',
                                  style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),                                               
                        ],
                      ),
                    );
                  }),
            ),
          )),
    );
  }

  void onToggleShowPass() {
    setState(() {
      _showPass = !_showPass;
    });
  }

  void _onEmailChanged() {
    _loginBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.add(
      PasswordChanged(password: _passController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passController.text,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }
}
