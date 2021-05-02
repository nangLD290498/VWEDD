import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_guest/bloc/invitation/bloc.dart';
import 'package:wedding_guest/model/guest.dart';
import 'package:wedding_guest/screen/widgets/image_show/image_show.dart';
import 'package:wedding_guest/screen/widgets/phone_input/phone_input.dart';

class HomeViewDesktop extends StatelessWidget {
  String weddingID;
  ValueChanged<Guest> onTapped;
  HomeViewDesktop({Key key, @required this.weddingID, @required this.onTapped})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      BlocBuilder(
                          cubit: BlocProvider.of<InvitationBloc>(context),
                          builder: (context, state) {
                            if (state is InvitationCardLoaded)
                              return Container(
                                constraints: BoxConstraints(maxWidth: 450),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey[400],
                                        width: 1.0
                                    ),
                                  color: Colors.white,
                                  image: DecorationImage(
                                    image: AssetImage("assets/favicon-32x32.png",),
                                    fit: BoxFit.none,
                                  ),
                                ),
                                child: Center(
                                  child: ShowImage(
                                    src: state.invitationCard.url,
                                    isFromAssets: false,
                                  ),
                                ),
                              );
                            return Container(
                              width: 450,
                              color:  Colors.white,
                              child: Center(child: Image.asset(
                                "assets/favicon-32x32.png",
                              ),),
                            );
                          }),
                      Expanded(
                        child: Center(
                          child: GoToDetailsButton(
                            alertContext: null,
                            weddingID: weddingID,
                            onTapped: onTapped,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            );

  }
}
