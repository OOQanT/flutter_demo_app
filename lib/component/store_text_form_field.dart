import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StoreTextFormField extends StatelessWidget {

  final bool isQuantity;
  final String label;
  final FormFieldSetter<String> onSaved;

  const StoreTextFormField({
    required this.isQuantity,
    required this.label,
    required this.onSaved,
    Key? key
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    const PRIMARY_COLOR = Color(0xFF0DB2B2);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              color: PRIMARY_COLOR,
              fontWeight: FontWeight.w600
          ),
        ),
        renderTextField(),
      ],
    );
  }

  Widget renderTextField(){
    return TextFormField(
      validator: (String? val){
        if(val == null || val.isEmpty){
          return '값을 입력해주세요.';
        }
      },

      onSaved: onSaved,

      cursorColor: Colors.grey,
      maxLines: 1,
      keyboardType: isQuantity ? TextInputType.number : TextInputType.text,
      inputFormatters: isQuantity ? [
        FilteringTextInputFormatter.digitsOnly,
      ] : [],

      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[300],
      ),

    );
  }
}
