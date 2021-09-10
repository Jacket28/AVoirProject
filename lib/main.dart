import 'package:a_voir_app/localization/app_localization.dart';
import 'package:a_voir_app/pages/allEventPage.dart';
import 'package:a_voir_app/pages/loginPage.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

//This page is the initialization page which call the first page of the app (allEventPage).
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(locale);
  }

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  //scaffoldKey will be used later for the burger menu
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    //FutureBuilder is created for using asynchronous calls since we have a fireBase databse.
    return FutureBuilder(
        future: _testRefs(context),
        builder:
            (BuildContext context, AsyncSnapshot<StatefulWidget> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return MaterialApp(
                  localizationsDelegates: [
                    AppLocalization.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  //supported languages
                  locale: _locale,
                  supportedLocales: [
                    Locale('en', 'US'), // English
                    Locale('fr', 'FR'), // French
                  ],

                  //to check if the local codes are the same to the device codes
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
                    body: snapshot.data!,
                  ));
            }
          }
          return CircularProgressIndicator();
        });
  }

  Future<StatefulWidget> _testRefs(BuildContext context) async {
    final instance = await SharedPreferences.getInstance();
    if (instance.getString('userId') != null) {
      return AllEventPage();
    } else {
      return LoginPage();
    }
  }
}
