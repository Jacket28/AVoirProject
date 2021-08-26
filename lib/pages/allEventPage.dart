import 'package:a_voir_app/pages/EventPage.dart';
import 'package:a_voir_app/pages/filterPage.dart';
import 'package:a_voir_app/ui/appBar.dart';
import 'package:a_voir_app/ui/drawerMenu.dart';
import 'package:a_voir_app/ui/bottomAppBar.dart';

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

  String user = "";

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
          body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextButton(
                          child: Container(
                            height: 50,
                            width: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: new BorderRadius.circular(25.0),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  //Will be used later to take part the event
                                  Container(
                                      child: new Text(
                                    "Filter",
                                    style: TextStyle(
                                        color: Color(0xffa456a7),
                                        fontSize: 20.0),
                                  ))
                                ],
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FilterPage()));
                          },
                        ),
                        _getEvents(context),
                      ],
                    ),
                  ),
                ),
                _addButton(context),
              ],
            );
          }),
        ));
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
        listofEvents.add(Center(
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventPage(eventId: result.id)),
                  );
                },
                child: Container(
                    alignment: Alignment.topCenter,
                    width: 500,
                    height: 300,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xff643165),
                      border: Border.all(color: Colors.white),
                      shape: BoxShape.rectangle,
                      borderRadius: new BorderRadius.circular(25.0),
                    ),
                    child: Column(children: [
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Text(
                        result.get("title"),
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        width: 300,
                        height: 200,
                        child: Transform.scale(
                          scale: 1,
                          child: Image.network(result.get("url")),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      Text(
                        result.get("city"),
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Text(
                        result.get("date"),
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ])))));
      });
    });
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
            if (snapshot.hasData) {
              this.user = snapshot.data!.getString('userId')!;
              if (snapshot.data!.getBool('isProvider')!) {
                return _addButtonVisible(context);
              }
            }
          }

          return Container(color: Colors.transparent);
        },
      ),
    );
  }

  Future<SharedPreferences> _setreferences(BuildContext context) async {
    return await SharedPreferences.getInstance();
  }

  Widget _addButtonVisible(BuildContext context) {
    return Container(height: 100, width: 600, child: BottomNavBarV2());
  }
}
