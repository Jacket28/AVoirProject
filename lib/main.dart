import 'package:a_voir_app/pages/allEventPage.dart';
import 'package:a_voir_app/ui/appBar.dart';
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
    return FutureBuilder(builder: (context, snapshot) {
      _setreferences(context);
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            body: AllEventPage()),
      );
    });
  }

  Future<Null> _setreferences(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    //prefs.setString('userId', "c6RD1pqb43Iu57xnHniQ");
    prefs.setString('userId', "kajdfhasdbhafdkh");
    prefs.setBool('isProvider', false);
  }
}
