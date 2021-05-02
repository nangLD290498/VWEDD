import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedding_guest/model/guest.dart';
import 'package:wedding_guest/model/wedding.dart';
import 'package:wedding_guest/screen/views/error/error_page.dart';
import 'package:wedding_guest/screen/views/home/home_view.dart';
import 'package:wedding_guest/screen/views/input_details/input_details.dart';
import 'package:wedding_guest/screen/views/success/success_page.dart';
import 'package:wedding_guest/util/wedding_route_path.dart';


class WeddingGuestRouterDelegate extends RouterDelegate<WeddingGuestRoutePath>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<WeddingGuestRoutePath> {
  Wedding _selectedWedding;
  String _selectedGuestID;
  bool show404 = false;
  bool showDone = false;

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
  WeddingGuestRoutePath get currentConfiguration {
    if (show404) return WeddingGuestRoutePath.unknown();
    if (showDone) return WeddingGuestRoutePath.Done();

    if (_selectedWedding == null) return WeddingGuestRoutePath.unknown();

    if (_selectedWedding != null && _selectedGuestID != null)
      return WeddingGuestRoutePath.inputDetails(
          _selectedWedding.id, _selectedGuestID);

    return WeddingGuestRoutePath.register(_selectedWedding.id);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(key: ValueKey('UnknownPage'), child: UnknownScreen()),
        if (show404)
          MaterialPage(key: ValueKey('UnknownPage'), child: UnknownScreen())
        else if(showDone)
          MaterialPage(key: ValueKey('donePage'), child: SuccessPage())
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
            child: InputDetailsPage(selectedWedding: _selectedWedding,selectedGuestID: _selectedGuestID,onTapped: _tapSubmitSuccess,),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        _selectedWedding = null;
        _selectedGuestID = null;
        show404 = false;
        showDone = false;
        notifyListeners();
        return true;
      },
    );
  }

  _setPath(WeddingGuestRoutePath path) {
    _selectedGuestID = null;
    _selectedWedding = null;
    if (path.isUnknown) {
      _selectedWedding = null;
      show404 = true;
      return;
    }

    if (path.isDone) {
      showDone = true;
      return;
    }

    if (path.isRegisterPage) {
      _selectedWedding = Wedding(path.weddingID, null);
    } else if (path.isInputDetailsPage) {
      _selectedWedding = Wedding(path.weddingID, null);
      _selectedGuestID = path.guestID;
    } else {
      _selectedGuestID = null;
      _selectedWedding = null;
    }

    show404 = false;
    showDone = false;
  }

  @override
  Future<void> setNewRoutePath(WeddingGuestRoutePath path) async {
    _setPath(path);
  }

  @override
  Future<void> setInitialRoutePath(WeddingGuestRoutePath path) async {
    _setPath(path);
  }
}
