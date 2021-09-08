import 'package:a_voir_app/localization/language_constants.dart';
import 'package:a_voir_app/ui/appBar.dart';
import 'package:a_voir_app/ui/drawerMenu.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';

import 'filterEventPage.dart';

// This page is used to add new events to the DB.
class FilterPage extends StatefulWidget {
  FilterPage();

  @override
  FilterState createState() => FilterState();
}

class FilterState extends State<FilterPage> {
  //The scaffoldKey will be used later for the burger menu
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String provider = "";
  String date = "";
  String city = "";

  String dateTime = "";

  DateTime selectedDate = DateTime.now();

  //controllers are used to manage changes with the texfield.
  TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    dateTime = DateFormat.yMd().format(DateTime.now());
    return new Scaffold(
      key: _scaffoldKey,
      //Used to avoid keyboard to go over Input fields
      resizeToAvoidBottomInset: true,
      endDrawer: DrawerMenu(),
      //the appBar is created upon reusable widget which is called appBar.dart.
      appBar: BaseAppBar(
        appBar: AppBar(),
        scaffoldKey: _scaffoldKey,
      ),
      backgroundColor: Color(0xffa456a7),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 10)),
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 60, left: 65)),
                        Text(
                          //Date section
                          getTranslated(context, 'date')!,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Padding(padding: EdgeInsets.only(top: 20, left: 145)),
                        InkWell(
                          onTap: () {
                            _selectDate(context).then((value) {
                              date = value;
                            });
                          },
                          child: Container(
                              width: 100,
                              height: 70,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: Colors.white),
                              child: _dateController.text == ""
                                  ? Icon(
                                      Icons.calendar_today,
                                      color: Color(0xff643165),
                                      size: 50,
                                    )
                                  : TextFormField(
                                      style: TextStyle(fontSize: 20),
                                      textAlign: TextAlign.center,
                                      enabled: false,
                                      keyboardType: TextInputType.text,
                                      controller: _dateController,
                                      decoration: InputDecoration(
                                          disabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide.none),
                                          contentPadding:
                                              EdgeInsets.only(top: 0)),
                                      onChanged: (text) {
                                        date = text;
                                      },
                                    )),
                        ),
                        Padding(padding: EdgeInsets.only(left: 90)),
                      ],
                    ),
                    Column(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                      ),
                      Text(
                        //Location section
                        getTranslated(context, 'city')!,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Container(
                          padding:
                              EdgeInsets.only(top: 20, left: 100, right: 100),
                          child: FutureBuilder(
                            future: _getCities(context),
                            builder: (BuildContext context,
                                AsyncSnapshot<List> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData) {
                                  return new DropdownButtonFormField(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(30.0),
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white),
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    value: city,
                                    items: snapshot.data!.map((city) {
                                      return new DropdownMenuItem(
                                          value: city,
                                          child: Text(
                                            city,
                                            textAlign: TextAlign.center,
                                          ));
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        city = value as String;
                                      });
                                    },
                                  );
                                }
                              }
                              return CircularProgressIndicator();
                            },
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                      ),
                      Text(
                        //Description of the events section
                        getTranslated(context, 'provider')!,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                      ),
                      Container(
                          padding:
                              EdgeInsets.only(top: 1, left: 100, right: 100),
                          child: FutureBuilder(
                            future: _getProvider(context),
                            builder: (BuildContext context,
                                AsyncSnapshot<List> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData) {
                                  return new DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(30.0),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    value: provider,
                                    items: snapshot.data!.map((provider) {
                                      return new DropdownMenuItem(
                                        value: provider,
                                        child: Text(
                                          provider,
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        provider = value as String;
                                      });
                                    },
                                  );
                                }
                              }
                              return CircularProgressIndicator();
                            },
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                      ),
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
                                new Image.asset('assets/images/checkEvent.png',
                                    height: 25.0, width: 25.0),
                                Container(
                                    padding: EdgeInsets.only(left: 5),
                                    child: new Text(
                                      getTranslated(context, 'filter')!,
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
                                builder: (context) => FilterEventPage(
                                  provider,
                                  date,
                                  city,
                                  "",
                                ),
                              ));
                        },
                      ),
                    ])
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

  Future<List> _getCities(BuildContext context) async {
    final CollectionReference events =
        FirebaseFirestore.instance.collection("events");

    List<String> cities = [];
    cities.add('');

    await events.get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        cities.add(result['city']);
      });
    });

    return cities.toSet().toList();
  }

  Future<List> _getProvider(BuildContext context) async {
    final events = FirebaseFirestore.instance
        .collection("users")
        .where('isServiceProvider', isEqualTo: true);

    List<String> providers = [];
    providers.add('');

    await events.get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        providers.add(result['username']);
      });
    });

    return providers.toSet().toList();
  }

  //Used to create the date picker
  Future<String> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2021, 1, 1),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate).toString();
      });

    return _dateController.text;
  }
}
