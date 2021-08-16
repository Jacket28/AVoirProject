import 'package:a_voir_app/pages/addEventPage.dart';
import 'package:a_voir_app/pages/EventPage.dart';
import 'package:a_voir_app/models/MyEvent.dart';
import 'package:a_voir_app/ui/appBar.dart';
import 'package:a_voir_app/ui/drawerMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

//This class is used to display all the events that are in the DB.
class AllEventPage extends StatefulWidget {
  @override
  _AllEventState createState() => _AllEventState();
}

class _AllEventState extends State<AllEventPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          endDrawer: DrawerMenu(),
          appBar: BaseAppBar(
            appBar: AppBar(),
            scaffoldKey: _scaffoldKey,
          ),
          backgroundColor: Color(0xffa456a7),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Padding(padding: EdgeInsets.only(top: 50)),
                Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: <Widget>[
                        Column(children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(bottom: 50),
                            width: 300,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Color(0xff643165),
                              borderRadius: new BorderRadius.circular(25.0),
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 30),
                                ),
                                Text(
                                  "All events",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                _getEvents(context),
                              ],
                            ),
                          ),
                          _addButton(context),
                        ]),
                      ],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 30)),
              ],
            ),
          ),
        ));
    //);
  }

//this method is used to get all the events from the DB.
  Widget _getEvents(BuildContext context) {
    return Center(
        child: FutureBuilder(
      future: _getEvent(context),
      builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return new Column(children: snapshot.data!);
          }
        }
        return CircularProgressIndicator();
      },
    ));
  }

//This method is used to build the interface of the page based uppon the gotten events from the DB.
  Future<List<Widget>> _getEvent(BuildContext context) async {
    final CollectionReference events =
        FirebaseFirestore.instance.collection("events");

    //we store all the events into this List.
    List<Widget> listofEvents = [];

    //await is necessary to wait for the asynchronous call.
    await events.get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        listofEvents.add(new Column(children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(top: 30),
          ),
        ]));

        listofEvents.add(
          new Container(
            height: 70,
            width: 200,
            child: TextButton(
                onPressed: () {
                  print(result.id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventPage(eventId: result.id)),
                  );
                },
                child: Center(
                  child: Text(
                    result.get("title"),
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              shape: BoxShape.rectangle,
              borderRadius: new BorderRadius.circular(25.0),
            ),
          ),
        );
      });
    });
    print(listofEvents);
    await Future.delayed(Duration(seconds: 1));
    return listofEvents;
  }

  Widget _addButton(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: _setreferences(context),
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print('connection done');
            if (snapshot.hasData) {
              print('has data');
              if (snapshot.data!.getBool('isProvider')!) {
                print('is provider');
                return _addButtonVisible(context);
              }
            }
          }
          return Container();
        },
      ),
    );
  }

  Future<SharedPreferences> _setreferences(BuildContext context) async {
    return await SharedPreferences.getInstance();
  }

  Widget _addButtonVisible(BuildContext context) {
    return TextButton(
      child: Container(
        height: 50,
        width: 130,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: new BorderRadius.circular(25.0),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Image.asset('assets/images/addEvent.png',
                  height: 25.0, width: 25.0),
              Container(
                  padding: EdgeInsets.only(left: 5),
                  child: new Text(
                    "Add new ",
                    style: TextStyle(color: Color(0xffa456a7), fontSize: 20.0),
                  ))
            ],
          ),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddEventPage(new MyEvent(
                    title: "",
                    description: "",
                    address: "",
                    npa: "",
                    city: "",
                    date: "",
                    time: "",
                    provider: "",
                  ))),
        );
      },
    );
  }
}
