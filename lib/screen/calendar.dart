import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatelessWidget {

  final DateTime? selectedDay;
  final DateTime focusedDay;
  final OnDaySelected onDaySelected;

  const CalendarScreen({
    required this.selectedDay,
    required this.focusedDay,
    required this.onDaySelected,
    Key? key
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    const PRIMARY_COLOR = Color(0xFF0DB2B2);

    final defaultBaxDeco = BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(10),
    );

    final defaultTextStyle = TextStyle(
      color: Colors.grey[600],
      fontWeight: FontWeight.w700,
    );

    return SingleChildScrollView(
      child: TableCalendar(
          focusedDay: focusedDay,
          firstDay: DateTime(1880),
          lastDay: DateTime(3000),

          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)
          ),

          calendarStyle: CalendarStyle(
            isTodayHighlighted: true,
            defaultDecoration: defaultBaxDeco,
            weekendDecoration: defaultBaxDeco,
            selectedDecoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: PRIMARY_COLOR, width: 1.0),
            ),
            outsideDecoration: BoxDecoration(
              // 달력 바깥 날짜 스타일 적용
                shape: BoxShape.rectangle),
            todayDecoration: defaultBaxDeco.copyWith(color: Colors.teal),
            defaultTextStyle: defaultTextStyle,
            weekendTextStyle: defaultTextStyle,
            selectedTextStyle: defaultTextStyle.copyWith(color: PRIMARY_COLOR),
          ),

          onDaySelected: onDaySelected,

          selectedDayPredicate: (DateTime date) {
            // 선택된 날짜를 화면에 표시
            if (selectedDay == null) {
              return false;
            }
            return date.year == selectedDay!.year &&
                date.month == selectedDay!.month &&
                date.day == selectedDay!.day;
          },


      ),
    );
  }
}
