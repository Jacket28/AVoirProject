import 'dart:html';

import 'package:a_voir_app/pages/allEventPage.dart';
import 'package:a_voir_app/pages/loginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'translations.dart';

//This page is the initialization page which call the first page of the app (allEventPage).
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //late Locale _locale;
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
            page = LoginPage();
          }
          return MaterialApp(
              //locale: _locale,
              localizationsDelegates: [
                const TranslationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                Locale('en', 'US'), // English
                Locale('fr', 'FR'), // French
              ],
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                for (var locale in supportedLocales) {
                  if (locale.languageCode == deviceLocale!.languageCode &&
                      locale.countryCode == deviceLocale.countryCode) {
                    return deviceLocale;
                  }
                }
                return supportedLocales.first;
              },
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                key: _scaffoldKey,
                resizeToAvoidBottomInset: false,
                body: page,
              ));
        });
  }

  Future<SharedPreferences> _testRefs(BuildContext context) async {
    return await SharedPreferences.getInstance();
  }
}
