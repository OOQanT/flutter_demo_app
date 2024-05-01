import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mnd_factory/screen/calendar.dart';
import 'package:mnd_factory/screen/schedule_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../component/schedule_card.dart';
import '../riverpod/state_nodifier_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {

  Color PRIMARY_COLOR = Color(0xFF0DB2B2);
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime? focusedDay = DateTime.now();

  onDaySelected(DateTime selectedDay, DateTime focusedDay){ // 날짜를 클릭했을 때 그 날짜를 변수에 담는 로직
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }

  late final TabController controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 3, vsync: this);
    controller.addListener(() {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: renderFloatingActionButton(),
        appBar: AppBar(
          centerTitle: true,
          title: Text('MnD 스마트 재고관리'),
        ),


        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: controller,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CalendarScreen(selectedDay: selectedDay, focusedDay: focusedDay!, onDaySelected: onDaySelected,),
                SizedBox(height: 8.0,),
                _ScheduleList(selectedDate:selectedDay,)
              ],
            ),
            Center(
              child: Text('출고 화면'),
            ),
            Center(
              child: Text('재고현황 화면'),
            )
          ],
        ),


        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: controller.index,
          type: BottomNavigationBarType.fixed,
          onTap: (index){
            controller.animateTo(index);
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.south),label: '입고등록' ),
            BottomNavigationBarItem(icon: Icon(Icons.north),label: '출고등록' ),
            BottomNavigationBarItem(icon: Icon(Icons.home_work),label: '재고현황' ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton renderFloatingActionButton(){
    return FloatingActionButton(
      onPressed: (){
        showModalBottomSheet(
            isScrollControlled: true, // 모달의 크기 제한을 없애줌
            context: context,
            builder: (_) {
              return ScheduleBottomSheet(
                selectedDay: selectedDay,
              );
            });
      },
      child: Icon(Icons.add,color: Colors.white,),
      backgroundColor: PRIMARY_COLOR,
    );
  }
}

class _ScheduleList extends ConsumerWidget {

  final DateTime selectedDate;

  const _ScheduleList({
    required this.selectedDate,
    Key? key,
  }):super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final state = ref.watch(storeItemListProvider);

    return Expanded(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.separated(
              itemBuilder: (context, index){
                final item = state[index];
                return item.date == selectedDate ? ScheduleCard(name: state[index].name, code: state[index].code, quantity: state[index].quantity,) : Container();
              },
              separatorBuilder: (context, index){
                return SizedBox(height: 8.0,);
              },
              itemCount: state.length,
          ),
      ),
    );
  }
}





