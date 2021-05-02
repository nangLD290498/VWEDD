import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_guest/bloc/guests/bloc.dart';
import 'package:wedding_guest/bloc/invitation/bloc.dart';
import 'package:wedding_guest/bloc/invitation/invitation_bloc.dart';
import 'package:wedding_guest/bloc/invitation/invitation_bloc.dart';
import 'package:wedding_guest/bloc/invitation/invitation_bloc.dart';
import 'package:wedding_guest/bloc/invitation/invitation_bloc.dart';
import 'package:wedding_guest/model/guest.dart';
import 'package:wedding_guest/screen/widgets/image_show/image_show.dart';
import 'package:wedding_guest/screen/widgets/phone_input/phone_input.dart';

class HomeViewTabletMobile extends StatelessWidget {
  String weddingID;
  ValueChanged<Guest> onTapped;
  HomeViewTabletMobile(
      {Key key, @required this.weddingID, @required this.onTapped})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: Icon(Icons.apps),
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => new AlertDialog(
                                    content: GoToDetailsButton(
                                      alertContext: context,
                                      weddingID: weddingID,
                                      onTapped: onTapped,
                                    ),
                                    actions: [
                                      FlatButton(
                                          child: Text('Hủy'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          }),
                                    ],
                                  ));
                        }),
                    Text(
                      "Nhấp vào đây",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      BlocBuilder(
                          cubit: BlocProvider.of<InvitationBloc>(context),
                          builder: (context, state) {
                            if (state is InvitationCardLoaded)
                              return Container(
                                constraints: BoxConstraints(maxWidth: 300),
                                decoration: BoxDecoration(
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
                            return Container();
                          }),
                    ],
                  ),
                )
              ],
            );
  }
}
