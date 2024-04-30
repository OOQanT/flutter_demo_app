import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mnd_factory/const/colors.dart';
import 'package:mnd_factory/layout/default_layout.dart';
import 'package:mnd_factory/screen/home_screen.dart';

import '../component/custom_text_form_field.dart';
import '../const/data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final scrollController = ScrollController();
  final GlobalKey<FormState> formKey = GlobalKey();
  final dio = Dio();

  String? username;
  String? password;

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return DefaultLayout(
        backgroundColor: Color(0xff5A9BFF),
        child: SingleChildScrollView(
          controller: scrollController,
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: SafeArea(
            top: true,
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Title(),
                    const SizedBox(height: 8.0,),
                    _SubTitle(),
                    const SizedBox(height: 128.0,),
                    Image.asset(
                      'asset/img/logo/logo.png',
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 128.0,),
                    CustomTextFormField(
                      onChanged: (String? value){
                      username = value;
                      },
                      hintText: '이메일을 입력해주세요',
                    ),
                    const SizedBox(height: 16.0,),
                    CustomTextFormField(
                      onChanged: (String? value){
                        password = value;
                      },
                      hintText: '비밀번호을 입력해주세요',
                      obscureText: true,
                    ),
                    const SizedBox(height: 16.0,),
                    ElevatedButton(
                        onPressed: onSaveButtonPressed,
                        child: Text('로그인', style: TextStyle(color: Color(0xff5A9BFF)),),
                        style:ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                    ),
                    TextButton(
                        onPressed: (){},
                        child: Text('회원가입', style: TextStyle(color: Colors.white),)
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  void onSaveButtonPressed(){

    if(formKey.currentState == null){
      return null;
    }

    if(formKey.currentState!.validate()){
      formKey.currentState!.save();
      print(username);
      print(password);

      loginRequest(username!,password!);
    }
  }

  Future<void> loginRequest(String username, String password) async {
    final rawString = '${username}:${password}';

    Codec<String,String> stringToBase64 = utf8.fuse(base64); // 평문을 base64 로 인코딩하는 방법
    String token = stringToBase64.encode(rawString);

    try{
      final response = await dio.post(
        'http://${ip}/auth/login',
        options: Options(
          headers: {
            'authorization' : 'Basic $token',
          },
        ),
      );

      final refreshToken = response.data['refreshToken'];
      final accessToken = response.data['accessToken'];

      await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

      print('refreshToken: $refreshToken');
      print('accessToken: $accessToken');

      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => HomeScreen())
      );
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('로그인에 실패했습니다. 이메일과 비밀번호를 확인해주세요.'),
            duration: Duration(seconds: 2),
            //backgroundColor: Colors.grey,
        ),
      );
    }
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.white
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력하여 로그인 해주세요.',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white
      ),
    );
  }
}


