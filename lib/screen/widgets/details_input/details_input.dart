import 'package:flutter/material.dart';
import 'package:wedding_guest/model/guest.dart';
import 'package:wedding_guest/screen/widgets/details_input/choose_to_come.dart';
import 'package:wedding_guest/screen/widgets/details_input/submit_button.dart';
import 'package:wedding_guest/screen/widgets/details_input/text_field.dart';
import 'package:wedding_guest/util/globle_variable.dart';

class DetailsInput extends StatelessWidget {
  Guest guest;
  String weddingID;
  ValueChanged<bool> onTapped;
  DetailsInput({Key key, @required this.onTapped, @required this.guest,@required this.weddingID}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    guestToUpdate =guest;
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text("Bạn hãy điền những thông tin sau đây nhé",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),),
              SizedBox(height: 50,),
              TextFieldCustom(hintText: "Tên của bạn", maxlines: 1,
                initialText: guest.name,length: 20,allowEmpty: false,),
              SizedBox(height: 15,),
              ChooseToCome(guest: guest),
              SizedBox(height: 15,),
              TextFieldCustom(hintText: "Gửi lời chúc", maxlines: 4,
                initialText: guest.congrat, length: 150,allowEmpty: true,),
              SizedBox(height: 30,),
              SubmitButtonCustom(onTapped: onTapped,formKey: _formKey,weddingID: weddingID,),
            ],
          ),
        ),
      ),
    );
  }
}
