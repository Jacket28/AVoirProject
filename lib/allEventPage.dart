import 'package:a_voir_app/addEventPage.dart';
import 'package:a_voir_app/EventPage.dart';
import 'package:a_voir_app/MyEvent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AllEventPage extends StatefulWidget {
  @override
  _AllEventState createState() => _AllEventState();
}

class _AllEventState extends State<AllEventPage> {
  @override
  Widget build(BuildContext context) {
    return
        //new WillPopScope(
        //onWillPop: () async => false,
        //child:
        new Scaffold(
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            _getEvents(context),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 30)),
            TextButton(
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
                            style: TextStyle(
                                color: Color(0xffa456a7), fontSize: 20.0),
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
                          time: ""))),
                );
              },
            ),
          ],
        ),
      ),
    );
    //);
  }
}

Widget _getEvents(BuildContext context) {
  List<Widget> listofEvents = [];
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

Future<List<Widget>> _getEvent(BuildContext context) async {
  final CollectionReference events =
      FirebaseFirestore.instance.collection("events");

  List<Widget> listofEvents = [];

  events.get().then((querySnapshot) {
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
              //ACTION OF THE FIRST EVENT !
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
