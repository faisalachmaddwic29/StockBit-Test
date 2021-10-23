import 'package:alarm/components/alarm/alarm_sqflite.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:alarm/components/alarm/alarm_model.dart';

import 'alarm_local_notification.dart';

part 'alarm_event.dart';
part 'alarm_state.dart';

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  AlarmBloc() : super(AlarmInitial()) {
    AlarmSqflite _alarmSqflite = AlarmSqflite();

    on<AlarmEvent>((event, emit) async {
      if (event is AlarmStarted) {
        emit(AlarmLoading());
        await _alarmSqflite.initalizeDatabase();

        var data = await _alarmSqflite.getAlarms();
        emit(AlarmSuccessGetData(data: data));
      }

      if (event is AlarmGetData) {
        emit(AlarmLoading());
        var data = await _alarmSqflite.getAlarms();
        emit(AlarmSuccessGetData(data: data));
      }

      if (event is InsertAlarmEvent) {
        await _alarmSqflite.insertAlarm(event.alarmModel);
        await AlarmNotificationService.scheduleNotification(
            alarmModel: event.alarmModel, dateTime: event.dateTime);
        await _alarmSqflite.getAlarms().then((data) async {
          emit(AlarmSuccessGetData(data: data));
        });
      }

      if (event is UpdateAlarmEvent) {
        AlarmModel? alarmModel = AlarmModel(
          id: event.alarmModel.id,
          key: event.alarmModel.key,
          alarmDateTime: event.alarmModel.alarmDateTime,
          title: event.alarmModel.title,
          isPending: event.isActive,
        );
        await _alarmSqflite.updateAlarm(alarmModel);
        if (!event.isActive) {
          await AlarmNotificationService.cancelNotification(
              id: event.alarmModel.id);
        }

        if (event.from == 'payload') {
          await _alarmSqflite.getAlarms().then((data) {
            emit(AlarmSuccessGetData(data: data));
          });
        }
      }

      if (event is DeleteAlarmEvent) {
        _alarmSqflite.deleteAlarm(event.id);
        await AlarmNotificationService.cancelNotification(id: event.id);
        emit(AlarmLoading());

        await _alarmSqflite.getAlarms().then((data) {
          emit(AlarmSuccessGetData(data: data));
        });
      }
    });
  }
}
