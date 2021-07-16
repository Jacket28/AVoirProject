import 'package:a_voir_app/EventPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllEventPage extends StatefulWidget {
  @override
  AllEventState createState() => AllEventState();
}

class AllEventState extends State<AllEventPage> {
  final listOfEvents = <Widget>[];

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
                            getEvents(context)
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
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
    //);
  }
}

Widget getEvents(BuildContext context) {
  List<Widget> listofEvents = [];
  for (var i = 0; i < 10; i++) {
    listofEvents.add(
      new Padding(
        padding: EdgeInsets.only(top: 30),
      ),
    );
    listofEvents.add(
      new Container(
        height: 70,
        width: 200,
        child: TextButton(
          //ACTION OF THE FIRST EVENT !
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EventPage()),
            );
          },
          child: Text(
            'Event X',
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
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
  }
  return new Column(children: listofEvents);
}
