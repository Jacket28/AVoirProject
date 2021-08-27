import 'package:a_voir_app/pages/EventPage.dart';
import 'package:a_voir_app/pages/allEventPage.dart';
import 'package:a_voir_app/ui/appBar.dart';
import 'package:a_voir_app/ui/drawerMenu.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

//This class is used to display all the events that are in the DB.
class FilterEventPage extends StatefulWidget {
  FilterEventPage(this.provider, this.date, this.city, this.user);

  final String provider;
  final String date;
  final String city;
  final String user;

  @override
  _FilterEventState createState() =>
      _FilterEventState(provider, date, city, user);
}

class _FilterEventState extends State<FilterEventPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _FilterEventState(String provider, String date, String city, String user) {
    this.provider = provider;
    this.date = date;
    this.city = city;
    this.user = user;
  }

  String provider = "";
  String date = "";
  String city = "";
  String user = "";

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => true,
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
                                    "Supress filters",
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
                                    builder: (context) => AllEventPage()));
                          },
                        ),
                        _getEvents(context),
                      ],
                    ),
                  ),
                ),
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
    CollectionReference events =
        FirebaseFirestore.instance.collection("events");

    Query query = events;

    if (city != "") {
      query = query.where('city', isEqualTo: city);
    }

    if (date != "") {
      query = query.where('date', isEqualTo: date);
    }

    if (provider != "") {
      final users = await FirebaseFirestore.instance
          .collection("users")
          .where('username', isEqualTo: provider)
          .get();
      query = query.where('provider', isEqualTo: users.docs.first.id);
    }

    if (user != "") {
      query = query.where('attendees', arrayContains: user);
    }

    //we store all the events into this List.
    List<Widget> listofEvents = [];

    //await is necessary to wait for the asynchronous call.
    await query.get().then((querySnapshot) {
      if (querySnapshot.size == 0) {
        //return Text('No event is corresponding to the filters');
        listofEvents.add(Container(
            padding: EdgeInsets.only(top: 20),
            child: new Text('No event is corresponding to the filters',
                style: TextStyle(color: Colors.white, fontSize: 20.0))));
      }
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
}
