import 'dart:async';

import 'package:a_voir_app/pages/allEventPage.dart';
import 'package:a_voir_app/pages/createAccountPage.dart';
import 'package:a_voir_app/pages/settingsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'aboutPage.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController _mailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String mail = "";
  String password = "";

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final _formkey = GlobalKey<FormState>();
  bool buttonEnabled = true;
  int cptButton = 0;
  var colorDisable = Colors.white;

  bool _isLoginCorrect = true;

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: LoaderOverlay(
            child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xff643165),
            toolbarHeight: 70,
            elevation: 0,
            title: IconButton(
              icon: const Icon(Icons.info_outline),
              iconSize: 40,
              padding: EdgeInsets.only(left: 0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.settings),
                iconSize: 40,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
              ),
            ],
          ),
          backgroundColor: Color(0xff643165),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 50),
                  child: Center(
                    child: Image.asset(
                      'assets/images/logoAll.png',
                      height: 215,
                      width: 215,
                    ),
                  ),
                ),
                Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 500,
                          padding: EdgeInsets.only(
                              right: 10, left: 10, bottom: 1, top: 1),
                          child: TextFormField(
                            controller: _mailController,
                            validator: (value) {
                              //handle errors with email submission
                              if (value == null || value.isEmpty) {
                                return "Please enter your Email";
                              }
                              if (!value.contains("@"))
                                return "Please enter a valid Email";
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                errorStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                hintStyle: TextStyle(color: Color(0xff643165)),
                                enabledBorder: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                labelText: 'Email',
                                labelStyle: TextStyle(color: Colors.grey),
                                hintText:
                                    'Enter a valid email as abc@gmail.com'),
                          ),
                        ),
                        Container(
                          width: 500,
                          padding: EdgeInsets.only(
                              right: 10, left: 10, bottom: 20, top: 20),
                          child: TextFormField(
                            controller: _passwordController,
                            validator: (value) {
                              //handle errors with Password submission
                              if (value == null || value.isEmpty) {
                                return "Please enter your Password";
                              }
                              return null;
                            },
                            obscureText: true,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                errorStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                hintStyle: TextStyle(color: Color(0xff643165)),
                                enabledBorder: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.grey),
                                hintText: 'Enter your password'),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 120,
                          child: Center(
                            child: RoundedLoadingButton(
                              color: Color(0xffa456a7),
                              child: Text('Log In',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                              controller: _btnController,
                              onPressed: () {
                                setState(() {
                                  _isLoginCorrect = true;
                                  colorDisable = Colors.grey;
                                  buttonEnabled = false;
                                });

                                if (_formkey.currentState!.validate()) {
                                  mail = _mailController.text;
                                  password = _passwordController.text;

                                  // If the form is valid, display a snackbar.

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    new SnackBar(
                                        duration: new Duration(seconds: 1),
                                        content: new Row(
                                          children: [
                                            new CircularProgressIndicator(),
                                            new Text("   Signin in...")
                                          ],
                                        )),
                                  );
                                  _login();
                                  _buttonReset();
                                } else {
                                  _buttonFail();
                                  _buttonReset();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "New user ?",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Column(
                  children: [
                    TextButton(
                      onPressed: () async {
                        setState(() {});
                        cptButton = 1;
                        Timer(Duration(milliseconds: 1000), () {
                          if (buttonEnabled == true && cptButton == 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateAccountPage()),
                            );
                            context.loaderOverlay.hide();

                            cptButton = 0;
                          }
                        });
                      },
                      child: Text('Create account',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 20.0,
                              color: colorDisable)),
                    ),
                  ],
                )
              ],
            ),
          ),
        )));
  }

  void _buttonSuccess() async {
    Timer(Duration(seconds: 1), () {
      _btnController.success();
      buttonEnabled = true;
      setState(() {
        colorDisable = Colors.white;
      });
    });
  }

  void _buttonFail() async {
    Timer(Duration(seconds: 1), () {
      _btnController.error();
    });
  }

  void _buttonReset() async {
    Timer(Duration(seconds: 3), () {
      _btnController.reset();
      buttonEnabled = true;
      setState(() {
        colorDisable = Colors.white;
      });
    });
  }

  _login() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: mail, password: password);
    } on FirebaseAuthException catch (e) {
      _buttonFail();
      _buttonReset();
      _isLoginCorrect = false;
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
              title: Text("Ops! Login Failed"), content: Text('${e.message}')));
    }
    if (_isLoginCorrect == true) {
      _setreferences(context, mail);
      context.loaderOverlay.show();
      _buttonSuccess();
      _buttonReset();
      Timer(Duration(milliseconds: 500), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AllEventPage()),
        );
        context.loaderOverlay.hide();
      });
    }
  }
}

Future<void> _setreferences(BuildContext context, String email) async {
  final prefs = await SharedPreferences.getInstance();

  await FirebaseFirestore.instance
      .collection("users")
      .where('email', isEqualTo: email)
      .get()
      .then((value) {
    prefs.setString('userId', value.docs.single.id);
    prefs.setBool('isProvider', value.docs.single.get('isServiceProvider'));
  });
}

class HomePage {}
