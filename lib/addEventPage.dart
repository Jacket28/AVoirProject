import 'package:a_voir_app/MyEvent.dart';
import 'package:a_voir_app/allEventPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';

class AddEventPage extends StatefulWidget {
  @override
  AddEventState createState() => AddEventState();
}

class AddEventState extends State<AddEventPage> {
  double _height = 0;
  double _width = 0;

  String _setTime = "";

  String _hour = "";
  String _minute = "";
  String _time = "";

  String dateTime = "";

  MyEvent event = new MyEvent(
      title: "",
      description: "",
      address: "",
      npa: "",
      city: "",
      date: "",
      time: "");

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  final _bodyController = TextEditingController(
    text: '',
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());
    return new Scaffold(
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
                        width: 400,
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
                              "* Title (3 words max.)",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  top: 20, left: 100, right: 100),
                              child: TextField(
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      hintStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(25.0),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(25.0),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      hintText: 'Subject of Event.'),
                                  onChanged: (text) {
                                    event.title = text;
                                  }),
                            ),
                            Row(
                              children: <Widget>[
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, left: 65)),
                                Text(
                                  "* Date",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 100, left: 145)),
                                Text(
                                  "* Time",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Padding(padding: EdgeInsets.only(left: 50)),
                                InkWell(
                                  onTap: () {
                                    _selectDate(context).then((value) {
                                      event.date = value;
                                    });
                                  },
                                  child: Container(
                                    width: _width / 4,
                                    height: _height / 14,
                                    alignment: Alignment.center,
                                    decoration:
                                        BoxDecoration(color: Colors.grey[200]),
                                    child: TextFormField(
                                      style: TextStyle(fontSize: 20),
                                      textAlign: TextAlign.center,
                                      enabled: false,
                                      keyboardType: TextInputType.text,
                                      controller: _dateController,
                                      decoration: InputDecoration(
                                          disabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide.none),
                                          // labelText: 'Time',
                                          contentPadding:
                                              EdgeInsets.only(top: 0)),
                                      onChanged: (text) {
                                        event.date = text;
                                      },
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(left: 100)),
                                InkWell(
                                  onTap: () {
                                    _selectTime(context).then((value) {
                                      event.time = value;
                                    });
                                  },
                                  child: Container(
                                    width: _width / 4,
                                    height: _height / 14,
                                    alignment: Alignment.center,
                                    decoration:
                                        BoxDecoration(color: Colors.grey[200]),
                                    child: TextFormField(
                                      style: TextStyle(fontSize: 20),
                                      textAlign: TextAlign.center,
                                      enabled: false,
                                      keyboardType: TextInputType.text,
                                      controller: _timeController,
                                      decoration: InputDecoration(
                                        disabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide.none),
                                        // labelText: 'Time',
                                      ),
                                      onChanged: (text) {
                                        event.time = text;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 30),
                              ),
                              Text(
                                "* Location",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 20, left: 100, right: 100),
                                child: TextField(
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      hintStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(25.0),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(25.0),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      hintText: 'Address, Npa, City'),
                                  onChanged: (text) {
                                    List<String> temp = text.split(",");
                                    event.address = temp.elementAt(0);
                                    event.npa = temp.elementAt(1);
                                    event.city = temp.elementAt(2);
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 30),
                              ),
                              Text(
                                "Description",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 1, left: 100, right: 100),
                                child: TextField(
                                  controller: _bodyController,
                                  maxLines: null,
                                  maxLength: 300,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      hintStyle:
                                          TextStyle(color: Color(0xff643165)),
                                      enabledBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(25.0),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(25.0),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      labelText: '',
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      hintText: ''),
                                  onChanged: (text) {
                                    event.description = text;
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 30),
                              ),
                              TextButton(
                                child: Container(
                                  height: 50,
                                  width: 130,
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
                                        new Image.asset(
                                            'assets/images/checkEvent.png',
                                            height: 25.0,
                                            width: 25.0),
                                        Container(
                                            padding: EdgeInsets.only(left: 5),
                                            child: new Text(
                                              "Submit",
                                              style: TextStyle(
                                                  color: Color(0xffa456a7),
                                                  fontSize: 20.0),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  if (event.date == "" ||
                                      event.time == "" ||
                                      event.title == "" ||
                                      event.address == "" ||
                                      event.npa == "" ||
                                      event.city == "") {
                                    //Error message to create
                                  } else {
                                    _addEventToDatabase(context, event);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AllEventPage()),
                                    );
                                  }
                                },
                              ),
                            ])
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

  Future<String> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2021),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate).toString();
      });

    return _dateController.text;
  }

  Future<String> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });

    return _timeController.text;
  }

  Future<Null> _addEventToDatabase(
      BuildContext context, MyEvent newEvent) async {
    final eventRefs = FirebaseFirestore.instance
        .collection('events')
        .withConverter<MyEvent>(
          fromFirestore: (snapshot, _) => MyEvent.fromJson(snapshot.data()!),
          toFirestore: (event, _) => event.toJson(),
        );

    await eventRefs.add(newEvent);
  }
}
