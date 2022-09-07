part of 'timer_bloc.dart';

abstract class TimerState {}

class TimerInitial extends TimerState {}

class RunningState extends TimerState {
  final int ticks;
  RunningState({required this.ticks});
}

class PauseState extends TimerState {}

class ReplayState extends TimerState {}

class ResumeState extends TimerState {}
