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
        if (data.isEmpty) {
          emit(AlarmDataIsEmpty());
        }
        emit(AlarmSuccessGetData(data: data));
      }

      if (event is AlarmGetData) {
        emit(AlarmLoading());
        var data = await _alarmSqflite.getAlarms();

        if (data.isEmpty) {
          emit(AlarmDataIsEmpty());
        }
        emit(AlarmSuccessGetData(data: data));
      }

      if (event is InsertAlarmEvent) {
        emit(AlarmLoading());
        await _alarmSqflite.insertAlarm(event.alarmModel);
        var data = await _alarmSqflite.getAlarms();
        AlarmModel? alarmModel = AlarmModel(
          id: data.last.id,
          key: event.alarmModel.key,
          time: event.alarmModel.time,
          alarmDateTime: event.alarmModel.alarmDateTime,
          title: event.alarmModel.title,
          isPending: true,
        );
        await AlarmNotificationService.scheduleNotification(
            alarmModel: alarmModel, dateTime: event.dateTime);
        await _alarmSqflite.getAlarms().then((data) async {
          emit(AlarmSuccessGetData(data: data));
        });
      }

      if (event is UpdateAlarmEvent) {
        AlarmModel? alarmModel = AlarmModel(
          id: event.alarmModel.id,
          key: event.alarmModel.key,
          time: event.alarmModel.time,
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
        emit(AlarmDataIsEmpty());

        _alarmSqflite.deleteAlarm(event.id);
        await AlarmNotificationService.cancelNotification(id: event.id);
        emit(AlarmLoading());
        var data = await _alarmSqflite.getAlarms();

        if (data.isEmpty) {
          emit(AlarmDataIsEmpty());
        } else {
          await _alarmSqflite.getAlarms().then((data) {
            emit(AlarmSuccessGetData(data: data));
          });
        }
      }
    });
  }
}
