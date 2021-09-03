import 'package:a_voir_app/pages/EventPage.dart';
import 'package:a_voir_app/ui/appBar.dart';
import 'package:a_voir_app/ui/drawerMenu.dart';
import 'package:a_voir_app/ui/bottomAppBar.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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
    final events = FirebaseFirestore.instance.collection(
            "events") /*.where('date',
        isGreaterThanOrEqualTo:
            DateFormat.yMd().format(DateTime.now()).toString())*/
        ;
    //we store all the events into this List.
    List<Widget> listofEvents = [];

    //await is necessary to wait for the asynchronous call.
    await events.get().then((querySnapshot) {
      if (querySnapshot.size == 0) {
        //return Text('No event is corresponding to the filters');
        return Container(
            padding: EdgeInsets.only(top: 20),
            child: new Text('No event is available',
                style: TextStyle(color: Colors.white, fontSize: 20.0)));
      }

      querySnapshot.docs.forEach((result) {
        String myDate = result['date'] as String;
        var dateSplited = myDate.split('/');
        if (_isFutur(dateSplited)) {
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
                          child: Image.network(
                            result.get("url"),
                            fit: BoxFit.cover,
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
          //}
        }
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
                return _addButtonVisible(
                  context,
                );
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
    final Size size = MediaQuery.of(context).size;

    return Container(height: 100, width: size.width, child: BottomNavBarV2());
  }

  bool _isFutur(List<String> dateSplited) {
    int year = int.parse(DateFormat.y().format(DateTime.now()));
    int month = int.parse(DateFormat.M().format(DateTime.now()));
    int day = int.parse(DateFormat.d().format(DateTime.now()));

    if (int.parse(dateSplited[2]) > year) {
      print('year is superior');
      return true;
    }

    if (int.parse(dateSplited[2]) == year) {
      if (int.parse(dateSplited[0]) >= month) {
        if (int.parse(dateSplited[1]) >= day) {
          return true;
        }
      }
    }
    return false;
  }
}
