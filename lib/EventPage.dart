import 'package:a_voir_app/MyEvent.dart';
import 'package:a_voir_app/addEventPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  const EventPage({required this.eventId});

  final String eventId;

  @override
  EventState createState() => EventState(eventId);
}

class EventState extends State<EventPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String eventId = "";
  MyEvent myEvent = MyEvent(
      title: "",
      description: "",
      address: "",
      npa: "",
      city: "",
      date: "",
      time: "");

  EventState(String eventId) {
    this.eventId = eventId;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xffa456a7),
        toolbarHeight: 70,
        title: Image.asset(
          "assets/images/logoText.png",
          height: 150,
          width: 150,
        ),
        leading: Image.asset("assets/images/logo.png"),
        actions: [
          IconButton(
              icon: Icon(Icons.menu),
              iconSize: 40,
              onPressed: () => _scaffoldKey.currentState?.openEndDrawer()),
        ],
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
                            _getEvent(context),
                            Padding(
                              padding: EdgeInsets.only(top: 30),
                            ),
                            TextButton(
                                child: Container(
                                  height: 50,
                                  width: 140,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.white,
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                            //padding: EdgeInsets.only(left: 4),
                                            child: new Text(
                                          "Edit this event",
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
                                        builder: (context) =>
                                            AddEventPage(myEvent)),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 30)),
          ],
        ),
      ),
    );
    //);
  }

  Widget getAttendants() {
    List<Widget> listofAttendants = [];

    for (var i = 0; i < 3; i++) {
      listofAttendants.add(Row(children: <Widget>[
        Expanded(
          child: Container(
              padding: EdgeInsets.only(left: 70),
              child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      print("salut");
                    },
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Row(children: <Widget>[
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                  "https://cdn.icon-icons.com/icons2/1812/PNG/512/4213460-account-avatar-head-person-profile-user_115386.png"),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 10, top: 50)),
                            Text(
                              "Robin Gallay",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ))),
        ),
      ]));
    }
    return new Column(children: listofAttendants);
  }

  Widget _getEvent(BuildContext context) {
    return Center(
        child: FutureBuilder(
      future: _selectEvent(context, eventId),
      builder: (BuildContext context, AsyncSnapshot<MyEvent> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          print("Connection done");
          if (snapshot.hasData) {
            print("I have data");
            return new Column(children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    padding: EdgeInsets.only(left: 30, right: 80),
                    onPressed: () {},
                    icon: Image.asset(
                      "assets/images/share.png",
                      height: 100,
                      width: 100,
                    ),
                  ),
                  Text(
                    'Event',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  IconButton(
                    padding: EdgeInsets.only(left: 70),
                    onPressed: () {},
                    icon: Image.asset(
                      "assets/images/pen.png",
                      height: 100,
                      width: 100,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 40),
                  ),
                  Text(
                    "Creator : ",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                  ),
                  Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          print("salut");
                        },
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(
                                    "https://cdn.icon-icons.com/icons2/1812/PNG/512/4213460-account-avatar-head-person-profile-user_115386.png"),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10)),
                              Text(
                                "Albain Dufils",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 40),
                  ),
                  Text(
                    "Subject : ",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                  ),
                  Text(
                    snapshot.data!.title,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 40),
                  ),
                  Text(
                    "Date : ",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 45),
                  ),
                  Text(
                    snapshot.data!.date,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 40),
                  ),
                  Text(
                    "Time : ",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 41),
                  ),
                  Text(
                    snapshot.data!.time,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 50),
                  ),
                  Text(
                    "Location : ",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                  ),
                  Expanded(
                    child: Text(
                      snapshot.data!.address +
                          ", " +
                          snapshot.data!.npa +
                          " " +
                          snapshot.data!.city,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 40),
                  ),
                  Container(
                    //padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Description : ",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                  ),
                ],
              ),
              Row(children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 10),
                    child: Text(
                      snapshot.data!.description,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ]),

              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 30),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 80),
                    child: Text(
                      "Attendants : ",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              //getAttendants()
            ]);
          }
          print("I have no data");
          return CircularProgressIndicator();
        }
        print("Connection failed");
        return DotsIndicator(dotsCount: 3);
      },
    ));
  }

  Future<MyEvent> _selectEvent(BuildContext context, String eventId) async {
    final DocumentSnapshot<Map<String, Object?>> event = await FirebaseFirestore
        .instance
        .collection("events")
        .doc(eventId)
        .get();

    final Map<String, Object?>? document = event.data();

    print(document);

    myEvent = MyEvent.fromJson(document!);
    myEvent.id = eventId;

    return myEvent;
  }
}
