import 'dart:html';
import 'dart:io';

import 'package:a_voir_app/localization/language_constants.dart';
import 'package:a_voir_app/main.dart';
import 'package:a_voir_app/models/language.dart';
import 'package:a_voir_app/translations.dart';
import 'package:a_voir_app/ui/appBar.dart';
import 'package:a_voir_app/ui/drawerMenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'feedbackPage.dart';

class SettingsPage extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<SettingsPage> {
  Language? selectedLanguage = Language.getDefaultLanguage();

//should change the language when we click on the OnChanged
  void _changeLanguage(Language language) async {
    selectedLanguage = language;
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: FirebaseAuth.instance.currentUser != null
          ? BaseAppBar(appBar: AppBar(), scaffoldKey: _scaffoldKey)
          : null,
      endDrawer: DrawerMenu(),
      backgroundColor: Color(0xff643165),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 100),
            ),
            Container(
                child: Center(
              child: Text(getTranslated(context, 'title')!),
              //     Text(
              //   'Language : ',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //       fontSize: 20.0,
              //       color: Color(
              //         0xffffffff,
              //       )),
              // ),
            )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
            ),

            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 20),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(25),
            //     color: Colors.white,
            //   ),
            //   width: 132,
            //   child: TextButton(
            //     child: const Text(
            //       'Change lang',
            //       style: TextStyle(color: Color(0xffa456a7)),
            //     ),
            //     onPressed: () {
            //       _changeLanguage(Language.languageList()[1]);
            //     },
            //   ),
            // ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
              ),
              width: 132,
              child: DropdownButton<Language>(
                  hint: Text(selectedLanguage!.name),
                  items: Language.languageList().map((Language lang) {
                    return DropdownMenuItem<Language>(
                      value: lang,
                      child: Text(lang.name),
                    );
                  }).toList(),
                  //value: dropdownvalue,
                  underline: SizedBox(),
                  dropdownColor: Colors.white,
                  focusColor: Colors.white,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                  onChanged: (Language? newLanguage) {
                    _changeLanguage(newLanguage!);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100, bottom: 15),
              child: Center(
                child: Image.asset(
                  'assets/images/warning.png',
                  height: 80,
                  width: 80,
                ),
              ),
            ),
            Container(
                child: Center(
              child: Text(
                getTranslated(context, 'bug_notice_notify')!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.0,
                    color: Color(
                      0xffffffff,
                    )),
              ),
            )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 50),
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)),
                child: Center(
                  child: TextButton(
                    //ACTION OF THE BUTTON LOG IN :
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FeedbackPage()),
                      );
                    },

                    child: Text(
                      'Notify',
                      style:
                          TextStyle(fontSize: 20.0, color: Color(0xffa456a7)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
