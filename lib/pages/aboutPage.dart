import 'package:a_voir_app/pages/EventPage.dart';
import 'package:a_voir_app/ui/appBar.dart';
import 'package:a_voir_app/ui/drawerMenu.dart';
import 'package:a_voir_app/ui/bottomAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                  "This application has been created as part of the module 645-2 at the University of Applied Sciences Western Switzerland.",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Text("DEV Team",
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
              Text("Product Owner",
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
              Text("Professor in charge",
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
