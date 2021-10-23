import 'dart:convert';

import 'package:alarm/components/alarm/alarm_bloc.dart';
import 'package:alarm/components/alarm/alarm_local_notification.dart';
import 'package:alarm/components/alarm/alarm_model.dart';
import 'package:alarm/components/alarm/alarm_widget.dart';
import 'package:alarm/components/clock/clock_widget.dart';
import 'package:alarm/screen/detail.dart';
import 'package:alarm/widgets/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../utils/margin_helper.dart';

class Home extends StatefulWidget {
  final AlarmBloc alarmBloc;
  const Home({Key? key, required this.alarmBloc}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // ignore: unused_field
  String? _alarmTimeString;
  DateTime? _alertTime;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    AlarmNotificationService.init(onSelectNotification: (payload) async {
      // onNotifications.add(payload);

      AlarmModel alarmModel = AlarmModel.fromJson(jsonDecode(payload));
      if (payload != null) {
        debugPrint('Notification payload : ' + payload);
        widget.alarmBloc.add(UpdateAlarmEvent(
            alarmModel: alarmModel, isActive: false, from: 'payload'));

        await Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => Detail(
              payload: alarmModel,
              alarmBloc: widget.alarmBloc,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _selectTime(BuildContext context) async {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.dial,
        helpText: "Alarm Set :",
      );
      final DateTime now = DateTime.now();
      final DateTime check =
          DateTime(now.year, now.month, now.day, now.hour, now.minute);

      if (selectedTime != null) {
        DateTime selectedDateTime = DateTime(now.year, now.month, now.day,
            selectedTime.hour, selectedTime.minute);

        // final comparation = selectedDateTime.compareTo(check);
        final duration = selectedDateTime.difference(check).inSeconds;

        if (check == selectedDateTime) {
          alertSnackbarMessage(
            context,
            key: _scaffoldKey,
            text: 'The alarm cannot be the same as the current time',
            color: Colors.green.shade500,
          );
        } else if (selectedDateTime.millisecondsSinceEpoch <=
            check.millisecondsSinceEpoch) {
          alertSnackbarMessage(
            context,
            key: _scaffoldKey,
            text: 'The alarm cannot be set before the current time',
            color: Colors.green.shade500,
          );
        } else {
          _alertTime = selectedDateTime;
          setState(() {
            _alarmTimeString = DateFormat('HH:mm').format(selectedDateTime);
          });

          var uuid = const Uuid();
          AlarmModel? alarmModel = AlarmModel(
            // id: await AlarmSqflite().getLength() + 1,
            alarmDateTime: _alertTime ?? DateTime.now(),
            key: uuid.v1(),
            time: duration.toString(),
            title: 'Alarm',
            isPending: true,
          );
          context.read<AlarmBloc>().add(InsertAlarmEvent(
              alarmModel: alarmModel, dateTime: _alertTime ?? DateTime.now()));
        }
      }
    }

    return BlocListener<AlarmBloc, AlarmState>(
      listener: (context, state) {},
      child: BlocBuilder<AlarmBloc, AlarmState>(
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _alarmTimeString = DateFormat('HH:mm').format(DateTime.now());
                _selectTime(context);
              },
              tooltip: 'Add Alarm',
              child: Icon(
                Icons.alarm,
                color: Theme.of(context).backgroundColor,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ElevatedButton(
                    //     onPressed: () {
                    //       context.read<AlarmBloc>().add(AlarmGetData());
                    //     },
                    //     child: const Text('reftesh')),
                    const ClockWidget().addMarginBottom(30),
                    alarmWidget(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
