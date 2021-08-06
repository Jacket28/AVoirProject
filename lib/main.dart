import 'package:a_voir_app/allEventPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (context, snapshot) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Color(0xffa456a7),
              toolbarHeight: 70,
              title: Image.asset(
                "assets/images/logoText.png",
                height: 150,
                width: 150,
              ),
              leading: Image.asset("assets/images/logo.png"),
              actions: [
                IconButton(
                    icon: Icon(Icons.menu),
                    iconSize: 40,
                    onPressed: () =>
                        _scaffoldKey.currentState?.openEndDrawer()),
              ],
            ),
            body: AllEventPage()),
      );
    });
  }
}
