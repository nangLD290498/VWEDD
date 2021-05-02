import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_guest/bloc/guests/bloc.dart';
import 'package:wedding_guest/firebase_repository/guest_firebase_repository.dart';
import 'package:wedding_guest/firebase_repository/notification_firebase_repository.dart';
import 'package:wedding_guest/model/guest.dart';
import 'package:wedding_guest/model/wedding.dart';
import 'package:wedding_guest/screen/views/error/error_page.dart';
import 'package:wedding_guest/screen/views/input_details/input_detail_desktop.dart';
import 'package:wedding_guest/screen/views/input_details/input_details_mobile_tablet.dart';
import 'package:wedding_guest/screen/widgets/centered_view/centered_view.dart';
import 'package:wedding_guest/util/globle_variable.dart';
import 'package:responsive_builder/responsive_builder.dart';

class InputDetailsPage extends StatelessWidget {
  Wedding selectedWedding;
  String selectedGuestID;
  ValueChanged<bool> onTapped;
  InputDetailsPage(
      {Key key,
      @required this.selectedWedding,
      @required this.selectedGuestID,
      @required this.onTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GuestsBloc(
        guestsRepository: FirebaseGuestRepository(),
        notificationRepository: NotificationFirebaseRepository(),
      )..add(LoadGuests(selectedWedding.id)),
      child: Builder(
        builder: (context) => BlocBuilder(
          cubit: BlocProvider.of<GuestsBloc>(context),
          builder: (context, state) {
            if(globleweddingID != selectedWedding.id) return UnknownScreen();
            if (state is GuestsLoaded) {
              List<Guest> guests = state.guests;
              for(int i=0; i<guests.length;i++){
                Guest guest = guests[i];
                if (guest.id == selectedGuestID) {
                  return Scaffold(
                    backgroundColor: Colors.white12,
                    body: CenteredView(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: ScreenTypeLayout(
                              mobile: InputDetailsMobileTablet(onTapped: onTapped,guest: guest,weddingID: selectedWedding.id,),
                              tablet: InputDetailsMobileTablet(onTapped: onTapped,guest: guest,weddingID: selectedWedding.id,),
                              desktop: InputDetailsDesktop(onTapped: onTapped,guest: guest,weddingID: selectedWedding.id,),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              }
              return UnknownScreen();
            }
              return Container(
                color: Colors.grey[100],
                child: Center(
                  child: Image.asset(
                    "assets/favicon-32x32.png",
                  ),
                ),
              );

          },
        ),
      ),
    );
  }
}
