import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_guest/bloc/category/bloc.dart';
import 'package:wedding_guest/bloc/login/login_bloc.dart';
import 'package:wedding_guest/bloc/vendor/bloc.dart';
import 'package:wedding_guest/firebase_repository/category_firebase_repository.dart';
import 'package:wedding_guest/firebase_repository/user_firebase_repository.dart';
import 'package:wedding_guest/firebase_repository/user_wedding_firebase_repository.dart';
import 'package:wedding_guest/firebase_repository/vendor_firebase_repository.dart';
import 'package:wedding_guest/model/guest.dart';
import 'package:wedding_guest/model/user_wedding.dart';
import 'package:wedding_guest/model/vendor.dart';
import 'package:wedding_guest/model/wedding.dart';
import 'package:wedding_guest/screen/views/addVendor/add_vendor_page.dart';
import 'package:wedding_guest/screen/views/allvendor/all_vendor_page.dart';
import 'package:wedding_guest/screen/views/vendorDetail/vendor_detail_page.dart';
import 'package:wedding_guest/screen/views/error/error_page.dart';
import 'package:wedding_guest/screen/views/homeVendor/home_view.dart';
import 'package:wedding_guest/screen/views/input_details/input_details.dart';
import 'package:wedding_guest/screen/views/login/login_page.dart';
import 'package:wedding_guest/screen/views/success/success_page.dart';
import 'package:wedding_guest/util/admin_vendor_route_path.dart';
import 'package:wedding_guest/screen/views/home/home_view.dart';
class AdminVendorRouterDelegate extends RouterDelegate<AdminVendorRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AdminVendorRoutePath> {
  UserWedding _selectedUser;
  Vendor _selectedVendor;
  Wedding _selectedWedding;
  String _selectedGuestID;
  //String _selectedVendorID;
  bool show404 = false;
  bool showDone = false;
  bool add = false;
  bool _login = true;
  bool _home = false;
  void _handleTapVendor(Vendor vendor) {
    _selectedVendor = Vendor(
        vendor.label,
        vendor.name,
        vendor.cateID,
        vendor.location,
        vendor.description,
        vendor.frontImage,
        vendor.ownerImage,
        vendor.email,
        vendor.phone,
        id: vendor.id);
    notifyListeners();
  }

  void _handleAdd(bool add1) {
    add = add1;
    notifyListeners();
  }

  void _handlelogin(bool login) {
    _login = login;
    _selectedUser = UserWedding('home');
    notifyListeners();
  }

  void _handleHome(bool home) {
    _home = home;
    notifyListeners();
  }

  void _handleTap(Guest guest) {
    _selectedGuestID = guest.id;
    notifyListeners();
  }

