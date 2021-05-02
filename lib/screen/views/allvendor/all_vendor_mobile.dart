import 'package:flutter/material.dart';
import 'package:wedding_guest/bloc/category/bloc.dart';
import 'package:wedding_guest/bloc/vendor/bloc.dart';
import 'package:wedding_guest/model/category.dart';
import 'package:wedding_guest/model/vendor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_guest/screen/views/addVendor/add_vendor_page.dart';
import 'package:wedding_guest/screen/views/vendorDetail/vendor_detail_page.dart';
import 'package:wedding_guest/util/hex_color.dart';
import 'package:search_page/search_page.dart';

class AllVendorPageMobile extends StatefulWidget {
  final ValueChanged<Vendor> onTapped;
  final ValueChanged<bool> onAdd;
   AllVendorPageMobile({Key key,@required this.onTapped,this.onAdd}) : super(key: key);
  @override
  _AllVendorPageMobileState createState() => _AllVendorPageMobileState();
}

class _AllVendorPageMobileState extends State<AllVendorPageMobile> {
  ValueChanged<Vendor> get onTapped => widget.onTapped;
  ValueChanged<bool> get onAdd => widget.onAdd;
  List<Vendor> properties = [];
  List<Category> _categorys = [];
  String _defaultChoiceIndex = "";
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  void initState() {
    _defaultChoiceIndex = "";
    BlocProvider.of<CateBloc>(context).add(LoadTodos());
    BlocProvider.of<VendorBloc>(context).add(LoadVendor());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: hexToColor("#d86a77"),
        actions: _buildActions(context),
        title: _buildTitle(context),
        leading: Icon(Icons.add_alarm_outlined,color: hexToColor("#d86a77") ,),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16,bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 32,
                    child: Stack(
                      children: [
                        BlocBuilder(
                          cubit: BlocProvider.of<CateBloc>(context),
                          builder: (context, state) {
                            if (state is TodosLoaded) {
                              _categorys = state.cates;
                            }
                            return ListView.builder(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: _categorys.length,
                                itemBuilder: (context, index) {
                                  return buildFilter(_categorys[index].cateName,
                                      _categorys[index].id);
                                });
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 28,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [
                                  Theme.of(context).scaffoldBackgroundColor,
                                  Theme.of(context)
                                      .scaffoldBackgroundColor
                                      .withOpacity(0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {

                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 24),
                    child: Text(
                      "Filters",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: BlocBuilder(
                cubit: BlocProvider.of<VendorBloc>(context),
                builder: (context, state) {
                  BlocProvider.of<VendorBloc>(context).add(LoadVendor());
                  if (state is VendorLoaded) {
                    properties = state.vendors;
                    
                  }
                  if (state is VendorLoading) {
                    return CircularProgressIndicator();
                  }
                  return ListView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    children: buildProperties(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          onAdd(true);
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddVendorPage()),
        );
        },
        label: Text('Thêm dịch vụ'),
        icon: Icon(Icons.add),
        backgroundColor: hexToColor("#d86a77"),
      ),
    );
  }

  Widget buildFilter(String filterName, String selectCate) {
    bool _visible = false;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: EdgeInsets.only(right: 6),
      child: Center(
          child: ChoiceChip(
        label: Text(
          filterName,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        selected: this._defaultChoiceIndex == selectCate,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              this._defaultChoiceIndex = selectCate;

              buildProperties();
            } else {
              this._defaultChoiceIndex = "";
            }
          });
        },
      )),
    );
  }

  List<Widget> buildProperties() {
    List<Widget> list = [];
    for (var i = 0; i < properties.length; i++) {
      
      if (properties[i].cateID.trim().toString() == _defaultChoiceIndex) {
        
        list.add(Hero(
            tag: properties[i].frontImage,
            child: buildProperty(properties[i])));
      } else if (_defaultChoiceIndex == "") {
        list.add(Hero(
            tag: properties[i].frontImage,
            child: buildProperty(properties[i])));
      }
    }
    return list;
  }

  Widget buildProperty(Vendor property) {
    return GestureDetector(
      onTap: () {
        onTapped(property);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VendorDetailPage(isEditing: true,vendor: property,)),
        );
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 24),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Container(
          height: 210,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(property.frontImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow[700],
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  width: 80,
                  padding: EdgeInsets.symmetric(
                    vertical: 4,
                  ),
                  child: Center(
                    child: Text(
                      "FOR " + property.label,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          property.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              property.location,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Icon(
                              Icons.zoom_out_map,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 4,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment = CrossAxisAlignment.center;

    return new InkWell(
      onTap: () => scaffoldKey.currentState.openDrawer(),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            const Text(
              'DỊCH VỤ',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions(context) {
    return <Widget>[
      new IconButton(
        icon: const Icon(
          Icons.search,
          color: Colors.white,
        ),
        onPressed: () {
          showSearch(
              context: context,
              delegate: 
              SearchPage<Vendor>(
                searchLabel: "Tìm Kiếm",
                barTheme: ThemeData(
                  textTheme: TextTheme(
                    title: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    hintStyle: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(color: Colors.white70, fontSize: 18),
                  ),
                  appBarTheme: AppBarTheme(
                      elevation: 0.0,
                      color: hexToColor("#d86a77")), //elevation did work
                ),
                suggestion: Center(
                  child: Text(
                    'Tìm kiếm theo tên dịch vụ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                failure: Center(
                  child: Text(
                    'Chưa có dịch vụ tìm thấy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                builder: (Vendor vendor) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: buildProperty(vendor),
                ),
                filter: (Vendor vendor) => [vendor.name],
                items: properties,
              ));
        },
      ),
    ];
  }


}
