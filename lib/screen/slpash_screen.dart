import 'package:flutter/material.dart';
import 'package:mnd_factory/layout/default_layout.dart';
import 'package:mnd_factory/screen/home_screen.dart';
import 'package:mnd_factory/screen/login_screen.dart';

import '../const/data.dart';
import 'package:dio/dio.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    //deleteToken();
    checkToken();
  }

  void deleteToken()async{
    await storage.deleteAll();
  }

  void checkToken() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    final dio = Dio();

    try{

      final response = await dio.post(
        'http://${ip}/auth/token',
        options: Options(
          headers: {
            'authorization' : 'Bearer $refreshToken',
          },
        ),
      );

      await storage.write(key: ACCESS_TOKEN_KEY, value: response.data['accessToken']);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_)=> HomeScreen()),
              (route) => false
      );

    }catch(e){
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_)=> LoginScreen()),
              (route) => false);
    }

  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        backgroundColor: Color(0xff5A9BFF),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('asset/img/logo/logo.png',width: MediaQuery.of(context).size.width / 2,fit: BoxFit.cover,),
              const SizedBox(height: 16.0,),
              CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        )
    );
  }
}
