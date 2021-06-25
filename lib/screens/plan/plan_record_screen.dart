// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:chat_planner_app/functions/custom_dialog_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:chat_planner_app/models/event.dart';
import 'dart:collection';

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

final now = DateTime.now();
final firstDay = DateTime(2021, 1, 1);
final lastDay = DateTime(now.year + 1, now.month, now.day);

class PlanRecordScreen extends StatefulWidget {
  PlanRecordScreen(
      {required this.title,
      required this.eventSource,
      required this.createdTime,
      required this.deleteFunction});
  final String title;
  final Map<DateTime, List<Event>> eventSource;
  final String createdTime;
  final void Function() deleteFunction;

  static String id = 'plan_record_screen';
  @override
  _PlanRecordScreenState createState() => _PlanRecordScreenState();
}

class _PlanRecordScreenState extends State<PlanRecordScreen> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late double deviceWidthBasedStandardLength =
      MediaQuery.of(context).size.width / 9;
  late final events;

  @override
  void initState() {
    super.initState();
    events = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(widget.eventSource);

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  Widget _buildEventsMarkerNum(int day) {
    if (events == null) {
      return Container();
    }

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.teal,
      ),
      width: deviceWidthBasedStandardLength,
      child: Center(
        child: Text(
          '$day',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        actions: [
          Icon(Icons.edit),
          SizedBox(
            width: MediaQuery.of(context).size.width / 20,
          ),
          GestureDetector(
            child: Icon(Icons.done),
            onTap: () {
              print('planEndDate를 오늘로 바꿔준다');
            },
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 20,
          ),
          GestureDetector(
            child: Icon(Icons.delete),
            onTap: () {
              CustomDialogFunction.dialog(
                  context: context,
                  isTwoButton: true,
                  isLeftAlign: false,
                  onPressed: () {
                    Navigator.pop(context);
                    widget.deleteFunction();
                  },
                  title: '계획 삭제 안내',
                  text: '계획을 삭제하시겠습니까?',
                  size: 'small');
            },
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 20,
          )
        ],
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return _buildEventsMarkerNum(date.day);
                }
                return Container();
              },
            ),
            locale: 'ko-KR',
            firstDay: firstDay,
            lastDay: lastDay,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
            ),
            daysOfWeekHeight: deviceWidthBasedStandardLength,
            daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle(fontWeight: FontWeight.bold),
                weekdayStyle: TextStyle(fontWeight: FontWeight.bold)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () {},
                        title: Center(child: Text('${value[index]}')),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
