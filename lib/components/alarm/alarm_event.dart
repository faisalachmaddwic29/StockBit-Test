part of 'alarm_bloc.dart';

@immutable
abstract class AlarmEvent {}

class AlarmStarted extends AlarmEvent {}

class AlarmGetData extends AlarmEvent {}

class InsertAlarmEvent extends AlarmEvent {
  final AlarmModel alarmModel;
  final DateTime dateTime;

  InsertAlarmEvent({required this.alarmModel, required this.dateTime});
}

class UpdateAlarmEvent extends AlarmEvent {
  final AlarmModel alarmModel;
  final bool isActive;
  final String from;

  UpdateAlarmEvent(
      {required this.alarmModel, required this.isActive, required this.from});
}

class DeleteAlarmEvent extends AlarmEvent {
  final int? id;

  DeleteAlarmEvent({required this.id});
}
