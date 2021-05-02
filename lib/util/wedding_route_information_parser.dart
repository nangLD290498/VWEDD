import 'package:flutter/cupertino.dart';
import 'package:wedding_guest/util/wedding_route_path.dart';

class WeddingGuestRouteInformationParser extends RouteInformationParser<WeddingGuestRoutePath> {
  @override
  Future<WeddingGuestRoutePath> parseRouteInformation(
      RouteInformation routeInfo) async {
    final uri = Uri.parse(routeInfo.location);

    // Handle '/:weddingID'
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments.first != 'guest') return WeddingGuestRoutePath.unknown();
      final weddingID = uri.pathSegments.elementAt(1);
      print(weddingID);
      if (weddingID == null) return WeddingGuestRoutePath.unknown();
      if(weddingID == "done") return WeddingGuestRoutePath.Done();
      return WeddingGuestRoutePath.register(weddingID);
    }
    // Handle '/:weddingID/:guestID'
    if (uri.pathSegments.length == 3) {
      if (uri.pathSegments.first != 'guest') return WeddingGuestRoutePath.unknown();
      final weddingID = uri.pathSegments.elementAt(1);
      final guestID = uri.pathSegments.elementAt(2);
      print(weddingID + "-" + guestID);
      if (weddingID != null && guestID !=null) {return WeddingGuestRoutePath.inputDetails(weddingID,guestID);}
      if (weddingID != null && guestID == null) {return WeddingGuestRoutePath.register(weddingID);}
      return WeddingGuestRoutePath.unknown();
    }

    return WeddingGuestRoutePath.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(WeddingGuestRoutePath path) {
    if (path.isUnknown) {
      return RouteInformation(location: '/guest/404');
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


