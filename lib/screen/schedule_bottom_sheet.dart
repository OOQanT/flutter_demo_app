import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mnd_factory/model/store_item.dart';

import '../component/custom_text_form_field.dart';
import '../component/store_text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod/state_nodifier_provider.dart';

class ScheduleBottomSheet extends ConsumerStatefulWidget {

  final DateTime selectedDay;

  const ScheduleBottomSheet({
    required this.selectedDay,
    Key? key,
  }):super(key: key);

  @override
  ConsumerState<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends ConsumerState<ScheduleBottomSheet> {

  final GlobalKey<FormState> formKey = GlobalKey();

  String? itemName;
  String? itemCode;
  int? quantity;

  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height / 2 + bottomInset,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: StoreTextFormField(isQuantity: false,label: '상품 이름', onSaved: (String? val) {
                        itemName = val;
                      },),
                    ),
                    SizedBox(height: 16.0),
                    Expanded(
                      child: StoreTextFormField(isQuantity: false,label: '상품 코드', onSaved: (String? val) {
                        itemCode = val;
                      },),
                    ),
                    SizedBox(height: 16.0),
                    Expanded(
                      child: StoreTextFormField(isQuantity: true,label: '수량', onSaved: (String? val) {
                        quantity = int.parse(val!);
                      },),
                    ),
                    SizedBox(height: 8.0),
                    _SaveButton(onPressed: (){
                      saveButtonPressed();
                    },),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              child: Text('취소')
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  void saveButtonPressed(){
    if(formKey.currentState == null){
      return null;
    }

    if(formKey.currentState!.validate()){
      formKey.currentState!.save();

      StoreItemModel item = StoreItemModel(name: itemName!, code: itemCode!, quantity: quantity!, date: widget.selectedDay);
      
      ref.read(storeItemListProvider.notifier).addItem(item);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('등록에 성공하였습니다.'),
            duration: Duration(seconds: 2),
        ),
      );
      Navigator.of(context).pop();
    }
  }

}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveButton({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color PRIMARY_COLOR = Color(0xFF0DB2B2);
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
            ),
            child: Text('저장'),
          ),
        ),
      ],
    );
  }
}
