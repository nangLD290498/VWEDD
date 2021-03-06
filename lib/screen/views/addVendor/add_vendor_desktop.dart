
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_guest/bloc/vendor/bloc.dart';
import 'package:wedding_guest/bloc/category/bloc.dart';
import 'package:wedding_guest/model/vendor.dart';
import 'package:wedding_guest/model/category.dart';
import 'package:wedding_guest/util/hex_color.dart';
import 'package:wedding_guest/util/show_snackbar.dart';
import 'package:wedding_guest/screen/widgets/confirm_dialog.dart';
import 'package:wedding_guest/screen/widgets/loading_indicator.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class AddVendorDesktopPage extends StatefulWidget {
  @override
  _AddVendorDesktopPageState createState() => _AddVendorDesktopPageState();
}

// Future<String> loadData() async {
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   return preferences.getString(nameKey);
// }
class _AddVendorDesktopPageState extends State<AddVendorDesktopPage> {
  final numRegex = RegExp(r'^[^a-zA-Z\,!@#$%^&*()_+=-]+$');
  final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  var storage = FirebaseStorage.instance;
  CateBloc _cateBloc;
  Category holder;
  Category selectedCate;
  List<Category> _values2 = [];
  String vendorId = "";
  String frontImageUrl = '';
  String ownerImageUrl = '';
  Category initialCate = new Category("", "");
  TextEditingController vendorNameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController labelController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController frontImageController = new TextEditingController();
  TextEditingController ownerImageController = new TextEditingController();
  List<Uint8List> _frontImageData = [];
  List<Uint8List> _ownerImageData = [];
  List<String> _frontImageName = [];
  List<String> _ownerImageName = [];
  bool uploading = false;
  final picker = ImagePicker();
  SharedPreferences sharedPrefs;
  final _formkey = GlobalKey<FormState>();
  static const _locale = 'en';

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(double.parse(s));

