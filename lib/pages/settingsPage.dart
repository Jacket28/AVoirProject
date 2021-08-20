import 'package:a_voir_app/ui/appBar.dart';
import 'package:a_voir_app/ui/drawerMenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'feedbackPage.dart';

class SettingsPage extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<SettingsPage> {
  String dropdownvalue = 'English';
  var items = ['English', 'French'];

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
              child: Text(
                'Language : ',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.0,
                    color: Color(
                      0xffffffff,
                    )),
              ),
            )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
              ),
              width: 117,
              child: DropdownButton(
                value: dropdownvalue,
                dropdownColor: Colors.white,
                focusColor: Colors.white,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                ),
                items: items.map((String items) {
                  return DropdownMenuItem(value: items, child: Text(items));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                },
              ),
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
                'If you notice a bug, please notify us :)',
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
