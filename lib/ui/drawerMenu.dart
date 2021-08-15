import 'package:a_voir_app/main.dart';
import 'package:a_voir_app/pages/allEventPage.dart';
import 'package:flutter/material.dart';

//This class is used as a reusable component to display the appBar.
class DrawerMenu extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xff643165),
        child: Column(children: <Widget>[
          Center(
            child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Color(0xffa456a7)),
                accountName: Text(
                  "Kevin Coppey",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                      "https://cdn.icon-icons.com/icons2/1812/PNG/512/4213460-account-avatar-head-person-profile-user_115386.png"),
                ),
                accountEmail: Text(
                  "example@hotmail.com",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
          ),
          Container(
            child: Column(children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AllEventPage()),
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
                    MaterialPageRoute(builder: (context) => AllEventPage()),
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
                    MaterialPageRoute(builder: (context) => AllEventPage()),
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
                onPressed: () {},
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
              onPressed: () {},
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
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
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
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}
