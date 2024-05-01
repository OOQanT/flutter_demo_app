import 'package:flutter/material.dart';
import 'package:mnd_factory/screen/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mnd_factory/screen/login_screen.dart';
import 'package:mnd_factory/screen/slpash_screen.dart';

void main() {
  runApp(
      ProviderScope(
        child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Notosans',
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        //SplashScreen(),
      ),
    )
  );
}

