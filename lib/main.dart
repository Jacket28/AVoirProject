import 'package:a_voir_app/pages/allEventPage.dart';
import 'package:a_voir_app/pages/loginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//This page is the initialization page which call the first page of the app (allEventPage).
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //scaffoldKey will be used later for the burger menu
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    //FutureBuilder is created for using asynchronous calls since we have a fireBase databse.
    return FutureBuilder(
        future: _testRefs(context),
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          var page;
          if (snapshot.data!.getString('userId') != null) {
            page = AllEventPage();
          } else {
            print('no user detected');
            page = LoginPage();
          }
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                key: _scaffoldKey,
                resizeToAvoidBottomInset: false,
                body: page,
              ));
        });
  }

  Future<SharedPreferences> _testRefs(BuildContext context) async {
    return SharedPreferences.getInstance();
  }
}
