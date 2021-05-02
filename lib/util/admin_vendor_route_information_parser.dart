import 'package:flutter/cupertino.dart';
import 'package:wedding_guest/util/admin_vendor_route_path.dart';

class AdminVendorRouteInformationParser extends RouteInformationParser<AdminVendorRoutePath> {
  @override
  Future<AdminVendorRoutePath> parseRouteInformation(
      RouteInformation routeInfo) async {
    final uri = Uri.parse(routeInfo.location);
    // Handle '/'
    if (uri.pathSegments.length == 0 ) {
      return AdminVendorRoutePath.login();
    }
    // Handle '/login'
    if (uri.pathSegments.length == 1 && uri.pathSegments.first != 'admin'&& uri.pathSegments.first != 'home') {
      final login = uri.pathSegments.first;
      if (login == null) return AdminVendorRoutePath.unknown();
      if(login != "login" ) return  AdminVendorRoutePath.unknown();
      return AdminVendorRoutePath.login();
    }
    // Handle '/home'
    if (uri.pathSegments.length == 1 && uri.pathSegments.first != 'admin' &&  uri.pathSegments.first != 'login') {
      final home = uri.pathSegments.first;
      if (home == null) return AdminVendorRoutePath.unknown();
      if(home != "home" ) return  AdminVendorRoutePath.unknown();
      return AdminVendorRoutePath.homeVendor(home);
    }

    // Handle '/admin'
    if (uri.pathSegments.length == 1 && uri.pathSegments.first != 'login'&& uri.pathSegments.first != 'home') {
      final admin = uri.pathSegments.first;
      if (admin == null) return AdminVendorRoutePath.unknown();
      if(admin != 'admin') return  AdminVendorRoutePath.unknown();
      return  AdminVendorRoutePath.allVendor(admin);
    }
    // Handle '/admin/:vendorID'
    if (uri.pathSegments.length == 2 && uri.pathSegments.elementAt(1)!='add' && uri.pathSegments.elementAt(0)!='guest') {
      final admin = uri.pathSegments.first;
      final vendorID = uri.pathSegments.elementAt(1);
      if (admin == 'admin' && vendorID !=null) return AdminVendorRoutePath.inputDetailsVendor(admin,vendorID);
      else if (admin == 'admin' && vendorID ==null) return AdminVendorRoutePath.allVendor(admin);

      return AdminVendorRoutePath.unknown();
    }

    // Handle '/admin/add'
    if (uri.pathSegments.length == 2 && uri.pathSegments.elementAt(1) =='add')  {
      final admin = uri.pathSegments.first;
      final add = uri.pathSegments.elementAt(1);
      if (admin == 'admin' && add =='add') return AdminVendorRoutePath.add(admin);
      else if (admin == 'admin' && add ==null) return AdminVendorRoutePath.allVendor(admin);

      return AdminVendorRoutePath.unknown();
    }

    // Handle '/:weddingID'
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments.first != 'guest') return AdminVendorRoutePath.unknown();
      final weddingID = uri.pathSegments.elementAt(1);
      print(weddingID);
      if (weddingID == null) return AdminVendorRoutePath.unknown();
      if(weddingID == "done") return AdminVendorRoutePath.Done();
      return AdminVendorRoutePath.register(weddingID);
    }
    // Handle '/:weddingID/:guestID'
    if (uri.pathSegments.length == 3) {
      if (uri.pathSegments.first != 'guest') return AdminVendorRoutePath.unknown();
      final weddingID = uri.pathSegments.elementAt(1);
      final guestID = uri.pathSegments.elementAt(2);
      print(weddingID + "-" + guestID);
      if (weddingID != null && guestID !=null) {return AdminVendorRoutePath.inputDetails(weddingID,guestID);}
      if (weddingID != null && guestID == null) {return AdminVendorRoutePath.register(weddingID);}
      return AdminVendorRoutePath.unknown();
    }

    return AdminVendorRoutePath.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(AdminVendorRoutePath path) {

    if (path.isUnknown) {
      return RouteInformation(location: '/404');
    }
    if(path.isHomeVendorPage){
      return RouteInformation(location: '/home');
    }
    if (path.isAllVendorPage) {
      return RouteInformation(location: '/admin');
    }
    if (path.isInputDetailsVendorPage) {
      return RouteInformation(location: '/admin/${path.vendorID}');
    }
    if (path.isLoginPage) {
      return RouteInformation(location: '/login');
    }
    if(path.isAdd){
      return RouteInformation(location: '/admin/add');
    }
    if (path.isRegisterPage) {
      return RouteInformation(location: '/guest/${path.weddingID}');
    }
    if (path.isInputDetailsPage) {
      return RouteInformation(location: '/guest/${path.weddingID}/${path.guestID}');
    }
    if (path.isDone) {
      return RouteInformation(location: '/guest/done');
    }


    return null;
  }
}


