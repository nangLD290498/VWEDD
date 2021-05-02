import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_guest/bloc/authentication/authentication_event.dart';
import 'package:wedding_guest/entity/wedding_entity.dart';
import 'package:wedding_guest/firebase_repository/user_firebase_repository.dart';
import 'package:wedding_guest/firebase_repository/user_wedding_firebase_repository.dart';
import 'package:wedding_guest/model/wedding.dart';
import 'package:wedding_guest/util/admin_vendor_router_delegate.dart';
import 'package:wedding_guest/util/admin_vendor_route_information_parser.dart';
import 'bloc/wedding/bloc.dart';
import 'bloc/wedding/wedding_bloc.dart';
import 'bloc/wedding/wedding_event.dart';
import 'firebase_repository/wedding_firebase_repository.dart';
import 'package:wedding_guest/bloc/authentication/authentication_bloc.dart';
import 'package:wedding_guest/repository/user_repository.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  setPathUrlStrategy();
  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _routerDelegate = AdminVendorRouterDelegate();
  final _routeInformationParser = AdminVendorRouteInformationParser();
  
  @override
  void initState() {
    // TODO: implement initState
    //testWindowFunctions();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers:[
        BlocProvider<AuthenticationBloc>(
          create: (context) {
            return AuthenticationBloc(
              userRepository: FirebaseUserRepository(),
              userWeddingRepository: FirebaseUserWeddingRepository(),
              weddingRepository: FirebaseWeddingRepository(),
            )..add(AppStarted());
          },
        ),
      ],



      child: MaterialApp.router(
        title: 'Wedding Invitation',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Open Sans'),
        ),
        routerDelegate: _routerDelegate,
        routeInformationParser: _routeInformationParser,
      ),
    );
  }
}
