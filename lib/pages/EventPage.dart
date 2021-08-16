import 'package:a_voir_app/models/MyEvent.dart';
import 'package:a_voir_app/pages/addEventPage.dart';
import 'package:a_voir_app/ui/appBar.dart';
import 'package:a_voir_app/ui/drawerMenu.dart';
import 'package:a_voir_app/ui/myTooltip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'allEventPage.dart';

//This page is used to display information about a specific event.
class EventPage extends StatefulWidget {
  const EventPage({required this.eventId});

  final String eventId;

  @override
  EventState createState() => EventState(eventId);
}

class EventState extends State<EventPage> {
  //The scaffoldKey will be used later for the burger menu
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  SharedPreferences? prefs;

  String eventId = "";
  MyEvent myEvent = MyEvent(
    title: "",
    description: "",
    address: "",
    npa: "",
    city: "",
    date: "",
    time: "",
    provider: "",
  );
  String user = "";

  EventState(String eventId) {
    this.eventId = eventId;
  }

  @override
  void initState() {
    _setreferences(context).whenComplete(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      //the appBar is created upon reusable widget which is called appBar.dart.
      endDrawer: DrawerMenu(),
      appBar: BaseAppBar(
        appBar: AppBar(),
        scaffoldKey: _scaffoldKey,
      ),
      backgroundColor: Color(0xffa456a7),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 10, bottom: 40)),
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    Column(children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(bottom: 50),
                        width: 380,
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
                            _addParticipateButton(context)
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
  }

  //Method used to get all the attendants of an event (will be used later with the DB)
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
                    onTap: () {},
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

  //Method used to get an event from the DB.
  Widget _getEvent(BuildContext context) {
    return Center(
        child: FutureBuilder(
      future: _selectEvent(context, eventId),
      builder: (BuildContext context, AsyncSnapshot<MyEvent> snapshot) {
        //this condition is used to handle errors
        if (snapshot.connectionState == ConnectionState.done) {
          print("Connection done");
          if (snapshot.hasData) {
            print("I have data");
            return new Column(children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    padding: EdgeInsets.only(left: 30, right: 110),
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
                  _addUpdateButton(context, snapshot.data!.provider)
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 40),
                  ),
                  Text(
                    //Creator section
                    "Creator : ",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                  ),
                  Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
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
                                user,
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
                    //Subject section
                    "Subject : ",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                  ),
                  Expanded(
                    child: Text(
                      snapshot.data!.title,
                      style: TextStyle(color: Colors.white, fontSize: 20),
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
                    //Date section
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
                    //Time section
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
                    //Location section
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
                    padding: EdgeInsets.only(left: 50, top: 40),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 20, top: 20, left: 80),
                    child: Text(
                      //description section
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
                    padding: EdgeInsets.only(left: 50, top: 30),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20, bottom: 20, left: 80),
                    child: Text(
                      //attendants section
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

  //Method used to display information about a specific event regarding the one clicked in the menu.
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

    final DocumentSnapshot<Map<String, Object?>> user = await FirebaseFirestore
        .instance
        .collection("users")
        .doc(myEvent.provider)
        .get();

    print(this.user = user.data()!['username'] as String);

    return myEvent;
  }

  Future<void> _setreferences(BuildContext context) async {
    this.prefs = await SharedPreferences.getInstance();
  }

  Widget _addUpdateButton(BuildContext context, String provider) {
    if (prefs!.getString('userId')!.compareTo(provider) == 0) {
      return IconButton(
        padding: EdgeInsets.only(left: 120),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEventPage(myEvent)),
          );
        },
        icon: Image.asset(
          "assets/images/pen.png",
          height: 100,
          width: 100,
        ),
      );
    }
    return Container();
  }

  Widget _addParticipateButton(BuildContext context) {
    if (!prefs!.getBool('isProvider')!) {
      return TextButton(
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
                    "Participate",
                    style: TextStyle(color: Color(0xffa456a7), fontSize: 20.0),
                  ))
                ],
              ),
            ),
          ),
          onPressed: () async {
            bool isAttending = await isAlreadyParticipating();
            if (!isAttending) {
              //Participate button action
              showParticipateAlertDialog(context);
            } else {
              MyTooltip(
                message: "You're already in this event !",
                child: Container(),
              );
            }
          });
    }
    return Container();
  }

  Future<bool> isAlreadyParticipating() async {
    User user = await FirebaseAuth.instance.currentUser!;
    var uidConnectedUser = user.uid;

    String username = await getUsername();

    bool alreadyParticipating = false;

    var collection = FirebaseFirestore.instance.collection('events');
    await collection
        .where("attendees", arrayContainsAny: [username])
        .get()
        .then((value) {
          if (alreadyParticipating == value.docs.isEmpty) {
            alreadyParticipating = true;
          }
        });

    return alreadyParticipating;
  }

  Future<String> getUsername() async {
    User user = await FirebaseAuth.instance.currentUser!;
    var uidConnectedUser = user.uid;

    String value = "";

    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(uidConnectedUser).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();

      // You can then retrieve the value from the Map like this:
      value = data?['username'];
    }
    return value;
  }

  showParticipateAlertDialog(BuildContext context) async {
    String username = await getUsername();

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel", style: TextStyle(color: Colors.red)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Approve", style: TextStyle(color: Color(0xffa456a7))),
      onPressed: () {
        var attendeesRef =
            FirebaseFirestore.instance.collection("events").doc(eventId);
        attendeesRef.update({
          "attendees": FieldValue.arrayUnion(<String>[username])
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => AllEventPage()),
            ModalRoute.withName(Navigator.defaultRouteName));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Participate"),
      content: Text(
        "Would you like to participate to this event ?",
        style: TextStyle(color: Color(0xffa456a7)),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
