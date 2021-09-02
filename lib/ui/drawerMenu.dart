import 'package:a_voir_app/pages/aboutPage.dart';
import 'package:a_voir_app/pages/allEventPage.dart';
import 'package:a_voir_app/pages/filterEventPage.dart';
import 'package:a_voir_app/pages/filterPage.dart';
import 'package:a_voir_app/pages/loginPage.dart';
import 'package:a_voir_app/pages/settingsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//This class is used as a reusable component to display the appBar.
class DrawerMenu extends StatelessWidget implements PreferredSizeWidget {
  String uidConnectedUser = "";
  String username = "";

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
            color: Colors.transparent,
            child: Container(
                child: Material(
              color: Color(0xff643165),
              child: Column(children: <Widget>[
                InkWell(
                  onTap: () {},
                  child: UserAccountsDrawerHeader(
                      decoration: BoxDecoration(color: Color(0xffa456a7)),
                      accountName: FutureBuilder(
                        future: getUsername(),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }
                          return Text(
                            snapshot.data!,
                            style: TextStyle(fontSize: 20),
                          );
                        },
                      ),
                      currentAccountPicture: FutureBuilder(
                        future: getAvatar(),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }
                          return CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(snapshot.data!),
                          );
                        },
                      ),
                      accountEmail: Text(
                        FirebaseAuth.instance.currentUser!.email.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      )),
                ),
                Container(
                  child: Column(children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FilterEventPage("", "", "", username)),
                        );
                      },
                      child: ListTile(
                        leading: Image.asset(
                          "assets/images/event.png",
                          height: 40,
                          width: 40,
                        ),
                        title: Text(
                          "My events",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    )
                  ]),
                ),
                Container(
                  child: Column(children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllEventPage()),
                        );
                      },
                      child: ListTile(
                        leading: Image.asset(
                          "assets/images/calendar.png",
                          height: 40,
                          width: 40,
                        ),
                        title: Text(
                          "All events",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    )
                  ]),
                ),
                Container(
                  child: Column(children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FilterPage()),
                        );
                      },
                      child: ListTile(
                        leading: Image.asset(
                          "assets/images/search.png",
                          height: 40,
                          width: 40,
                        ),
                        title: Text(
                          "Search",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    )
                  ]),
                ),
                Container(
                  child: Column(children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsPage()),
                        );
                      },
                      child: ListTile(
                        leading: Image.asset(
                          "assets/images/settings.png",
                          height: 40,
                          width: 40,
                        ),
                        title: Text(
                          "Settings",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    )
                  ]),
                ),
                Divider(),
                Expanded(
                    child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                  ),
                  Container(
                      child: TextButton(
                    onPressed: () {},
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: ListTile(
                        leading: Image.asset(
                          "assets/images/lock.png",
                          height: 40,
                          width: 40,
                        ),
                        title: Text(
                          "Subscription",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  )),
                  Container(
                      child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutPage()),
                      );
                    },
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: ListTile(
                        leading: Image.asset(
                          "assets/images/info.png",
                          height: 40,
                          width: 40,
                        ),
                        title: Text(
                          "About",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  )),
                  Container(
                      child: TextButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      var test = await SharedPreferences.getInstance();
                      test.clear();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          ModalRoute.withName(Navigator.defaultRouteName));
                    },
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: ListTile(
                        leading: Image.asset(
                          "assets/images/logout.png",
                          height: 40,
                          width: 40,
                        ),
                        title: Text(
                          "Log out",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  )),
                ])),
              ]),
            ))));
  }

  Future<String> getUsername() async {
    User user = FirebaseAuth.instance.currentUser!;
    uidConnectedUser = user.uid;

    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(uidConnectedUser).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();

      // You can then retrieve the value from the Map like this:

      username = data?['username'];
    }
    return username;
  }

  Future<String> getAvatar() async {
    User user = FirebaseAuth.instance.currentUser!;
    uidConnectedUser = user.uid;

    String value = "";

    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(uidConnectedUser).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();

      // You can then retrieve the value from the Map like this:
      value = data?['url'];
    }
    return value;
  }

  @override
  Size get preferredSize => throw UnimplementedError();
}