  void _tapSubmitSuccess(bool b) {
    showDone = b;
    notifyListeners();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  @override
  AdminVendorRoutePath get currentConfiguration {
    if (show404) return AdminVendorRoutePath.unknown();
    if (showDone) return AdminVendorRoutePath.Done();
    if (_selectedUser != null && add)
      return AdminVendorRoutePath.add(_selectedUser.id);
    if (_selectedUser != null && _home)
      return AdminVendorRoutePath.homeVendor(_selectedUser.id);
    if (_selectedUser == null && _selectedVendor == null && _selectedWedding == null)
      return AdminVendorRoutePath.login();
    if (_selectedUser != null && _selectedVendor == null)
      return AdminVendorRoutePath.allVendor(_selectedUser.id);
    if (_selectedUser != null && _selectedVendor != null)
      return AdminVendorRoutePath.inputDetailsVendor(
          _selectedUser.id, _selectedVendor.id);
    if (_selectedWedding != null && _selectedGuestID != null)
      return AdminVendorRoutePath.inputDetails(
          _selectedWedding.id, _selectedGuestID);
    if (_selectedWedding != null && _selectedGuestID == null)
      return AdminVendorRoutePath.register(_selectedWedding.id);
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
        BlocProvider<VendorBloc>(
          create: (BuildContext context) => VendorBloc(
            todosRepository: FirebaseVendorRepository(),
          ),
        ),
        BlocProvider<CateBloc>(
          create: (BuildContext context) => CateBloc(
            todosRepository: FirebaseCategoryRepository(),
          ),
        ),
      ],
      child: Navigator(
        key: navigatorKey,
        pages: [
          if (show404)
            MaterialPage(key: ValueKey('UnknownPage'), child: UnknownScreen())
          else if (showDone)
            MaterialPage(key: ValueKey('donePage'), child: SuccessPage())
          else if (_selectedVendor == null && !add && _login &&_selectedWedding == null)
            MaterialPage(
                key: ValueKey('Login'),
                child: LoginPage(
                  onTapped: _handleTapVendor,
                  onAdd: _handleAdd,
                  onlogin: _handlelogin,
                  onHome: _handleHome,
                ))
          else if (_selectedUser == null && !_login && _selectedWedding == null)
            MaterialPage(
                key: ValueKey('Login'),
                child: LoginPage(
                  onTapped: _handleTapVendor,
                  onAdd: _handleAdd,
                  onlogin: _handlelogin,
                  onHome: _handleHome,
                ))
          else if (_selectedUser != null &&
              _selectedVendor == null &&
              !add &&
              !_login &&
              _home)
            MaterialPage(
                key: ValueKey('HomeVendor'),
                child: HomeViewVendor(
                  onTapped: _handleTapVendor,
                  onAdd: _handleAdd,
                  onHome: _handleHome,
                ))
          else if (_selectedUser != null &&
              _selectedVendor == null &&
              add &&
              !_login)
            MaterialPage(
              key: ValueKey('AddVendor'),
              child: AddVendorPage(),
            )
          else if (_selectedUser != null &&
              _selectedVendor == null &&
              !add &&
              !_login)
            MaterialPage(
                key: ValueKey('AllVendor'),
                child: AllVendorPage(
                  onTapped: _handleTapVendor,
                  onAdd: _handleAdd,
                ))
          else if (_selectedUser != null && _selectedVendor != null)
            MaterialPage(
                key: ValueKey('inputDetailsVendor'),
                child: VendorDetailPage(
                  vendor: _selectedVendor,
                  isEditing: true,
                ))
          else if (_selectedWedding != null && _selectedGuestID == null)
            MaterialPage(
              key: ValueKey('Register'),
              child: HomeView(
                selectedWedding: _selectedWedding,
                onTapped: _handleTap,
              ),
            )
          else if (_selectedWedding != null && _selectedGuestID != null)
            MaterialPage(
              key: ValueKey('InputDetails'),
              child: InputDetailsPage(
                selectedWedding: _selectedWedding,
                selectedGuestID: _selectedGuestID,
                onTapped: _tapSubmitSuccess,
              ),
            ),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          if (route.toString().contains('HomeVendor')) {
            print(route.toString());
            _selectedVendor = null;
            _selectedUser = null;
            show404 = false;
            add = false;
            _login = true;
            notifyListeners();
            return true;
          } else if (route.toString().contains('inputDetailsVendor')) {
            print(route.toString());
            _selectedVendor = null;
            _selectedUser = UserWedding('admin');
            show404 = false;
            add = false;
            _login = false;
            notifyListeners();
            return true;
          } else if(route.toString().contains('AddVendor')){
            _selectedVendor = null;
            _selectedUser = UserWedding('admin');
            show404 = false;
            add = false;
            _login = false;
            notifyListeners();
            return true;
          }
          _selectedWedding = null;
          _selectedGuestID = null;
          show404 = false;
          showDone = false;
          notifyListeners();
          return true;
        },
      ),
    );
  }

  _setPath(AdminVendorRoutePath path) {
    _selectedUser = null;
    _selectedVendor = null;
    _login=false;
    if (path.isAllVendorPage && _login==false) {
      _selectedUser = UserWedding(path.adminID);
      add = false;
      _login = false;
      _home = false;
      _selectedVendor = null;
      show404 = false;
    } else if (path.isInputDetailsVendorPage && _login==false) {
      _selectedUser = UserWedding(path.adminID);
      _selectedVendor =
          Vendor("", "", "", "", "", "", "", "", "", id: path.vendorID);
      add = false;
      _login = false;
      _home = false;
      show404 = false;
    } else if (path.isLoginPage) {
      _selectedUser = null;
      _selectedVendor = null;
      add = false;
      _login = true;
      _home = false;
      show404 = false;
      return;
    } else if (path.isHomeVendorPage && _login==false) {
      _selectedUser = UserWedding(path.adminID);
      _selectedVendor = null;
      show404 = false;
      add = false;
      _login = false;
      _home = true;
    } else if (path.isAdd && _login==false) {
      _selectedUser = UserWedding(path.adminID);
      _selectedVendor = null;
      show404 = false;
      add = true;
      _login = false;
      _home = false;
    }else if(_login == true && path.isRegisterPage == false && path.isInputDetailsPage == false){
      _selectedUser = null;
      _selectedVendor = null;
      add = false;
      _login = true;
      _home = false;
      show404 = false;
      return;
    }
    if (path.isRegisterPage) {
      _selectedWedding = Wedding(path.weddingID, null);
      return;
    } else if (path.isInputDetailsPage) {
      _selectedWedding = Wedding(path.weddingID, null);
      _selectedGuestID = path.guestID;
    } else {
      _selectedGuestID = null;
      _selectedWedding = null;
    }
    if (path.isUnknown) {
      _selectedWedding = null;
      _selectedUser = null;
      _selectedVendor = null;
      show404 = true;
      add = false;
      _login = false;
      _home = false;
      return;
    }
    if (path.isDone) {
      showDone = true;
      return;
    }

    
    show404 = false;
    //add = false;
    showDone = false;
  }

  @override
  Future<void> setNewRoutePath(AdminVendorRoutePath path) async {
    _setPath(path);
  }

  @override
  Future<void> setInitialRoutePath(AdminVendorRoutePath path) async {
    _setPath(path);
  }
}
