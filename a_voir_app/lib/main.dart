// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

const primaryColor = const Color(0xA456A7);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        backgroundColor: Color(0xffa456a7),
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
          backgroundColor: Color(0xffa456a7),
        ),
        body: const Center(
          child: Text(
            'Hello World',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 50,
            ),
          ),
        ),
      ),
    );
  }
}
