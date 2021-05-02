import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_guest/bloc/login/bloc.dart';
import 'package:wedding_guest/firebase_repository/user_firebase_repository.dart';
import 'package:wedding_guest/firebase_repository/user_wedding_firebase_repository.dart';
import 'package:wedding_guest/model/vendor.dart';
import 'package:wedding_guest/screen/views/homeVendor/home_view.dart';
import 'package:wedding_guest/util/show_snackbar.dart';

class LoginPageDesktop extends StatefulWidget {
  final ValueChanged<bool> onlogin;
  final ValueChanged<Vendor> onTapped;
  final ValueChanged<bool> onAdd;
  final ValueChanged<bool> onHome;
  LoginPageDesktop(
      {Key key, this.onTapped, this.onAdd, this.onlogin, this.onHome})
      : super(key: key);
  // This widget is the root of your application.
  @override
  _LoginPageDesktopState createState() => _LoginPageDesktopState();
}

class _LoginPageDesktopState extends State<LoginPageDesktop> {
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
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    final screenSide = MediaQuery.of(context).size;
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
            cubit: BlocProvider.of<LoginBloc>(context),
            listener: (context, state) {
              if (state.isSubmitting) {
                FocusScope.of(context).unfocus();
                //   showProcessingSnackbar(context, state.message);
              }
              if (state.isSuccess) {
                FocusScope.of(context).unfocus();
                //showSuccessSnackbar(context, state.message);
                this.onlogin(false);
                this.onHome(true);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeViewVendor(
                            onHome: onHome,
                            onAdd: onAdd,
                            onTapped: onTapped,
                          )),
                );
              }
              if (state.isFailure) {
                FocusScope.of(context).unfocus();
                showFailedSnackbar(context, state.message);
              }
            },
            child: BlocBuilder(
                cubit: _loginBloc,
                builder: (context, state) {
                  return Container(
                    width: screenSide.width,
                    height: screenSide.height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/background1.jpg"),
                          fit: BoxFit.cover),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width / 25,
                          MediaQuery.of(context).size.height / 4,
                          0,
                          0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 360,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Quản lý ứng dụng VWED',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 30),
                                Image.asset('/LowIcon.png')
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              0,
                              0,
                              MediaQuery.of(context).size.width / 20,
                              MediaQuery.of(context).size.height / 12,
                            ),
                            child: Container(
                              width: 320,
                              child: Column(
                                children: [
                                  Text(
                                    'Đăng nhập dưới quyền admin',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  TextField(
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      labelText: 'E-mail',
                                      errorText: !state.isEmailValid
                                          ? "Email không hợp lệ "
                                          : null,
                                      filled: true,
                                      fillColor: Colors.blueGrey[50],
                                      labelStyle: TextStyle(fontSize: 12),
                                      contentPadding: EdgeInsets.only(left: 30),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blueGrey[50]),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blueGrey[50]),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Stack(
                                      alignment: AlignmentDirectional.centerEnd,
                                      children: <Widget>[
                                        TextField(
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black),
                                          controller: _passController,
                                          obscureText: !_showPass,
                                          decoration: InputDecoration(
                                            labelText: 'Mật khẩu',
                                            errorText: !state.isPasswordValid
                                                ? "Mật khẩu không hợp lệ"
                                                : null,
                                            filled: true,
                                            fillColor: Colors.blueGrey[50],
                                            labelStyle: TextStyle(fontSize: 12),
                                            contentPadding:
                                                EdgeInsets.only(left: 30),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blueGrey[50]),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blueGrey[50]),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: onToggleShowPass,
                                            child: Icon(
                                              _showPass
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              size: 30,
                                              color: Colors.pink,
                                            ),
                                          ),
                                        )
                                      ]),
                                  SizedBox(height: 40),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.deepPurple[100],
                                          spreadRadius: 10,
                                          blurRadius: 20,
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      child: Container(
                                          width: double.infinity,
                                          height: 50,
                                          child:
                                              Center(child: Text("Đăng Nhập"))),
                                      onPressed: () =>
                                          isLoginButtonEnabled(state)
                                              ? _onFormSubmitted()
                                              : null,
                                      style: ElevatedButton.styleFrom(
                                        primary: isLoginButtonEnabled(state)
                                            ? Colors.blue
                                            : Colors.grey,
                                        onPrimary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ));
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
