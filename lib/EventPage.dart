import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  @override
  EventState createState() => EventState();
}

class EventState extends State<EventPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
                            Row(
                              children: <Widget>[
                                IconButton(
                                  padding: EdgeInsets.only(left: 20, right: 80),
                                  onPressed: () {},
                                  icon: Image.asset(
                                    "assets/images/share.png",
                                    height: 100,
                                    width: 100,
                                  ),
                                ),
                                Text(
                                  "Event X",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                IconButton(
                                  padding: EdgeInsets.only(left: 80),
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
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
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10)),
                                            Text(
                                              "Albain Dufils",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                ),
                                Text(
                                  "XXXX",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 45),
                                ),
                                Text(
                                  "XXXX",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 41),
                                ),
                                Text(
                                  "XXXX",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 20, top: 40),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 80),
                                  child: Text(
                                    "Description : ",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
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
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Text(
                                    "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ]),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 20, top: 50),
                                ),
                                Text(
                                  "Location : ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                ),
                                Text(
                                  "XXXX",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 20, top: 20),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 80),
                                  child: Text(
                                    "Attendants : ",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
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
                            getAttendants()
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
                          Padding(padding: EdgeInsets.only(left: 10, top: 50)),
                          Text(
                            "Robin Gallay",
                            style: TextStyle(color: Colors.white, fontSize: 20),
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
