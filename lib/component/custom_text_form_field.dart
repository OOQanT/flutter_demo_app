import 'package:flutter/material.dart';

import '../const/colors.dart';

class CustomTextFormField extends StatelessWidget {

  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  //final ValueChanged<String>? onChanged;
  final FormFieldSetter<String> onChanged;

  const CustomTextFormField({
    required this.onChanged,
    this.autofocus = false,
    this.obscureText = false,
    this.hintText,
    this.errorText,
    Key? key,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {

    final baseBorder = OutlineInputBorder( // 밑줄이 없는 보더
        borderSide: BorderSide(
          color: Colors.white, // 보더라인 색
          width: 1.0,
        )
    );

    final baseBorder2 = UnderlineInputBorder(
      borderSide: BorderSide(color: INPUT_BORDER_COLOR, width: 1.0)
    );

    return TextFormField(
      style: TextStyle(color: Colors.white), // 입력되는 글자색
      cursorColor: Colors.white,
      obscureText: obscureText,
      autofocus: autofocus, // 화면으로 들어왔을 때 자동으로 포커스 되는 설정
      onSaved: onChanged, // 값을 입력할 때 동작하는 콜백


      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20), // 텍스트 필드 안에서 패딩 적용하기
        hintText: hintText,
        errorText: errorText,
        hintStyle: TextStyle( // 힌트 텍스트 스타일
            color: Colors.white, // 힌트 텍스트 색
            fontSize: 14.0
        ),
        border:baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith( // 포커스 된 보더의 스타일을 변경
            borderSide: baseBorder.borderSide.copyWith(
              color: Color(0xff00008B),
            )
        ),
      ),

      validator: (String? val){
        if(val == null || val.isEmpty){
          return obscureText ? '비밀번호를 입력해주세여' : '이메일을 입력해주세요';
        }

      },

      onTapOutside: (e){
        FocusManager.instance.primaryFocus?.unfocus(); // 텍스트 필드가 포커스 된 상태에서 다른 곳을 탭했을 때 포커스를 잃게 함.
      },

      scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    );
  }
}
