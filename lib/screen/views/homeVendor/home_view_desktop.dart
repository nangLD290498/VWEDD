import 'package:flutter/material.dart';
import 'package:wedding_guest/model/vendor.dart';
import 'package:wedding_guest/screen/views/allvendor/all_vendor_page.dart';
import 'package:wedding_guest/screen/widgets/menu_item.dart';
import 'package:wedding_guest/screen/widgets/constant.dart';
import 'package:wedding_guest/util/hex_color.dart';

class HomeViewDesktop extends StatelessWidget {
  final ValueChanged<Vendor> onTapped;
  final ValueChanged<bool> onAdd;
  final ValueChanged<bool> onHome;
  HomeViewDesktop({Key key, this.onTapped, this.onAdd, this.onHome})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width  of our screen
    return Scaffold(
      body: Container(
        height: size.height,
        // it will take full width
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(46),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, -2),
                    blurRadius: 30,
                    color: Colors.black.withOpacity(0.16),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  Image.asset(
                    "images/logo.png",
                    height: 25,
                    alignment: Alignment.topCenter,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "VWED".toUpperCase(),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  MenuItem(
                    title: "Home",
                    press: () {},
                      
                  ),
                  MenuItem(
                    title: "Vendor",
                    press: () {
                      this.onHome(false);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AllVendorPage(onAdd: this.onAdd,onTapped: this.onTapped,)),
                      );
                    },
                  ),
                  MenuItem(
                    title: "Logout",
                    press: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Wedding".toUpperCase(),
                      style: Theme.of(context).textTheme.headline1.copyWith(
                            color: kTextcolor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      "Manage all vendor in Vwed application",
                      style: TextStyle(
                        fontSize: 21,
                        color: kTextcolor.withOpacity(0.34),
                      ),
                    ),
                    FittedBox(
                      // Now it just take the required spaces
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: hexToColor("#d86a77"),
                          borderRadius: BorderRadius.circular(34),
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                              height: 38,
                              width: 38,
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: hexToColor("#d86a77"),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Text(
                              "Start manage".toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                              ),
                            ),
                            SizedBox(width: 15),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Spacer(
              flex: 2,
            ),
            // it will cover 2/3 of free spaces
          ],
        ),
      ),
    );
  }
}
