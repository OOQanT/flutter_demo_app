import 'package:flutter/material.dart';
import 'package:mnd_factory/screen/login_screen.dart';
import 'package:mnd_factory/screen/slpash_screen.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'Notosans',
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    )
  );
}

