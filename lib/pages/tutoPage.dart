import 'package:a_voir_app/pages/loginPage.dart';
import 'package:a_voir_app/ui/appBar.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TutoPage extends StatefulWidget {
  @override
  TutoState createState() => TutoState();
}

class TutoState extends State<TutoPage> {
  List<Widget> _pages = [];
  final PageController _controller = PageController(initialPage: 0);
  double? _currentPage = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _pages = [
      Container(
        color: Color(0xffa456a7),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 160, bottom: 50),
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                  width: 100,
                ),
              ),
            ),
            Container(
              width: 250,
              height: 250,
              child: Image.asset(
                'assets/images/event.png',
                scale: 4,
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xff643165)),
            ),
            Container(
              padding: const EdgeInsets.only(top: 50, bottom: 50),
              child: Center(
                child: Container(
                    child: new Text(
                  'With "A Voir ! " You can create \n your own artistic event and add \n whoever you want.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Color(
                        0xffffffff,
                      )),
                )),
              ),
            ),
          ],
        ),
      ),
      Container(
        color: Color(0xffa456a7),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 160, bottom: 50),
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                  width: 100,
                ),
              ),
            ),
            Container(
              width: 250,
              height: 250,
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 100, top: 30),
                  child: Image.asset(
                    'assets/images/facebook.png',
                    scale: 7,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 100),
                  child: Image.asset(
                    'assets/images/instagram.png',
                    scale: 9,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 80),
                  child: Image.asset(
                    'assets/images/twitter.png',
                    scale: 10,
                  ),
                ),
              ]),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xff643165)),
            ),
            Container(
              padding: const EdgeInsets.only(top: 50, bottom: 50),
              child: Center(
                child: Container(
                    child: new Text(
                  'Share your events \n with your friends on \n social networks.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Color(
                        0xffffffff,
                      )),
                )),
              ),
            ),
          ],
        ),
      ),
      Container(
        color: Color(0xffa456a7),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 160, bottom: 50),
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                  width: 100,
                ),
              ),
            ),
            Container(
              width: 250,
              height: 250,
              child: Image.asset(
                'assets/images/networking.png',
                scale: 4,
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xff643165)),
            ),
            Container(
              padding: const EdgeInsets.only(top: 50, bottom: 50),
              child: Center(
                child: Container(
                    child: new Text(
                  'Be up to date by cheking \n what events are attended \n by who !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Color(
                        0xffffffff,
                      )),
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Center(
                child: Container(
                  height: 50,
                  width: 120,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25)),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        'Got it !',
                        style:
                            TextStyle(fontSize: 20.0, color: Color(0xffa456a7)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ];

    //add
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Stack(children: [
            PageView.builder(
              itemBuilder: (context, index) {
                return Transform(
                  transform: Matrix4.identity()..rotateZ(_currentPage! - index),
                  child: _pages[index],
                );
              },
              scrollDirection: Axis.horizontal,
              controller: _controller,
              itemCount: _pages.length,
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 50, horizontal: 174),
                child: DotsIndicator(
                  dotsCount: _pages.length,
                  position: _currentPage!.toDouble(),
                  decorator: DotsDecorator(
                    color: Color(0xff643165), // Inactive color
                    activeColor: Colors.white,
                  ),
                ))
          ]),
        ));
  }
}
