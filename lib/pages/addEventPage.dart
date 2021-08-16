import 'package:a_voir_app/main.dart';
import 'package:a_voir_app/models/MyEvent.dart';
import 'package:a_voir_app/pages/allEventPage.dart';
import 'package:a_voir_app/ui/appBar.dart';
import 'package:a_voir_app/ui/drawerMenu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This page is used to add new events to the DB.
class AddEventPage extends StatefulWidget {
  AddEventPage(this._myEvent);

  MyEvent _myEvent;

  @override
  AddEventState createState() => AddEventState(_myEvent);
}

class AddEventState extends State<AddEventPage> {
  AddEventState(MyEvent myEvent) {
    _myEvent = myEvent;
  }

  //The scaffoldKey will be used later for the burger menu
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  MyEvent _myEvent = new MyEvent(
    title: "",
    description: "",
    address: "",
    npa: "",
    city: "",
    date: "",
    time: "",
    provider: "",
  );

  //Used to know if the textField can be edited or not.
  bool isEditing = false;

  double _height = 0;
  double _width = 0;

  String _setTime = "";

  String _hour = "";
  String _minute = "";
  String _time = "";

  String dateTime = "";

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  //controllers are used to manage changes with the texfield.
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  SharedPreferences? prefs;

  //InitSate is used to set the textFields to empty at the initialization of the page.
  @override
  void initState() {
    if (_myEvent.hasId()) {
      isEditing = true;
      _titleController.text = _myEvent.title;
      _locationController.text =
          _myEvent.address + ", " + _myEvent.npa + ", " + _myEvent.city;
      _descriptionController.text = _myEvent.description;
      _dateController.text = _myEvent.date;
      _timeController.text = _myEvent.time;
    }

    _setreferences(context).whenComplete(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
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
                            Padding(
                              padding: EdgeInsets.only(top: 30),
                            ),
                            Text(
                              //Title section
                              "Title",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Container(
                                padding: EdgeInsets.only(
                                    top: 20, left: 100, right: 100),
                                child: TextField(
                                    maxLength: 30,
                                    controller: _titleController,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        counterStyle:
                                            TextStyle(color: Colors.white),
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
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
                                      _myEvent.title = text;
                                    })),
                            Row(
                              children: <Widget>[
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, left: 65)),
                                Text(
                                  //Date section
                                  "Date",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 100, left: 145)),
                                Text(
                                  //time section
                                  "Time",
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
                                      _myEvent.date = value;
                                    });
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 70,
                                    alignment: Alignment.center,
                                    decoration:
                                        BoxDecoration(color: Colors.white),
                                    child: TextFormField(
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
                                        _myEvent.date = text;
                                      },
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(left: 100)),
                                InkWell(
                                  onTap: () {
                                    _selectTime(context).then((value) {
                                      _myEvent.time = value;
                                    });
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 70,
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
                                      ),
                                      onChanged: (text) {
                                        _myEvent.time = text;
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
                                //Location section
                                "Location",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 20, left: 100, right: 100),
                                child: TextField(
                                  controller: _locationController,
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
                                      hintText: 'format : Address, Npa, City'),
                                  onChanged: (text) {
                                    List<String> temp = text.split(",");
                                    _myEvent.address = temp.elementAt(0);
                                    _myEvent.npa = temp.elementAt(1).trim();
                                    _myEvent.city = temp.elementAt(2).trim();
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 30),
                              ),
                              Text(
                                //Description of the events section
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
                                  controller: _descriptionController,
                                  maxLines: null,
                                  maxLength: 300,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      counterStyle:
                                          TextStyle(color: Colors.white),
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
                                      labelText: '',
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      hintText: 'Description of the event'),
                                  onChanged: (text) {
                                    _myEvent.description = text;
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
                                            child: _setButtonText(context))
                                      ],
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  if (_myEvent.date == "" ||
                                      _myEvent.time == "" ||
                                      _myEvent.title == "" ||
                                      _myEvent.address == "" ||
                                      _myEvent.npa == "" ||
                                      _myEvent.city == "" "" ||
                                      _myEvent.description == "") {
                                    //Error message to create
                                    _alertDialogFill();
                                  } else {
                                    _editDatabase(context);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AllEventPage()),
                                        ModalRoute.withName(
                                            Navigator.defaultRouteName));
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

  //Submit button
  Widget _setButtonText(BuildContext context) {
    String text = "Submit";
    if (isEditing) {
      text = "Save";
    }
    return new Text(
      text,
      style: TextStyle(color: Color(0xffa456a7), fontSize: 20.0),
    );
  }

  //Used to create the date picker
  Future<String> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now().subtract(Duration(days: 0)),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate).toString();
      });

    return _dateController.text;
  }

  //used to create the time picker
  Future<String> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    int currentHour = TimeOfDay.fromDateTime(DateTime.now()).hour;
    int currentMinute = TimeOfDay.fromDateTime(DateTime.now()).minute;

    double pickedHour = picked?.hour.toDouble() ?? 0;
    double pickedMinute = picked?.minute.toDouble() ?? 0;

    //We transform time into double to compare
    double? _doubleYourTime = pickedHour + (pickedMinute / 60);
    double? _doubleNowTime = currentHour + (currentMinute / 60);

    //We check if the picked date is the same as today
    if (selectedDate.day == DateTime.now().day &&
        selectedDate.month == DateTime.now().month &&
        selectedDate.year == DateTime.now().year) {
      //We check if the picked time is smaller than the actual time
      if (_doubleYourTime < _doubleNowTime) {
        //If it's the case we raise an alert and we display the actual time
        _alertDialogTime();
        picked = TimeOfDay.fromDateTime(DateTime.now());
      }
    }
    if (picked != null)
      setState(() {
        selectedTime = picked!;
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

//Method to create an error dialog box if time is set to past
  Future<void> _alertDialogTime() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('You cannot select a previous time'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                    'Please make sure that the selected time is in the future'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Approve',
                style: TextStyle(color: Color(0xffa456a7)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

//Method to create an error dialog box if textfields are empty when creating a new event
  Future<void> _alertDialogFill() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Not all fields are correctly filled'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                    'Please make sure that every fields are filled correctly.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Approve',
                style: TextStyle(color: Color(0xffa456a7)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //This method is used to update the databse. (determine if the page is in edit mode. If yes, we update the DB, if not we add in DB)
  _editDatabase(BuildContext context) {
    CollectionReference eventRefs = FirebaseFirestore.instance
        .collection('events')
        .withConverter<MyEvent>(
          fromFirestore: (snapshot, _) => MyEvent.fromJson(snapshot.data()!),
          toFirestore: (event, _) => event.toJson(),
        );
    if (isEditing) {
      _updateEventInDatabase(context, eventRefs);
    } else {
      _addEventToDatabase(context, eventRefs);
    }
  }

  //This method is used to update the DB
  Future<void> _updateEventInDatabase(
      BuildContext context, CollectionReference eventRefs) async {
    await eventRefs.doc(_myEvent.id).update(_myEvent.toJson());
  }

  //This method is used to add an event to the DB
  Future<void> _addEventToDatabase(
      BuildContext context, CollectionReference eventRefs) async {
    _myEvent.provider = prefs!.getString('userId')!;
    await eventRefs.add(_myEvent);
  }

  Future<void> _setreferences(BuildContext context) async {
    this.prefs = await SharedPreferences.getInstance();
  }
}