  @override
  void initState() {
    super.initState();
    _cateBloc = BlocProvider.of<CateBloc>(context);

    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      vendorId = "";
      vendorNameController.text = "";
      descriptionController.text = "";
      emailController.text = "";
      labelController.text = "";
      locationController.text = "";
      phoneController.text = "";
      //holder = Category(widget.vendor.cateID, "");
    });
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CateBloc>(context).add(LoadTodos());
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    int maxLines = 3;

    return BlocBuilder(
        cubit: BlocProvider.of<VendorBloc>(context),
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                leading: Icon(
                  Icons.add_alarm_outlined,
                  color: hexToColor("#d86a77"),
                ),
                backgroundColor: hexToColor("#d86a77"),
                bottomOpacity: 0.0,
                elevation: 0.0,
                title: Center(child: Text("Th??m d???ch v???")),
                actions: [
                  Builder(
                      builder: (ctx) => Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.check,
                                  size: 35,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) =>
                                          PersonDetailsDialog(
                                            message: "B???n ??ang th??m d???ch v???",
                                            onPressedFunction: () {
                                              updateVendor();
                                            },
                                          ));
                                },
                              ),
                            ],
                          )),
                ],
              ),
              body: Padding(
                padding: EdgeInsets.fromLTRB(
                    queryData.size.width * 5 / 20,
                    queryData.size.height / 40,
                    queryData.size.width * 5 / 20,
                    0),
                child: Center(
                    child: SingleChildScrollView(
                        child: SizedBox(
                  height: queryData.size.height,
                  width: queryData.size.width,
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextFormField(
                                controller: vendorNameController,
                                validator: (val) {
                                  if (val == "") {
                                    showFailedSnackbar(context,
                                        "Xin Vui L??ng Nh???p T??n D???ch V???");
                                    return "T??n D???ch V??? kh??ng ???????c ????? tr???ng";
                                  } else if (val.length > 40) {
                                    showFailedSnackbar(context,
                                        "Xin Vui L??ng Nh???p T??n D???ch V??? D?????i 40 K?? T???");
                                    return "T??n D???ch V??? ch??? ???????c d?????i 40 k?? t???";
                                  }
                                  return null;
                                },
                                decoration: new InputDecoration(
                                    labelText: 'T??n D???ch V???',
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2.0),
                                    ),
                                    hintText: 'T??n D???ch V???')),
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Container(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, bottom: 20),
                                  width: queryData.size.width / 4,
                                  child: TextFormField(
                                      controller: labelController,
                                      validator: (val) {
                                        if (val == "") {
                                          showFailedSnackbar(context,
                                              "Xin Vui L??ng Nh???p Nh??n Hi???u ");
                                          return "Nh??n Hi???u kh??ng ???????c ????? tr???ng";
                                        } else if (val.length > 40) {
                                          showFailedSnackbar(context,
                                              "Xin Vui L??ng Nh???p Nh??n Hi???u D?????i 40 K?? T???");
                                          return "Nh??n Hi???u ch??? ???????c d?????i 40 k?? t???";
                                        }
                                        return null;
                                      },
                                      decoration: new InputDecoration(
                                        labelText: 'Nh??n Hi???u',
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blue, width: 2.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 2.0),
                                        ),
                                        hintText: 'Nh??n Hi???u',
                                      ))),
                              Container(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, bottom: 20),
                                  width: queryData.size.width / 4,
                                  child: TextFormField(
                                      controller: phoneController,
                                      validator: (val) {
                                        if (val == "") {
                                          showFailedSnackbar(context,
                                              "Xin Vui L??ng Nh???p S??? ??i???n Tho???i");
                                          return "S??? ??i???n tho???i kh??ng ???????c ????? tr???ng";
                                        } else if (!numRegex.hasMatch(val)) {
                                          showFailedSnackbar(context,
                                              "Xin vui l??ng nh???p s??? ??i???n tho???i ch??? g???m c??c ch??? s???");
                                          return "S??? ??i???n tho???i ch??? ???????c ph??p c?? s???";
                                        } else if (val.length != 10) {
                                          showFailedSnackbar(context,
                                              "Xin vui l??ng nh???p s??? ??i???n tho???i g???m 10 ch??? s???");
                                          return "S??? ??i???n tho???i ch??? ???????c ph??p c?? 10 ch??? s???";
                                        }
                                        return null;
                                      },
                                      decoration: new InputDecoration(
                                        labelText: 'S??? ??i???n tho???i',
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blue, width: 2.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 2.0),
                                        ),
                                        hintText: 'S??? ??i???n tho???i',
                                      ))),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          child: TextFormField(
                              controller: emailController,
                              validator: (val) {
                                if (val == "") {
                                  showFailedSnackbar(
                                      context, "Xin Vui L??ng Nh???p email");
                                  return "Email kh??ng ???????c ????? tr???ng";
                                } else if (!emailRegex.hasMatch(val)) {
                                  showFailedSnackbar(
                                      context, "Email kh??ng h???p l???");
                                  return "Email kh??ng h???p l???";
                                }else if (val.length > 36) {
                                    showFailedSnackbar(context,
                                        "Xin Vui L??ng Nh???p Email D?????i 36 K?? T???");
                                    return "Email ch??? ???????c d?????i 36 k?? t???";
                                  }
                                return null;
                              },
                              decoration: new InputDecoration(
                                  labelText: 'Email',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                  ),
                                  hintText: 'Email')),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 2)),
                            child: BlocBuilder(
                              cubit: _cateBloc,
                              builder: (context, state) {
                                if (state is TodosLoaded) {
                                  _values2 = state.cates;

                                  return DropdownButtonFormField(
                                    value: selectedCate,
                                    icon: Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    isExpanded: true,
                                    style: TextStyle(color: Colors.deepPurple),
                                    items: _values2.map((Category cate) {
                                      return DropdownMenuItem<Category>(
                                        value: cate,
                                        child: Text(cate.cateName),
                                      );
                                    }).toList(),
                                    onChanged: (val) =>
                                        setState(() => selectedCate = val),
                                    onSaved: (val) => selectedCate = val,
                                    validator: (val) {
                                      if (val == null) {
                                        showFailedSnackbar(context,
                                            "Xin Vui L??ng Ch???n Lo???i D???ch V???");
                                        return "Lo???i d???ch v??? kh??ng ???????c ????? tr???ng";
                                      }
                                      return null;
                                    },
                                  );
                                } else if (state is TodosLoading) {
                                  return LoadingIndicator();
                                } else if (state is TodosNotLoaded) {}
                                return LoadingIndicator();
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: TextFormField(
                              controller: locationController,
                              validator: (val) {
                                if (val == "") {
                                  showFailedSnackbar(
                                      context, "Xin Vui L??ng Nh???p ?????a Ch???");
                                  return "?????a ch??? kh??ng ???????c ????? tr???ng";
                                }else if (val.length > 100) {
                                    showFailedSnackbar(context,
                                        "Xin Vui L??ng Nh???p Mi??u T??? D?????i 100 K?? T???");
                                    return "Mi??u t??? ch??? ???????c d?????i 100 k?? t???";
                                  }
                                return null;
                              },
                              decoration: new InputDecoration(
                                  labelText: '?????a ch???',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                  ),
                                  hintText: '?????a ch???')),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 20),
                          child: TextFormField(
                              controller: descriptionController,
                              validator: (val) {
                                if (val == "") {
                                  showFailedSnackbar(
                                      context, "Xin Vui L??ng Nh???p Mi??u T??? ");
                                  return "Mi??u T???  kh??ng ???????c ????? tr???ng";
                                }else if (val.length > 200) {
                                    showFailedSnackbar(context,
                                        "Xin Vui L??ng Nh???p Mi??u T??? D?????i 200 K?? T???");
                                    return "Mi??u t??? ch??? ???????c d?????i 200 k?? t???";
                                  }
                                return null;
                              },
                              decoration: new InputDecoration(
                                  labelText: 'Mi??u T???',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                  ),
                                  hintText: 'Mi??u T???')),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: _frontImageData.length == 0
                                  ? Container(
                                      child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                              width: queryData.size.width / 5,
                                              child: TextFormField(
                                                  enabled: false,
                                                  controller:
                                                      frontImageController,
                                                  decoration:
                                                      new InputDecoration(
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.blue,
                                                          width: 2.0),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 2.0),
                                                    ),
                                                    hintText: '???nh D???ch V???',
                                                  ))),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              primary: hexToColor("#d86a77")),
                                          onPressed: () => !uploading
                                              ? chooseImage(true)
                                              : null,
                                          child: Text(
                                            'Ch???n ???nh d???ch v??? ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ))
                                  : Container(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                                width: queryData.size.width / 5,
                                                child: TextFormField(
                                                    enabled: false,
                                                    controller:
                                                        frontImageController,
                                                    decoration:
                                                        new InputDecoration(
                                                      labelText: _frontImageName
                                                                  .length ==
                                                              0
                                                          ? ""
                                                          : _frontImageName[
                                                              _frontImageName
                                                                      .length -
                                                                  1],
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.blue,
                                                            width: 2.0),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.black,
                                                            width: 2.0),
                                                      ),
                                                      hintText: '???nh D???ch V???',
                                                    ))),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                                primary: hexToColor("#d86a77")),
                                            onPressed: () => !uploading
                                                ? chooseImage(true)
                                                : null,
                                            child: Text(
                                              'Ch???n ???nh d???ch v??? ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                            )),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: _frontImageData.length == 0
                                  ? Container(
                                      child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                              width: queryData.size.width / 5,
                                              child: TextFormField(
                                                  enabled: false,
                                                  controller:
                                                      ownerImageController,
                                                  decoration:
                                                      new InputDecoration(
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.blue,
                                                          width: 2.0),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 2.0),
                                                    ),
                                                    hintText: '???nh Logo',
                                                  ))),
                                        ),
                                        TextButton(
                                          onPressed: () => !uploading
                                              ? chooseImage(true)
                                              : null,
                                          child: Text(
                                            'Ch???n ???nh Logo ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ))
                                  : Container(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                                width: queryData.size.width / 5,
                                                child: TextFormField(
                                                    enabled: false,
                                                    controller:
                                                        ownerImageController,
                                                    decoration:
                                                        new InputDecoration(
                                                      labelText: _ownerImageName
                                                                  .length ==
                                                              0
                                                          ? ""
                                                          : _ownerImageName[
                                                              _ownerImageName
                                                                      .length -
                                                                  1],
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.blue,
                                                            width: 2.0),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.black,
                                                            width: 2.0),
                                                      ),
                                                      hintText: '???nh D???ch V???',
                                                    ))),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                                primary: hexToColor("#d86a77")),
                                            onPressed: () => !uploading
                                                ? chooseImage(false)
                                                : null,
                                            child: Text(
                                              'Ch???n ???nh logo ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                            )),
                      ],
                    ),
                  ),
                ))),
              ));
        });
  }

  void chooseImage(bool type) async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    if (pickedFile != null) {
      int bytes = pickedFile.files.single.size;
      if (bytes > 5242880) {
        showMyError2Dialog(context);
      } else {
        if (type) {
          setState(() {
            _frontImageData.add(pickedFile.files.single.bytes);
            _frontImageName.add(pickedFile.files.single.name);
          });
          Uint8List frontImagedata =
              _frontImageData[_frontImageData.length - 1];
          String frontImageName = _frontImageName[_frontImageName.length - 1];
          TaskSnapshot frontSnapshot = await storage
              .ref('vendor/$frontImageName')
              .putData(frontImagedata);
          frontImageUrl = await frontSnapshot.ref.getDownloadURL();
        } else {
          setState(() {
            _ownerImageData.add(pickedFile.files.single.bytes);
            _ownerImageName.add(pickedFile.files.single.name);
          });
          Uint8List ownerImagedata =
              _ownerImageData[_ownerImageData.length - 1];
          String ownerImageName = _ownerImageName[_ownerImageName.length - 1];
          TaskSnapshot taskSnapshot = await storage
              .ref('vendor/$ownerImageName')
              .putData(ownerImagedata);
          ownerImageUrl = await taskSnapshot.ref.getDownloadURL();
        }
      }
    }
  }

  showMyError2Dialog(BuildContext context) {
    // Create AlertDialog
    GlobalKey _containerKey = GlobalKey();
    AlertDialog dialog = AlertDialog(
      key: _containerKey,
      title: Text("???nh c?? dung l?????ng qu?? l???n"),
      content: Text("B???n c???n ch???n ???nh c?? dung l?????ng nh??? h??n 5MB"),
      actions: [
        TextButton(
            style: TextButton.styleFrom(primary: hexToColor("#d86a77")),
            child: Text("????ng"),
            onPressed: () {
              uploading = false;
              Navigator.of(_containerKey.currentContext).pop();
            }),
      ],
    );

    // Call showDialog function to show dialog.
    Future<String> futureValue = showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  void updateVendor() {
    if (_formkey.currentState.validate()) {
      bool _isSet = false;

      if (selectedCate != null &&
          selectedCate.cateName.trim().isNotEmpty &&
          labelController.text.trim().isNotEmpty &&
          vendorNameController.text.trim().isNotEmpty &&
          locationController.text.trim().isNotEmpty &&
          descriptionController.text.trim().isNotEmpty &&
          phoneController.text.trim().isNotEmpty &&
          emailController.text.trim().isNotEmpty) {
        Vendor vendor = new Vendor(
            labelController.text,
            vendorNameController.text,
            selectedCate == null ? initialCate.id : selectedCate.id,
            locationController.text,
            descriptionController.text,
            frontImageUrl,
            ownerImageUrl,
            emailController.text,
            phoneController.text);
        BlocProvider.of<VendorBloc>(context).add(AddVendor(vendor));
        Navigator.pop(context);

        _isSet = true;
      } else if (_isSet == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('c?? l???i x???y ra'),
          ),
        );
      }
    }
  }
}
