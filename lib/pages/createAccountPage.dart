import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:a_voir_app/localization/language_constants.dart';
import 'package:a_voir_app/models/MyUser.dart';
import 'package:a_voir_app/pages/loginPage.dart';
import 'package:a_voir_app/pages/tutoPage.dart';
import 'package:a_voir_app/ui/myTooltip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
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
    url: "",
  );
  String url = "";

  bool _validPassword = false;

  var uid;

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  TextEditingController _mailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _verifyPasswordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  var email = "";
  var password = "";
  var username = "";

  String _pickedImage = "";
  var _imageForAPI;

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
                          getTranslated(context, 'welcome_message')!,
                          style: TextStyle(
                              fontSize: 20.0, color: Color(0xffffffff)),
                        ),
                      ),
                    ),
                    Form(
                        key: _formkey,
                        child: Column(
                          children: <Widget>[
                            TextButton(
                                onPressed: () async {
                                  _pickImageGallery();
                                },
                                child: Container(
                                  height: 200,
                                  width: 200,
                                  child: _pickedImage != ""
                                      ? kIsWeb
                                          ? Image.network(
                                              _pickedImage,
                                              fit: BoxFit.fill,
                                            )
                                          : Image.file(File(
                                              _pickedImage,
                                            ))
                                      : Icon(
                                          Icons.photo,
                                          color: Colors.white,
                                          size: 100,
                                        ),
                                )),
                            Padding(
                              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 50),
                              child: TextFormField(
                                controller: _usernameController,
                                validator: (value) {
                                  //handle errors with Username submission
                                  if (value == null || value.isEmpty) {
                                    return getTranslated(
                                        context, 'username_message')!;
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
                                    labelText:
                                        getTranslated(context, 'username')!,
                                    labelStyle: TextStyle(color: Colors.grey),
                                    hintText:
                                        getTranslated(context, 'username')!),
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
                                    return getTranslated(
                                        context, 'enter_mail')!;
                                  } else if (!value.contains("@")) {
                                    return getTranslated(
                                        context, 'valid_mail')!;
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
                                    labelText: getTranslated(context, 'email')!,
                                    labelStyle: TextStyle(color: Colors.grey),
                                    hintText: getTranslated(context, 'email')!),
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
                                      labelText:
                                          getTranslated(context, 'password')!,
                                      labelStyle: TextStyle(color: Colors.grey),
                                      hintText:
                                          getTranslated(context, 'password')!),
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
                                    return getTranslated(
                                        context, 'please_verify_password')!;
                                  } else if (value !=
                                      _passwordController.text) {
                                    return getTranslated(
                                        context, 'identical_password')!;
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
                                    labelText: getTranslated(
                                        context, 'verify_password')!,
                                    labelStyle: TextStyle(color: Colors.grey),
                                    hintText:
                                        getTranslated(context, 'password')!),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 1),
                              child: Container(
                                padding: EdgeInsets.only(left: 80),
                                child: Row(
                                  children: [
                                    Text(
                                        getTranslated(
                                            context, 'service_provider')!,
                                        style: TextStyle(color: Colors.white)),
                                    MyTooltip(
                                        message: getTranslated(context,
                                            'service_provider_details')!,
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
                                      child: Text(
                                          getTranslated(
                                              context, 'create_your_account')!,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15)),
                                      controller: _btnController,
                                      onPressed: () async {
                                        if (_formkey.currentState!.validate() &&
                                            _pickedImage != "") {
                                          if (serviceProvider == false) {
                                            AlertDialog alert = AlertDialog(
                                              title: Text(getTranslated(
                                                  context, 'warning')!),
                                              content: Text(
                                                getTranslated(context,
                                                    'not_service_provider_message')!,
                                                style: TextStyle(
                                                    color: Color(0xffa456a7)),
                                              ),
                                              actions: [
                                                TextButton(
                                                    child: Text(
                                                        getTranslated(
                                                            context, 'cancel')!,
                                                        style: TextStyle(
                                                            color: Colors.red)),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      _buttonReset();
                                                    }),
                                                TextButton(
                                                    child: Text(
                                                        getTranslated(context,
                                                            'ok_message')!,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffa456a7))),
                                                    onPressed: () async {
                                                      _myUser.url =
                                                          await _sendImageToFirebase(
                                                              context);
                                                      setState(() {
                                                        _isCreationAccountCorrect =
                                                            true;
                                                      });
                                                      _validPassword = true;
                                                      username =
                                                          _usernameController
                                                              .text;
                                                      email = _mailController
                                                          .text
                                                          .toLowerCase();
                                                      password =
                                                          _passwordController
                                                              .text;
                                                      registration();
                                                    }),
                                              ],
                                            );
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return alert;
                                              },
                                            );
                                          } else {
                                            _myUser.url =
                                                await _sendImageToFirebase(
                                                    context);
                                            setState(() {
                                              _isCreationAccountCorrect = true;
                                            });
                                            _validPassword = true;
                                            username = _usernameController.text;
                                            email = _mailController.text
                                                .toLowerCase();
                                            password = _passwordController.text;
                                            registration();
                                          }
                                        } else {
                                          _validPassword = false;

                                          AlertDialog alert = AlertDialog(
                                            title: Text(getTranslated(
                                                context, 'create_account')!),
                                            content: Text(
                                              getTranslated(context,
                                                  'everything_as_been_filled')!,
                                              style: TextStyle(
                                                  color: Color(0xffa456a7)),
                                            ),
                                            actions: [
                                              TextButton(
                                                  child: Text(
                                                      getTranslated(context,
                                                          'ok_message')!,
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xffa456a7))),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  }),
                                            ],
                                          );
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return alert;
                                            },
                                          );
                                          _buttonFail();
                                          _buttonReset();
                                        }
                                      }),
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

  void _pickImageGallery() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.getImage(source: ImageSource.gallery);
      final pickedImageFile = pickedImage!.path;
      final imageForApi;
      if (kIsWeb)
        imageForApi = await pickedImage.readAsBytes();
      else
        imageForApi = 0;
      setState(() {
        _pickedImage = pickedImageFile;
        _imageForAPI = imageForApi;
      });
    } on TypeError catch (exception) {
      Navigator.of(context).pop();
    } catch (error) {
      AlertDialog(
        title: Text(getTranslated(context, 'wrong_message')!),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(getTranslated(context, 'check_photo_format')!),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'OK',
              style: TextStyle(color: Color(0xffa456a7)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
  }

  Future<String> _sendImageToFirebase(BuildContext context) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child("userImages")
        .child(_myUser.username + ".jpg");

    if (kIsWeb)
      await ref.putData(_imageForAPI);
    else
      await ref.putFile(File(_pickedImage));

    url = await ref.getDownloadURL();

    return url;
  }

  void _buttonSuccess() async {
    Timer(Duration(seconds: 3), () {
      _btnController.success();
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
    });
  }

  registration() async {
    if (await _isUsernameValid(_myUser.user_username)) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        CollectionReference userRefs = FirebaseFirestore.instance
            .collection('users')
            .withConverter<MyUser>(
              fromFirestore: (snapshot, _) => MyUser.fromJson(snapshot.data()!),
              toFirestore: (user, _) => user.toJson(),
            );

        uid = userCredential.user!.uid;
        _addUserToDatabase(context, userRefs);
      } on FirebaseAuthException catch (e) {
        _buttonFail();
        _buttonReset();
        _isCreationAccountCorrect = false;
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                title: Text(getTranslated(context, 'creation_account_failed')!),
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
                    getTranslated(context, 'creating_your_account')!,
                  )
                ],
              )),
        );
        context.loaderOverlay.show();
        _buttonSuccess();
        _buttonReset();
        Timer(Duration(seconds: 1), () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => TutoPage()),
              ModalRoute.withName(Navigator.defaultRouteName));
        });
        context.loaderOverlay.hide();
      }
    } else {
      _buttonFail();
      _buttonReset();
      _isCreationAccountCorrect = false;
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
              title: Text(getTranslated(context, 'creation_account_failed')!),
              content: Text(getTranslated(context, 'usernameTaken')!)));
    }
  }

  Future<Null> _addUserToDatabase(
      BuildContext context, CollectionReference userRefs) async {
    await userRefs.doc(uid).set(_myUser);
  }

  Future<bool> _isUsernameValid(String username) async {
    bool response = false;
    await FirebaseFirestore.instance
        .collection("users")
        .where('username', isEqualTo: username)
        .get()
        .then((querysnapshot) {
      if (querysnapshot.size == 0) {
        print('true');
        response = true;
      }
    });
    print('false');
    return response;
  }
}
