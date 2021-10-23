import 'package:alarm/components/alarm/alarm_bloc.dart';
import 'package:alarm/components/alarm/alarm_model.dart';
import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  final AlarmModel? payload;
  final AlarmBloc alarmBloc;
  const Detail({this.payload, required this.alarmBloc, Key? key})
      : super(key: key);
  // const Detail({this.payload});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarm ke ${payload!.id}'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            alarmBloc.add(AlarmGetData());
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text('test'),
      ),
    );
  }
}
