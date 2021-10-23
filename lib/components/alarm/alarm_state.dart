part of 'alarm_bloc.dart';

@immutable
abstract class AlarmState {}

class AlarmInitial extends AlarmState {}

class AlarmSuccessAddData extends AlarmState {}

class AlarmSuccessDeleteData extends AlarmState {}

class AlarmDataIsEmpty extends AlarmState {}

class AlarmSuccessGetData extends AlarmState {
  final List<AlarmModel>? data;

  AlarmSuccessGetData({this.data});
}

class AlarmFailedGetData extends AlarmState {}

class AlarmLoading extends AlarmState {}
