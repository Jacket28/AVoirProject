import 'package:a_voir_app/localization/language_constants.dart';
import 'package:a_voir_app/ui/appBar.dart';
import 'package:a_voir_app/ui/drawerMenu.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//This class is used to display all the events that are in the DB.
class AboutPage extends StatefulWidget {
  @override
  AboutState createState() => AboutState();
}

class AboutState extends State<AboutPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: FirebaseAuth.instance.currentUser != null
            ? BaseAppBar(appBar: AppBar(), scaffoldKey: _scaffoldKey)
            : null,
        endDrawer: DrawerMenu(),
        backgroundColor: Color(0xff643165),
        body: Center(
          child: Column(
            children: [
              FirebaseAuth.instance.currentUser != null
                  ? Padding(
                      padding: EdgeInsets.only(top: 20),
                    )
                  : Padding(
                      padding: EdgeInsets.only(top: 100),
                    ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Image.asset(
                  "assets/images/logoAll.png",
                  height: 200,
                  width: 200,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 40),
              ),
              Container(
                height: 100,
                width: 300,
                child: Text(
                  getTranslated(context, 'application_resume')!,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Text(getTranslated(context, 'dev_team')!,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              Padding(
                padding: EdgeInsets.only(top: 5),
              ),
              Text(
                  " - Kevin Coppey (Scrum Master) \n - Albain Dufils \n - Valentin Haenggeli \n - Robin Gallay \n - Mathieu Kohl",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Text(getTranslated(context, 'product_owner')!,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              Padding(
                padding: EdgeInsets.only(top: 5),
              ),
              Text("Gaetano Manzo",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Text(getTranslated(context, 'prof_in_charge')!,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              Padding(
                padding: EdgeInsets.only(top: 5),
              ),
              Text("Michaël Schumacher",
                  style: TextStyle(color: Colors.white, fontSize: 20))
            ],
          ),
        ));
  }
}
