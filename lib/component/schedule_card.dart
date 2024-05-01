import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {

  final String name;
  final String code;
  final int quantity;

  const ScheduleCard({
    required this.name,
    required this.code,
    required this.quantity,
    Key? key
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    const PRIMARY_COLOR = Color(0xFF0DB2B2);
    return Container(
        decoration: BoxDecoration(
          border: Border.all( width: 1.0, color: PRIMARY_COLOR),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: IntrinsicHeight(
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('이름: ${name}'),
                SizedBox(width: 16),
                Text('코드: ${code}'),
                SizedBox(width: 16),
                Text('수량: ${quantity}'),
              ],
            ),
          ),
        ),
    );
  }
}
