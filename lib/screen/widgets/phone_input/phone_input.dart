import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_guest/bloc/guests/bloc.dart';
import 'package:wedding_guest/firebase_repository/guest_firebase_repository.dart';
import 'package:wedding_guest/firebase_repository/notification_firebase_repository.dart';
import 'package:wedding_guest/model/guest.dart';

class GoToDetailsButton extends StatelessWidget {
  String _phone = "";
  bool isExisting;
  var alertContext;
  String weddingID;
  ValueChanged<Guest> onTapped;
  GoToDetailsButton({this.alertContext,@required this.weddingID,this.onTapped});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //state = BlocProvider.of<GuestsBloc>(context).state;
    return BlocProvider(
      create: (BuildContext context) => GuestsBloc(
        guestsRepository: FirebaseGuestRepository(),
        notificationRepository: NotificationFirebaseRepository(),
      )..add(LoadGuests(weddingID)),
      child: Builder(
        builder: (context) => BlocBuilder(
          cubit: BlocProvider.of<GuestsBloc>(context),
          builder: (context, state) =>SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text("Nhập số điện thoại của bạn để bắt đầu trả lời lời mời",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(height: 50,),
                  Container(
                    constraints: BoxConstraints( maxWidth: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        autocorrect: true,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        onSaved: (input) => _phone = input,
                        validator: (value) => value.length != 10 ? 'Số điện thoại phải có 10 số': null,
                        decoration: InputDecoration(
                          hintText: 'Số điện thoại...',
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey[70],
                          suffixIcon: IconButton(
                            icon: Icon(Icons.arrow_forward, size: 30,),
                            onPressed: (){
                              final FormState form = _formKey.currentState;
                              form.save();
                              if (form.validate()) {
                                if(state is GuestsLoaded) {
                                  List<Guest> guests = state.guests;
                                  Guest guest = null;
                                  for(int i=0; i<guests.length;i++) {
                                    if(guests[i].phone == _phone) {
                                      guest = guests[i];
                                      if (alertContext != null) {
                                        Navigator.of(alertContext).pop();
                                      }
                                      onTapped(guest);
                                      return;
                                    }
                                  }
                                  _showDialog(context);
                                }
                              }
                            },
                          ),
                        ),),
                    ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(5),
                      ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

   _showDialog(context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
        new AlertDialog(
          title: Text('Thông báo: ', style: TextStyle(fontWeight: FontWeight.bold),),
          content: Text("Số điện thoại không đúng"),
          actions: [
            FlatButton(
                child: Text('Quay Lại'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        )
    );
  }
}
