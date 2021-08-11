import 'package:a_voir_app/pages/allEventPage.dart';
import 'package:a_voir_app/ui/appBar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            //the appBar is created upon reusable widget which is called appBar.dart.
            appBar: BaseAppBar(
              appBar: AppBar(),
              scaffoldKey: _scaffoldKey,
            ),
            body: AllEventPage()),
      );
    });
  }
}
