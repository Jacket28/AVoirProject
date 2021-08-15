import 'dart:async';
import 'dart:convert';

import 'package:a_voir_app/main.dart';
import 'package:a_voir_app/models/MyUser.dart';
import 'package:a_voir_app/pages/loginPage.dart';
import 'package:a_voir_app/ui/myTooltip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:password_validated_field/password_validated_field.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  CreateAccountState createState() => CreateAccountState();
}

class CreateAccountState extends State<CreateAccountPage> {
  MyUser _myUser = new MyUser(
    email: "",
    password: "",
    username: "",
    isServiceProvider: false,
    isSubscribed: false,
  );

  bool _validPassword = false;

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  TextEditingController _mailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _verifyPasswordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  var email = "";
  var password = "";
  var username = "";

  bool _isCreationAccountCorrect = true;

  var encryptedPassword;

  final _formkey = GlobalKey<FormState>();
  bool serviceProvider = false;
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              ModalRoute.withName(Navigator.defaultRouteName));
          return Future.value(false);
        },
        child: Scaffold(
            backgroundColor: Color(0xff643165),
            body: LoaderOverlay(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 80, bottom: 30),
                      child: Center(
                        child: Text(
                          "It's a pleasure to welcome you !",
                          style: TextStyle(
                              fontSize: 20.0, color: Color(0xffffffff)),
                        ),
                      ),
                    ),
                    Form(
                        key: _formkey,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 50),
                              child: TextFormField(
                                controller: _usernameController,
                                validator: (value) {
                                  //handle errors with Username submission
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your Username";
                                  }
                                  _myUser.username = value;
                                },
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    icon: Image.asset(
                                      'assets/images/user.png',
                                      height: 22,
                                      width: 22,
                                    ),
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
                                    labelText: 'Username',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    hintText: 'Username'),
                              ),
                            ),
                            Padding(
                              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 50),
                              child: TextFormField(
                                controller: _mailController,
                                validator: (value) {
                                  //handle errors with Email submission
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your Mail";
                                  } else if (!value.contains("@")) {
                                    return "Please enter a valid Email";
                                  }
                                  _myUser.email = value;
                                },
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    icon: const Icon(Icons.email,
                                        color: Colors.white),
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
                                    labelText: 'E-mail',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    hintText: 'E-mail'),
                              ),
                            ),
                            _validPassword
                                ? Text(
                                    "",
                                  )
                                : Container(),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 40),
                                child: PasswordValidatedFields(
                                  textStyle: TextStyle(color: Colors.white),
                                  textEditingController: _passwordController,
                                  inActiveIcon: Icons.cancel_outlined,
                                  activeIcon: Icons.check,
                                  inActiveRequirementColor: Colors.red,
                                  activeRequirementColor: Colors.white,
                                  inputDecoration: InputDecoration(
                                      icon: Image.asset(
                                        'assets/images/key.png',
                                        height: 22,
                                        width: 22,
                                      ),
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
                                      labelText: 'Password',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      hintText: 'Password'),
                                )),
                            Padding(
                              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 50),
                              child: TextFormField(
                                controller: _verifyPasswordController,
                                validator: (value) {
                                  //handle errors with Password submission
                                  if (value == null || value.isEmpty) {
                                    return "Please verify your Password";
                                  } else if (value !=
                                      _passwordController.text) {
                                    return "Your passwords must be identical !";
                                  }
                                  var bytes = utf8.encode(value);
                                  var digest = sha512.convert(bytes);
                                  _myUser.password = digest.toString();
                                },
                                obscureText: true,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    icon: Image.asset(
                                      'assets/images/keyVerify.png',
                                      height: 22,
                                      width: 22,
                                    ),
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
                                    labelText: 'Verify your password',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    hintText: 'Password'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 1),
                              child: Container(
                                padding: EdgeInsets.only(left: 80),
                                child: Row(
                                  children: [
                                    Text("Service Provider Account ?   ",
                                        style: TextStyle(color: Colors.white)),
                                    MyTooltip(
                                        message:
                                            "A service provider account is required \n if you want to add your own events !",
                                        child: Image.asset(
                                          'assets/images/infoTip.png',
                                          height: 15,
                                        )),
                                    Switch(
                                        activeTrackColor: Color(0xffa456a7),
                                        activeColor: Colors.black,
                                        value: serviceProvider,
                                        onChanged: (value) {
                                          setState(() {
                                            serviceProvider = value;
                                            print("SWITCH VALUE :");
                                            print(serviceProvider);
                                            _myUser.isServiceProvider =
                                                serviceProvider;
                                          });
                                        }),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 40, horizontal: 50),
                              child: Container(
                                height: 50,
                                width: 200,
                                decoration: BoxDecoration(
                                    color: Color(0xff643165),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Center(
                                  child: RoundedLoadingButton(
                                    color: Color(0xffa456a7),
                                    child: Text('Create your account !',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                                    controller: _btnController,
                                    onPressed: () {
                                      if (_formkey.currentState!.validate()) {
                                        setState(() {
                                          _isCreationAccountCorrect = true;
                                        });
                                        _validPassword = true;
                                        username = _usernameController.text;
                                        email = _mailController.text;
                                        password = _passwordController.text;
                                        registration();
                                      } else {
                                        _validPassword = false;
                                        ButtonFail();
                                        ButtonReset();
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            )));
  }

  void ButtonSuccess() async {
    Timer(Duration(seconds: 3), () {
      _btnController.success();
    });
  }

  void ButtonFail() async {
    Timer(Duration(seconds: 1), () {
      _btnController.error();
    });
  }

  void ButtonReset() async {
    Timer(Duration(seconds: 3), () {
      _btnController.reset();
    });
  }

  registration() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print(userCredential);
      CollectionReference userRefs = FirebaseFirestore.instance
          .collection('users')
          .withConverter<MyUser>(
            fromFirestore: (snapshot, _) => MyUser.fromJson(snapshot.data()!),
            toFirestore: (user, _) => user.toJson(),
          );
      _addUserToDatabase(context, userRefs);
    } on FirebaseAuthException catch (e) {
      ButtonFail();
      ButtonReset();
      _isCreationAccountCorrect = false;
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
              title: Text("Ops! Creation of Account Failed"),
              content: Text('${e.message}')));
    }
    if (_isCreationAccountCorrect == true) {
      _myUser.isServiceProvider = serviceProvider;
      ScaffoldMessenger.of(context).showSnackBar(
        new SnackBar(
            duration: new Duration(seconds: 1),
            content: new Row(
              children: [
                new CircularProgressIndicator(),
                new Text(
                  "   Creating your account",
                )
              ],
            )),
      );
      context.loaderOverlay.show();
      ButtonSuccess();
      ButtonReset();
      Timer(Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyApp()),
            ModalRoute.withName(Navigator.defaultRouteName));
      });
      context.loaderOverlay.hide();
    }
  }

  Future<Null> _addUserToDatabase(
      BuildContext context, CollectionReference userRefs) async {
    await userRefs.add(_myUser);
  }
}
